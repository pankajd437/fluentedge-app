import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fluentedge_app/constants.dart';
import 'package:fluentedge_app/widgets/animated_mentor_widget.dart';
import 'chat_bubble.dart';

class IceBreakingChatPage extends StatefulWidget {
  final String userName;
  final String languagePreference;

  const IceBreakingChatPage({
    Key? key,
    required this.userName,
    required this.languagePreference,
  }) : super(key: key);

  @override
  State<IceBreakingChatPage> createState() => _IceBreakingChatPageState();
}

class _IceBreakingChatPageState extends State<IceBreakingChatPage> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isSending = false;

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessage(
      text: text.trim(),
      timestamp: DateTime.now(),
      isAI: false,
    );

    setState(() {
      _messages.add(userMessage);
      _controller.clear();
    });

    _scrollToBottom();

    _simulateAIResponse();
  }

  void _simulateAIResponse() async {
    setState(() => _isSending = true);

    await Future.delayed(const Duration(seconds: 1));

    final aiMessage = ChatMessage(
      text: "That's a great start, ${widget.userName}! 😄",
      timestamp: DateTime.now(),
      isAI: true,
    );

    setState(() {
      _messages.add(aiMessage);
      _isSending = false;
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isHindi = widget.languagePreference == 'हिंदी';

    return Scaffold(
      backgroundColor: kBackgroundSoftBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => GoRouter.of(context).pop(),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [kPrimaryBlue, kSecondaryBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          isHindi ? '🤖 चैट सहायक' : '🤖 Ice-Breaking Chat',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return ChatBubble(
                    message: _messages[index],
                    languagePreference: widget.languagePreference,
                  );
                },
              ),
            ),
            if (_isSending)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Center(child: CircularProgressIndicator()),
              ),
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.send,
              onSubmitted: _sendMessage,
              style: const TextStyle(fontSize: 14.5),
              decoration: InputDecoration(
                hintText: widget.languagePreference == 'हिंदी'
                    ? "अपना संदेश लिखें..."
                    : "Type your message...",
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () => _sendMessage(_controller.text),
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Icon(Icons.send, size: 18),
          ),
        ],
      ),
    );
  }
}
