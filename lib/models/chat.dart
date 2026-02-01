enum ChatRole { user, bot }

class ChatMessage {
  final String id;
  final ChatRole role;
  final String text;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.role,
    required this.text,
    required this.timestamp,
  });
}


