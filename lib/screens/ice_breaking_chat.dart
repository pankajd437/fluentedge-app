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
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasAddedWelcome) {
      _addWelcomeMessage();
      _hasAddedWelcome = true;
    }
  }

  void _addWelcomeMessage() {
    final welcomeText = AppLocalizations.of(context)!
        .getWelcomeResponse(widget.userName, widget.languagePreference);
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

    final response = AppLocalizations.of(context)!
        .getAIResponse(widget.userName, widget.languagePreference);
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

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.chatTitle(widget.userName)),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
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
          AppLocalizations.of(context)!
              .getPracticeLanguageMessage(widget.languagePreference),
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
    final isRTL = language == 'हिंदी' || language == 'Hinglish';

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
          textDirection: getTextDirection(isRTL),
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
