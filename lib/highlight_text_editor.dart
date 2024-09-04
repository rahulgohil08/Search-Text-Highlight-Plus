import 'package:flutter/material.dart';

class HighlightTextController extends TextEditingController {
  final ScrollController scrollController;
  final Color selectedTextColor;
  final TextStyle? normalTextStyle;
  final TextStyle? selectedTextStyle;
  final TextStyle? highlightedTextStyle;
  final Color highlightTextColor;
  final bool caseSensitive;
  int _currentIndex = -1;
  ValueNotifier<List<HighlightSpan>> highlightsNotifier = ValueNotifier([]);

  int get currentIndex => _currentIndex;

  int get totalHighlights => highlightsNotifier.value.length;

  HighlightTextController({
    super.text,
    required this.scrollController,
    this.selectedTextColor = Colors.lightBlue,
    this.highlightTextColor = Colors.yellow,
    this.selectedTextStyle,
    this.highlightedTextStyle,
    this.normalTextStyle,
    this.caseSensitive = false,
  });

  /// Highlight search term in the text
  void highlightSearchTerm(String searchTerm) {
    if (searchTerm.isEmpty) {
      _clearHighlights();
      _currentIndex = -1;
      return;
    }

    setHighlights(searchTerm: searchTerm, currentIndex: _currentIndex);

    if (_currentIndex == -1 && highlightsNotifier.value.isNotEmpty) {
      _currentIndex = 0;
      _scrollToCurrent();
    }
  }

  /// Set the highlights based on the search term
  void setHighlights({required String searchTerm, required int currentIndex}) {
    List<HighlightSpan> newHighlights = [];
    String fullText = text;

    String pattern = RegExp.escape(searchTerm);
    List<RegExpMatch> matches =
        RegExp(pattern, caseSensitive: caseSensitive).allMatches(fullText).toList();

    for (int i = 0; i < matches.length; i++) {
      RegExpMatch match = matches[i];
      newHighlights.add(
        HighlightSpan(
            start: match.start,
            end: match.end,
            color: i == currentIndex ? selectedTextColor : highlightTextColor,
            textStyle:
                i == currentIndex ? selectedTextStyle : highlightedTextStyle),
      );
    }

    highlightsNotifier.value = newHighlights;
  }

  void updateHighlightColor(int currentIndex) {
    List<HighlightSpan> updatedHighlights = [];
    for (int i = 0; i < highlightsNotifier.value.length; i++) {
      updatedHighlights.add(
        HighlightSpan(
            start: highlightsNotifier.value[i].start,
            end: highlightsNotifier.value[i].end,
            color: i == currentIndex ? selectedTextColor : highlightTextColor,
            textStyle:
                i == currentIndex ? selectedTextStyle : highlightedTextStyle),
      );
    }
    highlightsNotifier.value = updatedHighlights;
  }

  /// Scroll to the current highlight
  void _scrollToCurrent() {
    if (_currentIndex != -1 && highlightsNotifier.value.isNotEmpty) {
      final index = highlightsNotifier.value[_currentIndex].start;
      scrollController.animateTo(
        (index / text.length) * scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void highlightNext() {
    if (_currentIndex < highlightsNotifier.value.length - 1) {
      _currentIndex++;
      updateHighlightColor(_currentIndex);
      _scrollToCurrent();
    }
  }

  void highlightPrevious() {
    if (_currentIndex > 0) {
      _currentIndex--;
      updateHighlightColor(_currentIndex);
      _scrollToCurrent();
    }
  }

  /// Clear all highlights
  void _clearHighlights() {
    highlightsNotifier.value = [];
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    List<TextSpan> children = [];
    String fullText = value.text;
    List<HighlightSpan> highlights = highlightsNotifier.value;

    if (highlights.isEmpty) {
      children.add(TextSpan(text: fullText));
    } else {
      int lastMatchEnd = 0;
      for (HighlightSpan highlight in highlights) {
        if (lastMatchEnd < highlight.start) {
          children.add(
            TextSpan(
              text: fullText.substring(
                lastMatchEnd,
                highlight.start,
              ),
              style: normalTextStyle,
            ),
          );
        }
        children.add(
          TextSpan(
            text: fullText.substring(highlight.start, highlight.end),
            style: highlight.textStyle
                    ?.copyWith(backgroundColor: highlight.color) ??
                TextStyle(backgroundColor: highlight.color),
          ),
        );
        lastMatchEnd = highlight.end;
      }
      if (lastMatchEnd < fullText.length) {
        children.add(
          TextSpan(
            text: fullText.substring(lastMatchEnd),
            style: normalTextStyle,
          ),
        );
      }
    }

    return TextSpan(style: style, children: children);
  }
}

class HighlightSpan {
  final int start;
  final int end;
  final Color color;
  final TextStyle? textStyle;

  HighlightSpan({
    required this.start,
    required this.end,
    required this.color,
    required this.textStyle,
  });

  @override
  String toString() {
    return 'HighlightSpan{start: $start, end: $end, color: $color}';
  }
}
