import 'package:flutter/material.dart';
import 'services/remedy_loader.dart';
import 'models/remedy.dart';
import 'services/bot_engine.dart';
import 'services/remedy_repository.dart';
import 'controllers/chat_controller.dart';
import 'models/chat.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isNavVisible = true;
  int _selectedIndex = 0;
  late final ChatController _chatController;
  @override
  void initState() {
    super.initState();
    final repo = RemedyRepository();
    final engine = BotEngine(repo);
    _chatController = ChatController(engine);
  }

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFFF3F0DF);
    const Color profileColor = Color(0xFFD9D9D9);
    const Color botMessageColor = Color(0xFFB6D4EE);
    const Color userMessageColor = Color(0xFFB1B4B3);
    const Color navColor = Color(0xFF2F482C);
    const Color selectedCircleColor = Color(0xFFF3F0DF);

    final double navHeight = 68;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: _selectedIndex == 0
            ? const Text(
                'ChatBot',
                style: TextStyle(fontWeight: FontWeight.w700),
              )
            : null,
        centerTitle: _selectedIndex == 0,
        leading: IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            // Reload the whole chat: re-create repository/engine/controller
            setState(() {
              final repo = RemedyRepository();
              final engine = BotEngine(repo);
              _chatController = ChatController(engine);
            });
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.note_alt_outlined),
            onPressed: () {
              // Start a new chat: clear current messages/state
              _chatController.messages.clear();
              _chatController.isTyping = false;
              _chatController.notifyListeners();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: _isNavVisible ? navHeight + 32 : 24,
            ),
            child: _selectedIndex == 0
                ? _ChatPane(
                    controller: _chatController,
                    botBubble: botMessageColor,
                    userBubble: userMessageColor,
                    profileColor: profileColor,
                  )
                : _selectedIndex == 1
                    ? const SavedContent()
                    : const ProfileContent(),
          ),
          // Toggle button near the navigation drawer
          Positioned(
            left: 16,
            bottom: _isNavVisible ? navHeight + 8 : 16,
            child: FloatingActionButton.small(
              heroTag: 'toggle-bottom-nav',
              backgroundColor: navColor,
              foregroundColor: Colors.white,
              onPressed: () => setState(() => _isNavVisible = !_isNavVisible),
              child: Icon(_isNavVisible ? Icons.expand_more : Icons.expand_less),
            ),
          ),
          // Bottom navigation drawer
          if (_isNavVisible)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Container(
                height: navHeight,
                decoration: BoxDecoration(
                  color: navColor,
                  borderRadius: BorderRadius.circular(28),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _NavIcon(
                      icon: Icons.home_filled,
                      selected: _selectedIndex == 0,
                      selectedCircleColor: selectedCircleColor,
                      onTap: () => setState(() => _selectedIndex = 0),
                    ),
                    _NavIcon(
                      icon: Icons.bookmark_border,
                      selected: _selectedIndex == 1,
                      selectedCircleColor: selectedCircleColor,
                      onTap: () => setState(() => _selectedIndex = 1),
                    ),
                    _NavIcon(
                      icon: Icons.person_outline,
                      selected: _selectedIndex == 2,
                      selectedCircleColor: selectedCircleColor,
                      onTap: () => setState(() => _selectedIndex = 2),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

enum ChatAlignment { left, right }

class _ChatPane extends StatefulWidget {
  final ChatController controller;
  final Color profileColor;
  final Color botBubble;
  final Color userBubble;
  const _ChatPane({
    required this.controller,
    required this.profileColor,
    required this.botBubble,
    required this.userBubble,
  });

  @override
  State<_ChatPane> createState() => _ChatPaneState();
}

class _ChatPaneState extends State<_ChatPane> {
  final TextEditingController _input = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChange);
    _input.dispose();
    super.dispose();
  }

  void _onChange() {
    if (mounted) setState(() {});
  }

  void _send() {
    final text = _input.text.trim();
    if (text.isEmpty) return;
    widget.controller.send(text);
    _input.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: widget.controller.messages.length,
            itemBuilder: (context, i) {
              final m = widget.controller.messages[i];
              final isBot = m.role == ChatRole.bot;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: _ChatRow(
                  alignment: isBot ? ChatAlignment.left : ChatAlignment.right,
                  profileColor: widget.profileColor,
                  bubbleColor: isBot ? widget.botBubble : widget.userBubble,
                  bubbleWidthFactor: 0.78,
                  bubbleHeight: 0,
                  text: m.text,
                ),
              );
            },
          ),
        ),
        if (widget.controller.isTyping)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: const [
                SizedBox(width: 12),
                Text('Bot is typing...'),
              ],
            ),
          ),
        _InputBar(controller: _input, onSend: _send),
      ],
    );
  }
}

