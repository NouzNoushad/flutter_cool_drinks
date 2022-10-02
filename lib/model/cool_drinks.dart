import 'package:flutter/material.dart';

class CoolDrinks {
  final String name, volume, image;
  final Color color;
  final double price, rating;
  bool isFavorite;
  int count;

  CoolDrinks({
    required this.name,
    required this.volume,
    required this.image,
    required this.color,
    required this.price,
    required this.rating,
    required this.isFavorite,
    required this.count,
  });
}

final CoolDrinksList = [
  CoolDrinks(
    image: "coca_cola.png",
    name: "Coca Cola",
    volume: "750ml",
    rating: 3.8,
    price: 1,
    color: Colors.red.shade800,
    isFavorite: false,
    count: 1,
  ),
  CoolDrinks(
    image: "thums_up.png",
    name: "Thums Up",
    volume: "750ml",
    rating: 4,
    price: 1.2,
    color: Colors.blue.shade800,
    isFavorite: false,
    count: 1,
  ),
  CoolDrinks(
    image: "fanta.png",
    name: "Fanta Orange",
    volume: "750ml",
    rating: 4.2,
    price: 0.8,
    color: Colors.orange.shade800,
    isFavorite: false,
    count: 1,
  ),
  CoolDrinks(
    image: "sprite.png",
    name: "Sprite",
    volume: "750ml",
    rating: 4.3,
    price: 0.6,
    color: Colors.green.shade800,
    isFavorite: false,
    count: 1,
  ),
];
