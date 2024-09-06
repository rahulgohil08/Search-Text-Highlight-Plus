<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

Search Text Highlight Plus is a Flutter package that allows you to highlight search terms within a text field. It provides a customizable way to highlight text with different styles and colors, and includes functionality to navigate between highlighted terms.

## Features

- **Highlight search terms** in a text field.
- **Customize** the highlight color and text style.
- **Navigate** between highlighted terms.
- **Supports** both case-sensitive and case-insensitive search.
- **Real-time editing** of the text for selected highlights.
- **Scroll** to highlighted content if it's out of the visible screen.
- **Supports** multiple languages.



## installation: 
  Add the following to your `pubspec.yaml` file:

  ```yaml
  dependencies:
    highlight_text_plus: ^0.0.4
  ```


## Usage
<img src="https://github.com/user-attachments/assets/02423568-b17e-4da1-a758-5310ce0d4053" width="200" height="400"/>







## Customization
You can customize the highlight colors and text styles by passing the appropriate parameters to the `HighlightTextController`

```dart
import 'package:search_text_highlight_plus/search_text_highlight_plus.dart';
import 'package:flutter/material.dart';

// Create an instance of HighlightTextController
final _highlightTextController = HighlightTextController(
  // The text to be displayed and highlighted
  text: englishText.trim(),

  // Controller for scrolling the text view
  scrollController: _scrollController,

  // Background color for the currently selected text
  selectedTextBackgroundColor: Colors.redAccent,

  // Background color for highlighted text
  highlightTextBackgroundColor: Colors.yellow,

  // Text style for the selected highlighted text
  selectedHighlightedTextStyle: const TextStyle(
    color: Colors.white,
    fontSize: 19,
  ),

  // Text style for non-selected highlighted text
  highlightedTextStyle: const TextStyle(
    color: Colors.black,
    fontSize: 19,
  ),
);

```



## Example
Here is a basic example of how to use the Search Text Highlight Plus package:

```dart
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
    super.dispose();
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
 
``` 


