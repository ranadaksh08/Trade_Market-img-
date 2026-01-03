import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart'; // Added for input formatters
import 'package:agoraofolymus/components/soft_page_motion.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../components/main_shell.dart';

import '../components/my_textfield_2.dart';
import '../models/product.dart';
import '../models/shop.dart';

enum ListingType { marketplace, auction }

class AdditemPage extends StatefulWidget {
  const AdditemPage({super.key});

  @override
  State<AdditemPage> createState() => _AdditemPageState();
}

class _AdditemPageState extends State<AdditemPage> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final shortDescController = TextEditingController();
  final longDescController = TextEditingController();
  final basePriceController = TextEditingController();

  ListingType? listingType;
  bool isAuction = false;

  DateTime? auctionDate;
  TimeOfDay? auctionTime;

  final ImagePicker _picker = ImagePicker();
  List<File> _selectedImages = [];
  bool _isSubmitting = false;

  String selectedCategory = "Weapon";
  String selectedRarity = "Common";

  final List<String> categories = ["Weapon", "Armor", "Potion", "Artifact"];
  final List<String> rarities = ["Common", "Rare", "Legendary", "Mythical"];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showListingTypeDialog();
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    shortDescController.dispose();
    longDescController.dispose();
    basePriceController.dispose();
    super.dispose();
  }

  // UI: Show selection on start
  void _showListingTypeDialog() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: const Color(0xFF1A1C23),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Choose Listing Type",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            ListTile(
              leading: const Icon(Icons.store, color: Color(0xFFC9A24D)),
              title: const Text("Marketplace", style: TextStyle(color: Colors.white)),
              onTap: () {
                setState(() {
                  listingType = ListingType.marketplace;
                  isAuction = false;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.gavel, color: Color(0xFFC9A24D)),
              title: const Text("Auction", style: TextStyle(color: Colors.white)),
              onTap: () {
                setState(() {
                  listingType = ListingType.auction;
                  isAuction = true;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pickImages() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        _selectedImages = pickedFiles.map((file) => File(file.path)).toList();
      });
    }
  }

  Future<List<String>> uploadImagesToCloudinary(List<File> images) async {
    const cloudName = "dohgqcrul";
    const uploadPreset = "flutter_upload";
    List<String> urls = [];

    for (var image in images) {
      final uri = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");
      final request = http.MultipartRequest("POST", uri)
        ..fields["upload_preset"] = uploadPreset
        ..files.add(await http.MultipartFile.fromPath("file", image.path));

      final response = await request.send();
      final resBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(resBody);
        urls.add(data["secure_url"]);
      }
    }
    return urls;
  }

  Future<void> submitItem() async {
    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);

    if (nameController.text.isEmpty || _selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill required fields and add images")),
      );
      setState(() => _isSubmitting = false);
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => _isSubmitting = false);
      return;
    }

    final imageUrls = await uploadImagesToCloudinary(_selectedImages);
    if (imageUrls.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Image upload failed.")));
      setState(() => _isSubmitting = false);
      return;
    }

    final priceStr = isAuction ? basePriceController.text : priceController.text;
    final double? price = double.tryParse(priceStr);

    if (price == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invalid price format.")));
      setState(() => _isSubmitting = false);
      return;
    }

    final product = Product(
      id: '',
      name: nameController.text.trim(),
      price: price,
      shortDescription: shortDescController.text.trim(),
      longDescription: longDescController.text.trim(),
      imageUrls: imageUrls,
      rarity: selectedRarity,
      category: selectedCategory,
      ownerId: user.uid,
    );

    await context.read<Shop>().addProduct(product);
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainShell(initialIndex: 0)),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fix for white flash
      extendBodyBehindAppBar: true, // Seamless gradient
      appBar: AppBar(
        title: const Text("Add Item", style: TextStyle(color: Colors.white70)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      // 🛡️ POP SCOPE FIX: Handles the "swipe back" gesture
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          
          bool hasInput = nameController.text.isNotEmpty || _selectedImages.isNotEmpty;
          if (!hasInput) {
            Navigator.pop(context);
            return;
          }

          final shouldExit = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: const Color(0xFF1A1C23),
              title: const Text("Discard Item?", style: TextStyle(color: Colors.white)),
              content: const Text("All entered data will be lost.", style: TextStyle(color: Colors.white70)),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
                TextButton(
                  onPressed: () => Navigator.pop(context, true), 
                  child: const Text("Discard", style: TextStyle(color: Color(0xFFC9A24D)))
                ),
              ],
            ),
          );

          if (shouldExit ?? false) {
            if (context.mounted) Navigator.of(context).pop();
          }
        },
        child: SoftPageMotion(
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF0E0F13), Color(0xFF1A1C23)],
                  ),
                ),
              ),
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      // IMAGE PICKER
                      GestureDetector(
                        onTap: _isSubmitting ? null : pickImages,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 25),
                          height: 180,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1C23),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: _selectedImages.isEmpty
                              ? const Center(child: Icon(Icons.add_photo_alternate, color: Colors.white54, size: 40))
                              : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _selectedImages.length,
                                  itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(_selectedImages[index], width: 140, fit: BoxFit.cover),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      MyTextfield2(controller: nameController, hintText: "Item Name", obscureText: false),
                      const SizedBox(height: 12),
                      MyTextfield2(controller: shortDescController, hintText: "Short Description", obscureText: false),
                      const SizedBox(height: 12),
                      MyTextfield2(controller: longDescController, hintText: "Long Description", minLines: 3, maxLines: 6, obscureText: false),
                      const SizedBox(height: 12),

                      // 💰 DATA VALIDATION FIX: Price inputs restricted to numbers/decimals
                      MyTextfield2(
                        controller: isAuction ? basePriceController : priceController,
                        hintText: isAuction ? "Base Price" : "Price",
                        obscureText: false,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                      ),

                      const SizedBox(height: 12),

                      if (isAuction) ...[
                        _buildPickerTile(
                          icon: Icons.calendar_today,
                          label: auctionDate == null ? "Select Date" : auctionDate!.toLocal().toString().split(' ')[0],
                          onTap: () async {
                            final p = await showDatePicker(context: context, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)), initialDate: DateTime.now());
                            if (p != null) setState(() => auctionDate = p);
                          }
                        ),
                        const SizedBox(height: 12),
                      ],

                      // 📂 CATEGORY DROPDOWN (RESTORED)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1C23),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFF2A2A2A)),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButtonFormField<String>(
                              dropdownColor: const Color(0xFF1A1C23),
                              value: selectedCategory,
                              decoration: const InputDecoration(
                                labelText: "Category",
                                labelStyle: TextStyle(color: Color(0xFFC9A24D)),
                                border: InputBorder.none,
                              ),
                              items: categories.map((c) => DropdownMenuItem(
                                value: c,
                                child: Text(c, style: const TextStyle(color: Colors.white)),
                              )).toList(),
                              onChanged: (value) => setState(() => selectedCategory = value!),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ✨ RARITY DROPDOWN (RESTORED)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1C23),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFF2A2A2A)),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButtonFormField<String>(
                              dropdownColor: const Color(0xFF1A1C23),
                              value: selectedRarity,
                              decoration: const InputDecoration(
                                labelText: "Rarity",
                                labelStyle: TextStyle(color: Color(0xFFC9A24D)),
                                border: InputBorder.none,
                              ),
                              items: rarities.map((r) => DropdownMenuItem(
                                value: r,
                                child: Text(r, style: const TextStyle(color: Colors.white)),
                              )).toList(),
                              onChanged: (value) => setState(() => selectedRarity = value!),
                            ),
                          ),
                        ),
                      ),
                  
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: _isSubmitting ? null : submitItem,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                          backgroundColor: const Color(0xFFC9A24D),
                        ),
                        child: _isSubmitting ? const CircularProgressIndicator(color: Colors.black) : const Text("Add Item", style: TextStyle(color: Colors.black)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPickerTile({required IconData icon, required String label, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: ListTile(
        tileColor: const Color(0xFF1A1C23),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(icon, color: const Color(0xFFC9A24D)),
        title: Text(label, style: const TextStyle(color: Colors.white70)),
        onTap: onTap,
      ),
    );
  }
}