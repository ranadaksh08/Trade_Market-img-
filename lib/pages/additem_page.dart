import 'package:agoraofolymus/components/my_button.dart';
import 'package:agoraofolymus/components/my_textfield.dart';
import 'package:agoraofolymus/models/product.dart';
import 'package:agoraofolymus/models/shop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum Rarity { common, rare, legendary, mythical }

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
  Rarity selectedRarity = Rarity.common;

  final List<String> categories = [
    "Weapon",
    "Armor",
    "Potion",
    "Artifact",
  ];

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    shortDescController.dispose();
    longDescController.dispose();
    super.dispose();
  }

  void _submitItem() {
    if (nameController.text.isEmpty ||
        shortDescController.text.isEmpty ||
        longDescController.text.isEmpty ||
        priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    final double? price = double.tryParse(priceController.text);
    if (price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid price")),
      );
      return;
    }

    final product = Product(
      name: nameController.text,
      price: price,
      shortDescription: shortDescController.text,
      longDescription: longDescController.text,
      imagePath: "",
      rarity: selectedRarity.name,
      category: selectedCategory,
    );

    context.read<Shop>().addProduct(product);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(title: const Text("Add Item")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),

            MyTextfield(
              controller: nameController,
              hintText: "Item Name",
              obscureText: false,
            ),

            const SizedBox(height: 20),

            MyTextfield(
              controller: shortDescController,
              hintText: "Short description",
              obscureText: false,
            ),

            const SizedBox(height: 20),

            MyTextfield(
              controller: longDescController,
              hintText: "Detailed description",
              obscureText: false,
            ),

            const SizedBox(height: 20),

            MyTextfield(
              controller: priceController,
              hintText: "Price",
              obscureText: false,
            ),

            const SizedBox(height: 20),

            // Category
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFE0E0E0),
                  border: OutlineInputBorder(),
                  labelText: "Category",
                ),
                items: categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (value) {
                  setState(() => selectedCategory = value!);
                },
              ),
            ),

            const SizedBox(height: 20),

            // Rarity
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: DropdownButtonFormField<Rarity>(
                value: selectedRarity,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFE0E0E0),
                  border: OutlineInputBorder(),
                  labelText: "Rarity",
                ),
                items: Rarity.values
                    .map(
                      (r) => DropdownMenuItem(
                        value: r,
                        child: Text(r.name.toUpperCase()),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() => selectedRarity = value!);
                },
              ),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: MyButton(
                onTap: _submitItem,
                child: const Center(
                  child: Text(
                    "Add Item to Marketplace",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
