import 'package:flutter/material.dart';

class IceCream {
  final String name;
  final String image;
  final String overlayImage;
  final Color color;

  const IceCream({
    required this.name,
    required this.image,
    required this.overlayImage,
    required this.color,
  });
}

final List<IceCream> iceCreamList = [
  IceCream(
    name: "Vanilla",
    image: "assets/images/ice_cream/vanilla.png",
    overlayImage: "assets/images/ice_cream/vanilla_bits.png",
    color: const Color(0xFFFFE3B5),
  ),
  IceCream(
    name: "Strawberry",
    image: "assets/images/ice_cream/strawberry.png",
    overlayImage: "assets/images/ice_cream/strawberry_bits.png",
    color: const Color(0xFFFFB3C7),
  ),
  IceCream(
    name: "Peach",
    image: "assets/images/ice_cream/peach.png",
    overlayImage: "assets/images/ice_cream/peach_bits.png",
    color: const Color(0xFFFFC8A2),
  ),

  IceCream(
    name: "Chocolate",
    image: "assets/images/ice_cream/chocolate.png",
    overlayImage: "assets/images/ice_cream/chocolate_bits.png",
    color: const Color(0xFFD7B899),
  ),
  IceCream(
    name: "Raspberry",
    image: "assets/images/ice_cream/raspberry.png",
    overlayImage: "assets/images/ice_cream/raspberry_bits.png",
    color: const Color(0xFFD99AAE),
  ),
];
