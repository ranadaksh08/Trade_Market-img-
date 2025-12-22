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

    await context.read<Shop>().addProduct(product);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Item")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            MyTextfield(
              controller: nameController,
              hintText: "Item Name",
              obscureText: false,
            ),
            const SizedBox(height: 12),

            MyTextfield(
              controller: shortDescController,
              hintText: "Short Description",
              obscureText: false,
            ),
            const SizedBox(height: 12),

            MyTextfield(
              controller: longDescController,
              hintText: "Long Description",
              obscureText: false,
            ),
            const SizedBox(height: 12),

            MyTextfield(
              controller: priceController,
              hintText: "Price",
              obscureText: false,
            ),

            const SizedBox(height: 20),

            // 🔽 CATEGORY DROPDOWN (RESTORED)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: DropdownButtonFormField<String>(
                initialValue: selectedCategory,
                items: categories
                    .map(
                      (c) => DropdownMenuItem(
                        value: c,
                        child: Text(c),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: "Category",
                ),
              ),
            ),

            const SizedBox(height: 15),

            // 🔽 RARITY DROPDOWN (RESTORED)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: DropdownButtonFormField<String>(
                initialValue: selectedRarity,
                items: rarities
                    .map(
                      (r) => DropdownMenuItem(
                        value: r,
                        child: Text(r),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedRarity = value!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: "Rarity",
                ),
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: submitItem,
              child: const Text("Add Item"),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
