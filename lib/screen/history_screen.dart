import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/darkTheme_provider.dart';
import '../Provider/quote_provider.dart';


class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}


class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState(){
    super.initState();
    Provider.of<QuoteProvider>(context,listen: false).loadHistory();
  }
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuoteProvider>(context);
    final themeChanger = Provider.of<darkThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Quotes',style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true ,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: provider.clearHistory,
          ),
        ],
      ),
      body: provider.history.isEmpty
          ? const Center(child: Text('No Saved yet!'))
          : ListView.builder(
        itemCount: provider.history.length,
        itemBuilder: (context, index) {
          final q = provider.history[index];
          return Padding(
            key: ValueKey(q.content + q.author),
            padding: const EdgeInsets.all(12),
            child: Card(
              elevation: 15,
              child: Container(
                child: Column(
                  children: [
                    ListTile(
                      title: Text(q.content,style: TextStyle(fontSize: 15,fontStyle: FontStyle.italic),),
                      subtitle: Text(q.author,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => provider.deleteQuote(index),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          '</> Mohd Adnan Saifi',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: themeChanger.isDark ? Colors.white70 : Colors.black54,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
