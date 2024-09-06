import 'dart:async';

import 'package:flutter/material.dart';
import 'package:search_text_highlight_plus/data/highlight_span.dart';
import 'package:search_text_highlight_plus/search_text_highlight_plus.dart';

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:search_text_highlight_plus/data/highlight_span.dart';
import 'package:search_text_highlight_plus/search_text_highlight_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HighlightTextEditor(),
    );
  }
}

class HighlightTextEditor extends StatefulWidget {
  const HighlightTextEditor({super.key});

  @override
  State<HighlightTextEditor> createState() => _HighlightTextEditorState();
}

class _HighlightTextEditorState extends State<HighlightTextEditor> {
  late HighlightTextController _highlightTextController;
  late TextEditingController _searchController;
  late ScrollController _scrollController;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _scrollController = ScrollController();

    _highlightTextController = HighlightTextController(
      text: englishText.trim(),
      scrollController: _scrollController,
      selectedTextBackgroundColor: Colors.redAccent,
      highlightTextBackgroundColor: Colors.yellow,
      selectedHighlightedTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 19,
      ),
      highlightedTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 19,
      ),
    );
  }

  @override
  void dispose() {
    _highlightTextController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    _debounceTimer?.cancel(); // Dispose of the timer
    super.dispose();
  }

  // Debounce method to delay the search query processing
  void _onSearchChanged(String query) {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer?.cancel();
    }
    _debounceTimer = Timer(const Duration(milliseconds: 0), () { // increase the debounce timer according to your need.
      _highlightTextController.highlightSearchTerm(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Highlight Text Plus')),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Enter search term',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  _onSearchChanged(value); // Use the debounce method here
                },
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _highlightTextController.scrollController,
                child: ValueListenableBuilder<List<HighlightSpan>>(
                  valueListenable: _highlightTextController.highlightsNotifier,
                  builder: (context, highlights, child) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 16.0),
                      child: TextField(
                        // readOnly: true,
                        controller: _highlightTextController,
                        maxLines: null,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        style: const TextStyle(fontSize: 20),
                        onChanged: (value) {
                          _onSearchChanged(_searchController.text.trim());
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: () {
              _highlightTextController.highlightPrevious();
            },
            child: const Icon(Icons.arrow_upward),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              _highlightTextController.highlightNext();
            },
            child: const Icon(Icons.arrow_downward),
          ),
        ],
      ),
    );
  }
}




const englishText = '''
  In a small village, there was a small house with a small garden. The small children loved to play with their small toys in the small backyard. Every small detail of their small world brought them immense joy. The small moments they shared were forever cherished in their small hearts. In a small village, there was a small house with a small garden. The small children loved to play with their small toys in the small backyard. Every small detail of their small world brought them immense joy. The small moments they shared were forever cherished in their small hearts. In a small village, there was a small house with a small garden. The small children loved to play with their small toys in the small backyard. Every small detail of their small world brought them immense joy. The small moments they shared were forever cherished in their small hearts. In a small village, there was a small house with a small garden. The small children loved to play with their small toys in the small backyard. Every small detail of their small world brought them immense joy. The small moments they shared were forever cherished in their small hearts.
  ''';

const arabicText = '''
  في قرية صغيرة، كان هناك منزل صغير بحديقة صغيرة. أحب الأطفال الصغار اللعب بألعابهم الصغيرة في الفناء الخلفي الصغير. كل تفصيل صغير في عالمهم الصغير جلب لهم فرحة كبيرة. اللحظات الصغيرة التي شاركوها كانت محبوبة إلى الأبد في قلوبهم الصغيرة. في قرية صغيرة، كان هناك منزل صغير بحديقة صغيرة. أحب الأطفال الصغار اللعب بألعابهم الصغيرة في الفناء الخلفي الصغير. كل تفصيل صغير في عالمهم الصغير جلب لهم فرحة كبيرة. اللحظات الصغيرة التي شاركوها كانت محبوبة إلى الأبد في قلوبهم الصغيرة. في قرية صغيرة، كان هناك منزل صغير بحديقة صغيرة. أحب الأطفال الصغار اللعب بألعابهم الصغيرة في الفناء الخلفي الصغير. كل تفصيل صغير في عالمهم الصغير جلب لهم فرحة كبيرة. اللحظات الصغيرة التي شاركوها كانت محبوبة إلى الأبد في قلوبهم الصغيرة. في قرية صغيرة، كان هناك منزل صغير بحديقة صغيرة. أحب الأطفال الصغار اللعب بألعابهم الصغيرة في الفناء الخلفي الصغير. كل تفصيل صغير في عالمهم الصغير جلب لهم فرحة كبيرة. اللحظات الصغيرة التي شاركوها كانت محبوبة إلى الأبد في قلوبهم الصغيرة.
  ''';
