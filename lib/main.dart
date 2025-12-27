import 'package:flutter/material.dart';
import 'package:ice_cream_ui_showcase/books_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ice Cream UI Animation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const BooksPage(),
    );
  }
}
