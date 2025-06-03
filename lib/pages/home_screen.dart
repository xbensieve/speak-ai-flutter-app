import 'package:english_app_with_ai/components/my_button.dart';
import 'package:english_app_with_ai/pages/role_play_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/navigation_menu.dart';
import 'learn_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlutterTts flutterTts = FlutterTts();
  final List<String> messages = [
    "Hi, Buddy!",
    "What would you like to achieve today?",
  ];
  static bool _hasSpoken = false;
  @override
  void initState() {
    super.initState();
    if (!_hasSpoken) {
      _speakWelcome();
      _hasSpoken = true;
    }
  }

  Future<void> _speakWelcome() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.speak("Hi, Buddy! What would you like to achieve today?");
  }

  @override
  Widget build(BuildContext context) {
    final NavigationController navController = Get.find<NavigationController>();
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            children: [
              Image.asset(
                'lib/assets/images/bunny-3d.png',
                width: 300,
                height: 300,
                fit: BoxFit.contain,
              ),
              // Chat messages
              Expanded(
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          messages[index],
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Column(
                children: [
                  OptionButton(
                    label: "Courses",
                    icon: Icons.menu_book,
                    onPressed: () => navController.onDestinationSelected(1),
                  ),
                  OptionButton(
                    label: "Talk",
                    icon: Icons.chat_bubble,
                    onPressed: () => navController.onDestinationSelected(2),
                  ),
                  OptionButton(
                    label: "Role Play",
                    icon: Icons.record_voice_over,
                    onPressed: () => navController.onDestinationSelected(2),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OptionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const OptionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Colors.white),
          ),
        ),
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
