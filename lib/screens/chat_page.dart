import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:fluentedge_app/localization/app_localizations.dart';

// ========== Model & State Management ==========
class ChatMessage {
  final String text;
  final bool isAI;
  final DateTime timestamp;

  const ChatMessage({
    required this.text,
    required this.isAI,
    required this.timestamp,
  });
}

@immutable
class ChatState {
  final List<ChatMessage> messages;
  final bool isAIThinking;

  const ChatState({
    this.messages = const [],
    this.isAIThinking = false,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isAIThinking,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isAIThinking: isAIThinking ?? this.isAIThinking,
    );
  }
}

class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier() : super(const ChatState());

  void addMessage(String text, {required bool isAI}) {
    state = state.copyWith(
      messages: [
        ...state.messages,
        ChatMessage(
          text: text,
          isAI: isAI,
          timestamp: DateTime.now(),
        ),
      ],
    );
  }

  void setThinking(bool isThinking) {
    state = state.copyWith(isAIThinking: isThinking);
  }

  void clearChat() {
    state = const ChatState();
  }
}

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier();
});

// ========== Main Chat Page ==========
class ChatPage extends ConsumerStatefulWidget {
  static const routeName = '/chat';
  
  final String userName;
  final String languagePreference;
  
  const ChatPage({
    super.key,
    required this.userName,
    required this.languagePreference,
  });

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  late final ScrollController _scrollController;
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _textController = TextEditingController();
    _sendInitialGreeting();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _sendInitialGreeting() {
    final greeting = AppLocalizations.of(context)!
        .getWelcomeResponse(widget.userName, widget.languagePreference);
    ref.read(chatProvider.notifier).addMessage(greeting, isAI: true);
  }

  Future<void> _handleSendMessage(String message) async {
    if (message.trim().isEmpty) return;

    final notifier = ref.read(chatProvider.notifier);
    notifier.addMessage(message, isAI: false);
    notifier.setThinking(true);
    _textController.clear();
    
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    final response = AppLocalizations.of(context)!
        .getAIResponse(widget.userName, widget.languagePreference);
    
    notifier.addMessage(response, isAI: true);
    notifier.setThinking(false);
    
    _scrollToBottom();
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
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.okButton),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!
              .chatTitle
              .replaceFirst('{userName}', widget.userName),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showLanguageInfo,
            tooltip: AppLocalizations.of(context)!.languageInfoTitle,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: chatState.messages.length + (chatState.isAIThinking ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= chatState.messages.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return ChatBubble(
                  message: chatState.messages[index],
                  languagePreference: widget.languagePreference,
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
        left: 12,
        right: 12,
        top: 8,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              minLines: 1,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.messageHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _handleSendMessage(_textController.text.trim()),
                ),
              ),
              onSubmitted: (text) => _handleSendMessage(text.trim()),
            ),
          ),
        ],
      ),
    );
  }
}

// ========== Chat Bubble Widget ==========
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
                    textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
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