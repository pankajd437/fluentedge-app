import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../utils/text_direction_utils.dart';

class ChatMessage {
  final String text;
  final DateTime timestamp;
  final bool isAI;

  ChatMessage({
    required this.text,
    required this.timestamp,
    required this.isAI,
  });
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final String languagePreference;

  const ChatBubble({
    super.key,
    required this.message,
    required this.languagePreference,
  });

  @override
  Widget build(BuildContext context) {
    final timeString = DateFormat('h:mm a').format(message.timestamp);
    final isRTL = languagePreference == 'हिंदी' || languagePreference == 'Hinglish';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Align(
        alignment: message.isAI ? Alignment.centerLeft : Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.8,
          ),
          child: Card(
            color: message.isAI
                ? Theme.of(context).colorScheme.surfaceVariant
                : Theme.of(context).colorScheme.primary,
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(message.isAI ? 0 : 16),
                bottomRight: Radius.circular(message.isAI ? 16 : 0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      color: message.isAI
                          ? Theme.of(context).colorScheme.onSurfaceVariant
                          : Theme.of(context).colorScheme.onPrimary,
                      fontSize: 16,
                    ),
                    textDirection: getTextDirection(isRTL),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    timeString,
                    style: TextStyle(
                      color: message.isAI
                          ? Theme.of(context).colorScheme.outline
                          : Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
