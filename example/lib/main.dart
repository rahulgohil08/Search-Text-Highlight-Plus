import 'package:flutter/material.dart';
import 'package:highlight_text_editor/highlight_text_editor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HighlightTextEditor(),
    );
  }
}

class HighlightTextEditor extends StatefulWidget {
  const HighlightTextEditor({super.key});

  @override
  _HighlightTextEditorState createState() => _HighlightTextEditorState();
}

class _HighlightTextEditorState extends State<HighlightTextEditor> {
  late HighlightTextController _highlightTextController;
  late TextEditingController _searchController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _scrollController = ScrollController();

    _highlightTextController = HighlightTextController(
      text: '''
  In a small village, there was a small house with a small garden. The small children loved to play with their small toys in the small backyard. Every small detail of their small world brought them immense joy. The small moments they shared were forever cherished in their small hearts. In a small village, there was a small house with a small garden. The small children loved to play with their small toys in the small backyard. Every small detail of their small world brought them immense joy. The small moments they shared were forever cherished in their small hearts. In a small village, there was a small house with a small garden. The small children loved to play with their small toys in the small backyard. Every small detail of their small world brought them immense joy. The small moments they shared were forever cherished in their small hearts. In a small village, there was a small house with a small garden. The small children loved to play with their small toys in the small backyard. Every small detail of their small world brought them immense joy. The small moments they shared were forever cherished in their small hearts.
  '''
          .trim(),
      scrollController: _scrollController,
      selectedTextColor: Colors.redAccent,
      highlightTextColor: Colors.yellow,
    );

  }

  @override
  void dispose() {
    _highlightTextController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Highlight Text Editor')),
      body: Column(
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
                // Pass the search query to the controller
                _highlightTextController.highlightSearchTerm(value);
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
                    padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 16.0),
                    child: TextField(
                      // readOnly: true,
                      controller: _highlightTextController,
                      maxLines: null,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(fontSize: 20),
                      onChanged: (value) {
                        _highlightTextController.highlightSearchTerm(
                          _searchController.text.trim(),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
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
