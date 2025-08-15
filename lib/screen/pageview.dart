import 'package:daily_quotes/screen/quote_screen.dart';
import 'package:flutter/material.dart';

import 'history_screen.dart';

class slidePage extends StatefulWidget {
  const slidePage({super.key});

  @override
  State<slidePage> createState() => _slidePageState();
}

class _slidePageState extends State<slidePage> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        scrollDirection: Axis.horizontal,
        children: const [
          QuoteScreen(), // First screen (like Instagram feed)
          HistoryScreen(),       // Second screen (like Instagram DM)
        ],
      ),
    );
  }
}
