import 'package:flutter/material.dart';

class CocktailCart extends StatelessWidget {
  final String name;
  final String imageUrl;

  const CocktailCart({super.key, required this.name, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.network(imageUrl),
          Text(name),
        ],
      ),
    );
  }
}