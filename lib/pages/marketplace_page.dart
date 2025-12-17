import 'package:agoraofolymus/components/my_drawer.dart';
import 'package:agoraofolymus/components/my_product_tile.dart';
import 'package:agoraofolymus/models/product.dart';
import 'package:agoraofolymus/models/shop.dart';
import 'package:agoraofolymus/pages/product_details_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  @override
  Widget build(BuildContext context) {

    //access products in shop
    final products = context.watch<Shop>().marketplace;

    return Scaffold(
      
      appBar: AppBar(),
      drawer: MyDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            //Search bar 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
              child: TextField(
                decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
              fillColor: Colors.grey.shade200,
              filled: true,
              hintText: "Search",
              hintStyle: TextStyle(
                color: Colors.grey[500],
              )
          ),
        ),
            ),
      
          Expanded(
          child: GridView.builder(
            itemCount: products.length,
            scrollDirection: Axis.vertical,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.7,
            ),
            itemBuilder: (context, index) {
              //get each individual product from shop 
              final product = products[index];
          
              //return as a product tile UI
              return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailPage(product: product),
                  ),
    );
  },
  child: MyProductTile(product: product),
);

            }
          ),
        ),    
          ],
        ),
      )
        
    );
  }
}