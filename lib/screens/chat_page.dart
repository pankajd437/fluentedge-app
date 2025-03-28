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
          child: Container(
            decoration: BoxDecoration(
              color: message.isAI
                  ? const Color(0xFFE3F2FD) // Soft AI bubble background
                  : const Color(0xFF1565C0), // User message background
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(12),
                topRight: const Radius.circular(12),
                bottomLeft: Radius.circular(message.isAI ? 0 : 12),
                bottomRight: Radius.circular(message.isAI ? 12 : 0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.shade100.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Directionality(
                  textDirection: getTextDirection(isRTL),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: message.isAI ? Colors.black87 : Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Align(
                  alignment:
                      message.isAI ? Alignment.centerLeft : Alignment.centerRight,
                  child: Text(
                    timeString,
                    style: TextStyle(
                      fontSize: 10,
                      color: message.isAI
                          ? Colors.grey.shade700
                          : Colors.white.withOpacity(0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
