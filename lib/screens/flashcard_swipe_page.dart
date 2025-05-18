import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';

class FlashcardSwipePage extends StatefulWidget {
  const FlashcardSwipePage({Key? key}) : super(key: key);

  @override
  State<FlashcardSwipePage> createState() => _FlashcardSwipePageState();
}

class _FlashcardSwipePageState extends State<FlashcardSwipePage> {
  late List<SwipeItem> _swipeItems;
  late MatchEngine _matchEngine;

  // Flashcards with question, answer, and (optional) image
  final List<Map<String, String>> _flashcards = [
    {
      "question": "Hello",
      "answer": "A polite greeting (English version of 'Namaste').",
      "image": "assets/images/hello_icon.png"
    },
    {
      "question": "Goodbye",
      "answer": "A polite way to part or leave a conversation.",
      "image": "assets/images/goodbye_icon.png"
    },
    {
      "question": "Nice to meet you",
      "answer": "Use to express happiness when meeting someone new.",
      "image": "assets/images/nice_meet_icon.png"
    },
    {
      "question": "See you soon",
      "answer": "Friendly phrase to end chat, hoping to meet again quickly.",
      "image": "assets/images/see_you_icon.png"
    },
  ];

  final List<List<Color>> _cardGradients = [
    [Colors.teal, Colors.tealAccent],
    [Colors.pinkAccent, Colors.orangeAccent],
    [Colors.blueAccent, Colors.lightBlueAccent],
    [Colors.deepPurple, Colors.purpleAccent],
  ];

  @override
  void initState() {
    super.initState();

    _swipeItems = _flashcards.map((cardData) {
      return SwipeItem(
        content: cardData,
        likeAction: () {},
        nopeAction: () {},
        superlikeAction: () {},
        onSlideUpdate: (SlideRegion? region) {},
      );
    }).toList();

    _matchEngine = MatchEngine(swipeItems: _swipeItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flashcards Demo"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: SwipeCards(
          matchEngine: _matchEngine,
          itemBuilder: (BuildContext context, int index) {
            final card = _swipeItems[index].content as Map<String, String>;
            final gradientColors = _cardGradients[index % _cardGradients.length];
            final imagePath = card["image"] ?? ""; // NEW: optional image support

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: gradientColors.first.withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // NEW: Optional image display
                  if (imagePath.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Image.asset(
                        imagePath,
                        height: 100,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.broken_image, color: Colors.white),
                      ),
                    ),
                  // Existing content
                  Text(
                    card["question"] ?? "",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    card["answer"] ?? "",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
          onStackFinished: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("All flashcards are done!")),
            );
          },
          itemChanged: (SwipeItem item, int index) {},
          upSwipeAllowed: false,
          fillSpace: true,
        ),
      ),
    );
  }
}
