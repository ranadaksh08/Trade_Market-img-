import 'dart:io';
import 'dart:convert';
import 'package:agoraofolymus/components/soft_page_motion.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../components/main_shell.dart';

import '../components/bottom_nav_bar.dart';
import '../components/my_textfield_2.dart';
import '../models/product.dart';
import '../models/shop.dart';
import 'marketplace_page.dart';

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

  final ImagePicker _picker = ImagePicker();
  List<File> _selectedImages = [];

  bool _isSubmitting = false;

  String selectedCategory = "Weapon";
  String selectedRarity = "Common";

  final List<String> categories = [
    "Weapon",
    "Armor",
    "Potion",
    "Artifact",
  ];

  final List<String> rarities = [
    "Common",
    "Rare",
    "Legendary",
    "Mythical",
  ];

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    shortDescController.dispose();
    longDescController.dispose();
    super.dispose();
  }

  // ================= PICK IMAGES =================
  Future<void> pickImages() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        _selectedImages =
            pickedFiles.map((file) => File(file.path)).toList();
      });
    }
  }

  // ================= UPLOAD IMAGES =================
  Future<List<String>> uploadImagesToCloudinary(
  List<File> images,
) async {
  const cloudName = "dohgqcrul"; // from Cloudinary dashboard
  const uploadPreset = "flutter_upload";

  List<String> urls = [];

  for (var image in images) {
    final uri = Uri.parse(
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
    );

    final request = http.MultipartRequest("POST", uri)
      ..fields["upload_preset"] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath(
        "file",
        image.path,
      ));

    final response = await request.send();
    final resBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final data = jsonDecode(resBody);
      urls.add(data["secure_url"]);
    } else {
      debugPrint("Upload failed: $resBody");
    }
  }

  return urls;
}




  // ================= SUBMIT ITEM =================
  Future<void> submitItem() async {
    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);

    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        shortDescController.text.isEmpty ||
        longDescController.text.isEmpty ||
        _selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields and add images")),
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Image upload failed. Please try again."),
        ),
      );
      setState(() => _isSubmitting = false);
      return;
    }

    final double? price = double.tryParse(priceController.text);
      if (price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid price")),
      );
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


    final shop = context.read<Shop>();
    await shop.addProduct(product);

    if (!mounted) return;

    setState(() => _isSubmitting = false);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const MainShell(initialIndex: 0), // Marketplace tab
      ),
      (route) => false,
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Add Item", style: TextStyle(color: Colors.white70)),
        backgroundColor: const Color(0xFF0E0F13),
      ),
      body: SoftPageMotion(
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
                    const SizedBox(height: 10),
        
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
                            ? const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_photo_alternate,
                                        color: Colors.white54, size: 40),
                                    SizedBox(height: 8),
                                    Text(
                                      "Tap to add images",
                                      style:
                                          TextStyle(color: Colors.white70),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _selectedImages.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(
                                        _selectedImages[index],
                                        width: 140,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
        
                    const SizedBox(height: 20),
        
                    // TEXT FIELDS
                    MyTextfield2(
                      controller: nameController,
                      hintText: "Item Name",
                      obscureText: false,
                    ),
                    const SizedBox(height: 12),
                    MyTextfield2(
                      controller: shortDescController,
                      hintText: "Short Description",
                      obscureText: false,
                    ),
                    const SizedBox(height: 12),
                    MyTextfield2(
                      controller: longDescController,
                      hintText: "Long Description",
                      minLines: 3,
                      maxLines: 6,
                      obscureText: false,
                    ),
                    const SizedBox(height: 12),
                    MyTextfield2(
                      controller: priceController,
                      hintText: "Price",
                      obscureText: false,
                    ),
        
                    const SizedBox(height: 20),
        
                    // CATEGORY
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: DropdownButtonFormField<String>(
                        dropdownColor: const Color(0xFF1A1C23),
                        value: selectedCategory,
                        items: categories
                            .map((c) => DropdownMenuItem(
                                  value: c,
                                  child: Text(c,
                                      style: const TextStyle(
                                          color: Colors.white)),
                                ))
                            .toList(),
                        onChanged: (value) =>
                            setState(() => selectedCategory = value!),
                        decoration: const InputDecoration(
                          labelText: "Category",
                          labelStyle: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
        
                    const SizedBox(height: 15),
        
                    // RARITY
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: DropdownButtonFormField<String>(
                        dropdownColor: const Color(0xFF1A1C23),
                        value: selectedRarity,
                        items: rarities
                            .map((r) => DropdownMenuItem(
                                  value: r,
                                  child: Text(r,
                                      style: const TextStyle(
                                          color: Colors.white)),
                                ))
                            .toList(),
                        onChanged: (value) =>
                            setState(() => selectedRarity = value!),
                        decoration: const InputDecoration(
                          labelText: "Rarity",
                          labelStyle: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
        
                    const SizedBox(height: 30),
        
                    ElevatedButton(
                      onPressed: _isSubmitting ? null : submitItem,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 40),
                        backgroundColor: const Color(0xFFC9A24D),
                      ),
                      child: _isSubmitting
                          ? const CircularProgressIndicator(
                              color: Colors.black,
                            )
                          : const Text(
                              "Add Item",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                    ),
        
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
