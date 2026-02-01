import '../models/chat.dart';
import '../models/remedy.dart';
import 'remedy_repository.dart';

class BotEngine {
  final RemedyRepository repository;
  BotEngine(this.repository);

  Future<List<ChatMessage>> replyTo(String userText) async {
    final trimmed = userText.trim();
    if (trimmed.isEmpty) {
      return [_bot('Please type an illness or symptom to search remedies.')];
    }
    final matches = await repository.search(trimmed);
    if (matches.isEmpty) {
      return [
        _bot("I couldn't find remedies for ‘$trimmed’. Try another symptom or illness."),
      ];
    }

    final List<ChatMessage> responses = [];
    responses.add(_bot('I found ${matches.length} result(s). Here are the details:'));
    for (final m in matches) {
      responses.add(_bot(_formatRemedy(m)));
    }
    return responses;
  }

  String _formatRemedy(RemedyItem item) {
    final buffer = StringBuffer()
      ..writeln(item.title)
      ..writeln('Remedies: ${item.remedies}');
    if (item.titleHi != null && item.titleHi!.isNotEmpty) {
      buffer.writeln('(${item.titleHi})');
    }
    if (item.remediesHi != null && item.remediesHi!.isNotEmpty) {
      buffer.writeln('उपचार: ${item.remediesHi}');
    }
    if (item.details != null && item.details!.isNotEmpty) {
      buffer.writeln('Details: ${item.details}');
    }
    if (item.detailsHi != null && item.detailsHi!.isNotEmpty) {
      buffer.writeln('विवरण: ${item.detailsHi}');
    }
    if (item.date != null && item.date!.isNotEmpty) {
      buffer.writeln('Date: ${item.date}');
    }
    return buffer.toString().trim();
  }

  ChatMessage _bot(String text) => ChatMessage(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        role: ChatRole.bot,
        text: text,
        timestamp: DateTime.now(),
      );
}


