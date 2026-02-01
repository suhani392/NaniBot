import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F0DF),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (i) => setState(() => _index = i),
                children: const [
                  _OnboardPage(
                    title: 'Ayurvedic Health\nAssistance',
                    description:
                        'Our Nani Bot provides you with personalized Ayurvedic remedies to improve your health.',
                    imagePath: 'assets/images/onboarding1.webp',
                  ),
                  _OnboardPage(
                    title: 'Multilingual\nChat Support',
                    description:
                        'Our bot can understand your language and reply in it as well.',
                    imagePath: 'assets/images/onboarding2.webp',
                  ),
                  _OnboardPage(
                    title: 'Trusted Ayurvedic\nProducts',
                    description:
                        'Discover and explore Ayurvedic products with direct links to trusted online stores — all in one place.',
                    imagePath: 'assets/images/onboarding3.webp',
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Row(
                children: [
                  Row(
                    children: List.generate(3, (i) => _Dot(active: i == _index)),
                  ),
                  const Spacer(),
                  _PrimaryButton(
                    label: _index == 2 ? 'Get Started' : 'Next',
                    onPressed: () {
                      if (_index < 2) {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardPage extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  const _OnboardPage({
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text(
            title,
            style: GoogleFonts.limelight(
              fontSize: 32,
              height: 1.2,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: GoogleFonts.lindenHill(
              fontSize: 16,
              height: 1.4,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320, maxHeight: 360),
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final bool active;
  const _Dot({required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: active ? 12 : 8,
      height: active ? 12 : 8,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: active ? const Color(0xFF488345) : Colors.black26,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const _PrimaryButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF488345),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
        textStyle: GoogleFonts.lindenHill(fontSize: 18),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}


