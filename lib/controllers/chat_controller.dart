import 'package:flutter/foundation.dart';

import '../models/chat.dart';
import '../services/bot_engine.dart';

class ChatController extends ChangeNotifier {
  final BotEngine engine;
  final List<ChatMessage> messages = [];
  bool isTyping = false;

  ChatController(this.engine);

  Future<void> send(String text) async {
    if (text.trim().isEmpty) return;
    final userMsg = ChatMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      role: ChatRole.user,
      text: text,
      timestamp: DateTime.now(),
    );
    messages.add(userMsg);
    isTyping = true;
    notifyListeners();
    try {
      final replies = await engine.replyTo(text);
      messages.addAll(replies);
    } catch (e) {
      messages.add(ChatMessage(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        role: ChatRole.bot,
        text: 'Sorry, I ran into an error. Please try again. ($e)',
        timestamp: DateTime.now(),
      ));
    } finally {
      isTyping = false;
      notifyListeners();
    }
  }
}


