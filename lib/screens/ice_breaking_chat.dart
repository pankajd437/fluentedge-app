import 'package:flutter/material.dart';
import 'package:fluentedge_frontend/localization/app_localizations.dart';

class IceBreakingChatPage extends StatefulWidget {
  final String userName;
  final String languagePreference;
  
  const IceBreakingChatPage({
    super.key,
    required this.userName,
    required this.languagePreference,
  });

  @override
  State<IceBreakingChatPage> createState() => _IceBreakingChatPageState();
}

class _IceBreakingChatPageState extends State<IceBreakingChatPage> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isAIThinking = false;

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    final localizations = AppLocalizations.of(context)!;
    final welcomeText = widget.languagePreference == "English"
      ? 'Hi ${widget.userName}! Ready to practice English?'
      : widget.languagePreference == "हिंदी"
        ? 'नमस्ते ${widget.userName}! अंग्रेज़ी का अभ्यास करने के लिए तैयार हैं?'
        : 'Hi ${widget.userName}! English practice ke liye taiyaar ho?';

    _addMessage(welcomeText, isAI: true);
  }

  void _addMessage(String text, {required bool isAI}) {
    setState(() {
      _messages.add(ChatMessage(text: text, isAI: isAI));
      _scrollToBottom();
    });
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.isEmpty) return;
    
    final userMessage = _messageController.text;
    _messageController.clear();
    _addMessage(userMessage, isAI: false);
    
    setState(() => _isAIThinking = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    final response = _generateAIResponse(userMessage);
    _addMessage(response, isAI: true);
    setState(() => _isAIThinking = false);
  }

  String _generateAIResponse(String userMessage) {
    final localizations = AppLocalizations.of(context)!;
    
    if (widget.languagePreference == "English") {
      return "That's a great start, ${widget.userName}! Let's practice some more.";
    } else if (widget.languagePreference == "हिंदी") {
      return "बहुत अच्छा प्रारंभ, ${widget.userName}! आइए कुछ और अभ्यास करें।";
    } else {
      return "Bahut accha shuruat, ${widget.userName}! Chalo kuch aur practice karein.";
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.chatTitle.replaceFirst('{name}', widget.userName)),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => _showLanguageInfo(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8),
              itemCount: _messages.length + (_isAIThinking ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= _messages.length) {
                  return const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                
                final message = _messages[index];
                return ChatBubble(
                  message: message.text,
                  isAI: message.isAI,
                  language: widget.languagePreference,
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 8,
        right: 8,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.messageHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
            color: Colors.blueAccent,
          ),
        ],
      ),
    );
  }

  void _showLanguageInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.languageInfoTitle),
        content: Text(
          widget.languagePreference == "English"
            ? "We're practicing in English mode"
            : widget.languagePreference == "हिंदी"
              ? "हम हिंदी मोड में अभ्यास कर रहे हैं"
              : "Hum Hinglish mode mein practice kar rahe hain",
        ),
        actions: [
          TextButton(
            child: Text(AppLocalizations.of(context)!.okButton),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class ChatMessage {
  final String text;
  final bool isAI;

  ChatMessage({required this.text, required this.isAI});
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isAI;
  final String language;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isAI,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    final textDirection = language == "हिंदी" ? TextDirection.rtl : TextDirection.ltr;
    
    return Align(
      alignment: isAI ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isAI ? Colors.blue.shade50 : Colors.blueAccent,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: isAI ? Radius.zero : const Radius.circular(12),
            bottomRight: isAI ? const Radius.circular(12) : Radius.zero,
          ),
        ),
        child: Directionality(
          textDirection: textDirection,
          child: Text(
            message,
            style: TextStyle(
              color: isAI ? Colors.black : Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}