class _ChatRow extends StatelessWidget {
  final ChatAlignment alignment;
  final Color profileColor;
  final Color bubbleColor;
  final double bubbleWidthFactor;
  final double bubbleHeight;
  final String? text;

  const _ChatRow({
    required this.alignment,
    required this.profileColor,
    required this.bubbleColor,
    required this.bubbleWidthFactor,
    required this.bubbleHeight,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLeft = alignment == ChatAlignment.left;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isLeft) _ProfileDot(color: profileColor),
        if (isLeft) const SizedBox(width: 12),
        Expanded(
          child: Align(
            alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: bubbleHeight > 0 ? bubbleHeight : 44,
                maxWidth: MediaQuery.of(context).size.width * bubbleWidthFactor,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: bubbleColor,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: text != null ? Text(text!) : const SizedBox.shrink(),
              ),
            ),
          ),
        ),
        if (!isLeft) const SizedBox(width: 12),
        if (!isLeft) _ProfileDot(color: profileColor),
      ],
    );
  }
}

class _ProfileDot extends StatelessWidget {
  final Color color;
  const _ProfileDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  const _InputBar({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            spreadRadius: 1,
            blurRadius: 4,
          )
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: (_) => onSend(),
              decoration: const InputDecoration(
                hintText: 'Type your message...',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            onPressed: onSend,
            icon: const Icon(Icons.send_rounded),
          ),
        ],
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final Color selectedCircleColor;
  final VoidCallback onTap;

  const _NavIcon({
    required this.icon,
    required this.selected,
    required this.selectedCircleColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Widget iconWidget = Icon(icon, color: Colors.white, size: 26);
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 56,
        height: 56,
        child: Center(
          child: selected
              ? Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: selectedCircleColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: Icon(icon, color: Colors.black87)),
                )
              : iconWidget,
        ),
      ),
    );
  }
}

// Saved screen content
class SavedContent extends StatefulWidget {
  const SavedContent({super.key});

  @override
  State<SavedContent> createState() => _SavedContentState();
}

class _SavedContentState extends State<SavedContent> {
  late Future<List<RemedyItem>> _future;

  @override
  void initState() {
    super.initState();
    _future = RemedyLoader.loadDefault();
  }

  @override
  Widget build(BuildContext context) {
    const Color headerColor = Color(0xFF2F482C);
    const Color backgroundColor = Color(0xFFF3F0DF);
    const Color cardColor = Color(0xFFD9D9D9);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: const BoxDecoration(
            color: headerColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: const Text(
            'Saved Remedies',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: FutureBuilder<List<RemedyItem>>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              final items = snapshot.data ?? [];
              if (items.isEmpty) {
                return const Center(child: Text('No saved remedies'));
              }
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, i) {
                  final r = items[i];
                  return _SavedItem(index: i + 1, title: r.title, remedies: r.remedies, date: r.date);
                },
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: const [
              Expanded(child: Text('Search For More Remedies')),
              Icon(Icons.search),
            ],
          ),
        ),
      ],
    );
  }
}

class _SavedItem extends StatelessWidget {
  final int index;
  final String title;
  final String remedies;
  final String? date;
  const _SavedItem({required this.index, required this.title, required this.remedies, this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$index. $title', style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text('Remedies Saved : $remedies'),
          const SizedBox(height: 12),
          if (date != null && date!.isNotEmpty) Text('Date : $date'),
        ],
      ),
    );
  }
}

// Profile screen content
class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    const Color headerColor = Color(0xFF2F482C);
    const Color fieldColor = Color(0xFFD9D9D9);

    Widget field(String label) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 6),
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: fieldColor.withOpacity(0.6),
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: const BoxDecoration(
            color: headerColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: const Text(
            'Profile',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 48),
                  const CircleAvatar(
                    radius: 44,
                    backgroundColor: Colors.black12,
                    child: Icon(Icons.person, size: 56, color: Colors.black54),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      _IconText(icon: Icons.settings, text: 'Settings'),
                      SizedBox(height: 8),
                      _IconText(icon: Icons.edit, text: 'Edit Information'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              field('Name'),
              const SizedBox(height: 16),
              field('Age'),
              const SizedBox(height: 16),
              field('Email ID'),
              const SizedBox(height: 16),
              field('Contact Number'),
            ],
          ),
        ),
      ],
    );
  }
}

class _IconText extends StatelessWidget {
  final IconData icon;
  final String text;
  const _IconText({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 6),
        Text(text),
      ],
    );
  }
}


