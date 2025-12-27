import 'package:flutter/material.dart';

class BookItem {
  final String title;
  final String image;
  final bool enabled;
  final Color color;

  const BookItem({
    required this.title,
    required this.image,
    required this.enabled,
    required this.color,
  });

  static const List<BookItem> books = [
    BookItem(
      title: 'Foods',
      image: 'assets/images/books/book_food.png',
      enabled: false,
      color: Color(0xFFFFD6A5),
    ),
    BookItem(
      title: 'Ice Cream',
      image: 'assets/images/books/book_ice_cream.png',
      enabled: true,
      color: Color(0xFFFFC8DD),
    ),
    BookItem(
      title: 'Drinks',
      image: 'assets/images/books/book_drinks.png',
      enabled: false,
      color: Color(0xFFBDE0FE),
    ),
    BookItem(
      title: 'Cakes',
      image: 'assets/images/books/book_cakes.png',
      enabled: false,
      color: Color(0xFFD6C1FF),
    ),
  ];
}
