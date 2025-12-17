import 'package:agoraofolymus/models/product.dart';
import 'package:agoraofolymus/models/shop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


enum Rarity {common, rare, legendary, mythical}

class AdditemPage extends StatefulWidget {
  const AdditemPage({super.key});

  @override
  State<AdditemPage> createState() => _AdditemPageState();
}

class _AdditemPageState extends State<AdditemPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  String selectedCategory = "Weapon";
  Rarity selectedRarity = Rarity.common;

  final List<String> categories = [
      "Weapon",
      "Armor",
      "Potion",
      "Artifact",
  ];

  @override
  //Dispose details if leave page
  void dispose(){
    nameController.dispose();
    descController.dispose();
    priceController.dispose();
    super.dispose();
  }

  //Fill all details
  void _submitItem(){
    if(nameController.text.isEmpty || 
       descController.text.isEmpty ||
       priceController.text.isEmpty){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill all fields"))
        );
       return;
  }

  final product = Product(
    name: nameController.text,
    description: descController.text,
    price: double.parse(priceController.text),
    rarity: selectedRarity.name,
    imagePath: "",
    category: selectedCategory,
   );

   context.read<Shop>().addProduct(product);

  Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text("Add Item"),
      ),

    

      body: Center(
        
        child: Column(
          children: [

          const SizedBox(height: 50),

          //item name textfield 
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              ),
            hintText: "Item Name",
            hintStyle: TextStyle(
              color: Colors.grey[500],
            )
        ),
      ),
    ),

          const SizedBox(height: 50),
          //image textfield 
          /*Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextField(
              decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              ),
            hintText: "Select Image",
            hintStyle: TextStyle(
              color: Colors.grey[500],
            )
        ),
      ),
    ),*/

          const SizedBox(height: 50),
          
          //short description text field 
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextField(
              controller: descController,
              decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              ),
            hintText: "Short description about your item...",
            hintStyle: TextStyle(
              color: Colors.grey[500],
            )
        ),
      ),
    ),
          const SizedBox(height: 50),
        
          //price 
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              ),
              hintText: "Add Price",
              hintStyle: TextStyle(
              color: Colors.grey[500],
            )
        ),
      ),
    ),
          

          //rarity level option 

      
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: _submitItem,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}