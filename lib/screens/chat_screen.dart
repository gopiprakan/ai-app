import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_providers.dart';
import '../widgets/glass_card.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    ref.read(chatMessagesProvider.notifier).sendMessage(_messageController.text.trim());
    _messageController.clear();
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatMessagesProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Smart Assistant'),
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new_rounded)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0C1410), Color(0xFF1B5E20)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: messages.isEmpty 
                  ? _buildWelcome()
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(20),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final msg = messages[index];
                        final isUser = msg['role'] == 'user';
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Align(
                            alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                              child: GlassCard(
                                opacity: isUser ? 0.2 : 0.1,
                                borderRadius: 15,
                                child: Text(msg['message'] ?? ""),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
              ),
              _buildInputArea(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcome() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.psychology_outlined, size: 80, color: Colors.greenAccent),
          const SizedBox(height: 20),
          const Text(
            "Hello, Farmer!",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Text(
            "Ask me anything about your crops.",
            style: TextStyle(color: Colors.white60),
          ),
          const SizedBox(height: 30),
          Wrap(
            spacing: 10,
            children: [
              _suggestionChip("Best fertilizer for paddy?"),
              _suggestionChip("Tomato leaf turning yellow?"),
              _suggestionChip("Irrigation for cotton?"),
            ],
          )
        ],
      ),
    );
  }

  Widget _suggestionChip(String label) {
    return ActionChip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      onPressed: () {
        _messageController.text = label;
        _sendMessage();
      },
      backgroundColor: Colors.white10,
    );
  }

  Widget _buildInputArea() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        borderRadius: 30,
        child: Row(
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.attach_file, color: Colors.white60)),
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: "Type a detailed query...",
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            IconButton(
              onPressed: _sendMessage,
              icon: const CircleAvatar(
                backgroundColor: Colors.greenAccent,
                radius: 18,
                child: Icon(Icons.send_rounded, color: Colors.black, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
