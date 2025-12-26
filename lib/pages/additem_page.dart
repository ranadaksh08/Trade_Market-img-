import 'package:agoraofolymus/components/bottom_nav_bar.dart';
import 'package:agoraofolymus/components/my_textfield_2.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../models/shop.dart';
import '../components/my_textfield.dart';

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

  Future<void> submitItem() async {
    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        shortDescController.text.isEmpty ||
        longDescController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    final userId = FirebaseAuth.instance.currentUser!.uid;

    final product = Product(
      id: '',
      name: nameController.text.trim(),
      price: double.parse(priceController.text),
      shortDescription: shortDescController.text.trim(),
      longDescription: longDescController.text.trim(),
      imagePath: '',
      rarity: selectedRarity,
      category: selectedCategory,
      ownerId: userId,
    );

      // 🔥 DEFINE shop ONCE
  final shop = context.read<Shop>();

  await shop.addProduct(product);
  
    

    Navigator.pop(context);
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.transparent,

    bottomNavigationBar: const BottomNavBar(
      currentIndex: 1,
      backgroundColor: Color(0xFF1A1C23),
    ),

    appBar: AppBar(
      title: const Text(
        "Add Item",
        style: TextStyle(
          color: Colors.white70, 
        ),),
      backgroundColor: const Color(0xFF0E0F13),
      elevation: 0,
    ),

    body: Stack(
      children: [
        // 🔹 BACKGROUND
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0E0F13),
                Color(0xFF1A1C23),
              ],
            ),
          ),
        ),

        // 🔹 CONTENT
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                const SizedBox(height: 10),

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
                        .map(
                          (c) => DropdownMenuItem(
                            value: c,
                            child: Text(
                              c,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() => selectedCategory = value!);
                    },
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
                        .map(
                          (r) => DropdownMenuItem(
                            value: r,
                            child: Text(
                              r,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() => selectedRarity = value!);
                    },
                    decoration: const InputDecoration(
                      labelText: "Rarity",
                      labelStyle: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                ElevatedButton(
                  onPressed: submitItem,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 40,
                    ),
                    backgroundColor: const Color(0xFFC9A24D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "Add Item",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
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
  );
}

}
