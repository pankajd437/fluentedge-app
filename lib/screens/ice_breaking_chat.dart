import 'package:flutter/material.dart';
import 'package:fluentedge_app/localization/app_localizations.dart';
import 'package:fluentedge_app/utils/text_direction_utils.dart';

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
  bool _hasAddedWelcome = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasAddedWelcome) {
      _addWelcomeMessage();
      _hasAddedWelcome = true;
    }
  }

  void _addWelcomeMessage() {
    final response = _getWelcomeResponse();
    _addMessage(response, isAI: true);
  }

  void _addMessage(String text, {required bool isAI}) {
    setState(() {
      _messages.add(ChatMessage(text: text, isAI: isAI));
      _scrollToBottom();
    });
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final userMessage = _messageController.text.trim();
    _messageController.clear();
    _addMessage(userMessage, isAI: false);

    setState(() => _isAIThinking = true);
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    final response = _getAIResponse();
    _addMessage(response, isAI: true);
    setState(() => _isAIThinking = false);
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

  String _getWelcomeResponse() {
    final name = widget.userName;
    final lang = widget.languagePreference.toLowerCase();

    if (lang.contains('hi')) {
      return 'नमस्ते $name! अभ्यास शुरू करें?';
    } else {
      return 'Hi $name! Ready to start your English journey?';
    }
  }

  String _getAIResponse() {
    final lang = widget.languagePreference.toLowerCase();
    return lang.contains('hi')
        ? 'मैं आपकी मदद के लिए यहाँ हूँ! कोई भी सवाल पूछें।'
        : 'I’m here to help! Ask me anything to get started.';
  }

  void _showLanguageInfo() {
    final lang = widget.languagePreference.toLowerCase();
    final localizations = AppLocalizations.of(context);

    final title = lang.contains('hi') ? 'आप किस भाषा में अभ्यास करना चाहेंगे?' : 'Preferred Practice Language';
    final message = lang.contains('hi')
        ? 'आपने भाषा पसंद में हिंदी चुनी है। यह अभ्यास अनुभव को प्रभावित करेगा।'
        : 'You’ve selected English as your preferred language. This affects how you practice.';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        content: Text(message),
        actions: [
          TextButton(
            child: Text(localizations.okButton),
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

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          localizations.chatTitle(widget.userName),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.language, color: Colors.white),
            onPressed: _showLanguageInfo,
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
          _buildMessageInput(localizations),
        ],
      ),
    );
  }

  Widget _buildMessageInput(AppLocalizations localizations) {
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
                hintText: localizations.messageHint,
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
            color: const Color(0xFF1565C0),
          ),
        ],
      ),
    );
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
    final isRTL = language == 'हिंदी' || language == 'Hinglish';

    return Align(
      alignment: isAI ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isAI ? const Color(0xFFE3F2FD) : const Color(0xFF1565C0),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: isAI ? Radius.zero : const Radius.circular(12),
            bottomRight: isAI ? const Radius.circular(12) : Radius.zero,
          ),
        ),
        child: Directionality(
          textDirection: getTextDirection(isRTL),
          child: Text(
            message,
            style: TextStyle(
              color: isAI ? const Color(0xFF0D47A1) : Colors.white,
              fontSize: 14.5,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ),
    );
  }
}
