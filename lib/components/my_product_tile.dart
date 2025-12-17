import 'package:agoraofolymus/models/product.dart';
import 'package:flutter/material.dart';

class MyProductTile extends StatelessWidget {
  final Product product;

  const MyProductTile({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(25),
        child: Column(
            children: [
                //product image
                Icon(Icons.favorite),

                //product name
                Text(product.name),
                
                //profuct description 
                Text(product.description),

                //product category
                Text(product.category),

                //product rarity
                Text(product.rarity),

                //product price 
                Text(product.price.toString()),
                
            ],
        ),
    );
  }
}