import 'package:flutter/material.dart';

class IceBreakingChatPage extends StatelessWidget {
  const IceBreakingChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ice-Breaking Chat')),
      body: const Center(child: Text('This is the Ice-Breaking Chat Page')),
    );
  }
}
