import 'package:daily_quotes/screen/pageview.dart';
import 'package:daily_quotes/screen/quote_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Provider/darkTheme_provider.dart';
import 'Provider/quote_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QuoteProvider()),
        ChangeNotifierProvider(create: (_) => darkThemeProvider()),

        // You can add more providers here if needed
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<darkThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quotes',
      themeMode: provider.themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const slidePage(),
    );
  }
}
