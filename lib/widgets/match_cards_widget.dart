import 'package:flutter/material.dart';

class MatchCardsWidget extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> pairs;
  final String? imagePath;
  final VoidCallback onCompleted;

  const MatchCardsWidget({
    Key? key,
    required this.title,
    required this.pairs,
    this.imagePath,
    required this.onCompleted,
  }) : super(key: key);

  @override
  State<MatchCardsWidget> createState() => _MatchCardsWidgetState();
}

class _MatchCardsWidgetState extends State<MatchCardsWidget> {
  late List<String> terms;
  late List<String> definitions;
  Map<String, String?> selectedMatches = {};
  Map<String, bool> isCorrect = {};
  bool completed = false;

  @override
  void initState() {
    super.initState();
    terms = widget.pairs.map((e) => e['term'] as String).toList();
    definitions = widget.pairs.map((e) => e['definition'] as String).toList();
    definitions.shuffle();
    selectedMatches = {for (var term in terms) term: null};
    isCorrect = {for (var term in terms) term: false};
  }

  void checkAnswers() {
    bool allCorrect = true;
    for (var pair in widget.pairs) {
      String term = pair['term'] as String;
      String correctDef = pair['definition'] as String;
      if (selectedMatches[term] == correctDef) {
        isCorrect[term] = true;
      } else {
        isCorrect[term] = false;
        allCorrect = false;
      }
    }
    setState(() {
      completed = true;
    });
    if (allCorrect) {
      Future.delayed(const Duration(milliseconds: 700), widget.onCompleted);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        if (widget.imagePath != null && widget.imagePath!.isNotEmpty) ...[
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(widget.imagePath!, height: 120, fit: BoxFit.cover),
          ),
        ],
        const SizedBox(height: 16),
        Text(
          "Tap a phrase, then its matching scenario.",
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
        const SizedBox(height: 18),
        _buildTapToMatchTable(),
        const SizedBox(height: 18),
        if (!completed)
          Center(
            child: ElevatedButton(
              onPressed: selectedMatches.values.any((v) => v == null) ? null : checkAnswers,
              child: const Text("Check"),
            ),
          )
        else
          Center(
            child: ElevatedButton(
              onPressed: widget.onCompleted,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text("Continue"),
            ),
          ),
      ],
    );
  }

  // --- Tap-to-match logic ---
  String? selectedTerm;
  String? selectedDef;

  Widget _buildTapToMatchTable() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Terms column
        Expanded(
          child: Column(
            children: terms.map((term) {
              bool matched = selectedMatches[term] != null;
              return GestureDetector(
                onTap: completed
                    ? null
                    : () {
                        setState(() {
                          selectedTerm = term;
                          selectedDef = null;
                        });
                      },
                child: Card(
                  color: completed
                      ? (isCorrect[term]! ? Colors.green[100] : Colors.red[100])
                      : selectedTerm == term
                          ? Colors.blue[50]
                          : matched
                              ? Colors.grey[200]
                              : Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                  child: ListTile(
                    title: Text(term, style: const TextStyle(fontSize: 16)),
                    subtitle: selectedMatches[term] != null
                        ? Text(
                            "Matched: ${selectedMatches[term]}",
                            style: const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),
                          )
                        : null,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        // Definitions column
        Expanded(
          child: Column(
            children: definitions.map((def) {
              bool isSelectedDef = selectedDef == def;
              bool alreadyMatched = selectedMatches.values.contains(def);
              return GestureDetector(
                onTap: completed ||
                        selectedTerm == null ||
                        alreadyMatched && selectedMatches.entries.firstWhere((e) => e.value == def).key != selectedTerm
                    ? null
                    : () {
                        setState(() {
                          if (selectedTerm != null) {
                            // Remove previous assignment of this def
                            for (var t in terms) {
                              if (selectedMatches[t] == def) {
                                selectedMatches[t] = null;
                              }
                            }
                            selectedMatches[selectedTerm!] = def;
                            selectedTerm = null;
                            selectedDef = null;
                          }
                        });
                      },
                child: Card(
                  color: completed
                      ? (isSelectedDef
                          ? Colors.orange[50]
                          : alreadyMatched
                              ? Colors.blue[50]
                              : Colors.white)
                      : alreadyMatched
                          ? Colors.grey[100]
                          : Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                  child: ListTile(
                    title: Text(def, style: const TextStyle(fontSize: 16)),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
