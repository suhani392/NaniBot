# NaniBot

**Traditional Ayurvedic Wisdom in Your Pocket.**

NaniBot is a caring, multilingual digital assistant designed to feel like your own grandmother (Nani). It provides natural, home-based Ayurvedic remedies for common health issues like headaches, fever, indigestion, and more. 


## Features

- **Caring "Nani" Persona**: Interacts with you in a warm, conversational manner, offering advice just like a grandmother would.
- **Multilingual Support**: Currently supports **English** and **Hindi**, making traditional wisdom accessible to more people.
- **Authentic Ayurvedic Remedies**: Suggests remedies based on traditional herbs like Tulsi, Ginger, Brahmi, and Triphala.
- **Modern & Traditional UI**: A beautiful Flutter-based interface that combines modern design with traditional aesthetics.
- **Saved Remedies**: Bookmark your favorite remedies for quick access later.
- **Personas & Safety**: Includes specific remedy tags for adults, kids, and even pregnancy-safe suggestions.

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed on your machine.
- A mobile emulator or physical device for testing.

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/suhani392/NaniBot.git
   cd NaniBot
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

## Project Structure

- `lib/services`: Core logic for bot interaction and remedy loading.
- `lib/models`: Data models for chat messages and remedies.
- `lib/home_screen.dart`: Main UI with chat and navigation.
- `assets/data/remedies.json`: The knowledge base for Ayurvedic remedies.

## Built With

- [Flutter](https://flutter.dev/) - UI Framework
- [Dart](https://dart.dev/) - Programming Language
- [Google Fonts](https://pub.dev/packages/google_fonts) - Typography

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---
*Disclaimer: NaniBot provides general home remedies based on traditional Ayurvedic practices. It is not a substitute for professional medical advice. Always consult a doctor for serious conditions.*
