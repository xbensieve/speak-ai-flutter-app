import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/header.dart';
import '../components/navigation_menu.dart';

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
    await flutterTts.speak(
      "Hi, Buddy! What would you like to achieve today?",
    );
  }

  @override
  Widget build(BuildContext context) {
    final NavigationController navController =
        Get.find<NavigationController>();

    return Scaffold(
      drawer: Drawer(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
          side: BorderSide.none,
        ),
        backgroundColor: const Color(0xFF1F1F39),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.home_filled,
                  color: Colors.greenAccent,
                  size: 40,
                ),
                title: Text(
                  'Home',
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                onTap: () {
                  navController.onDestinationSelected(
                    1,
                  ); // Navigate to Courses
                  Navigator.pop(
                    context,
                  ); // Close the drawer
                },
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(
                  Icons.book,
                  color: Colors.purpleAccent,
                  size: 40,
                ),
                title: Text(
                  'Courses',
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                onTap: () {
                  navController.onDestinationSelected(
                    1,
                  ); // Navigate to Courses
                  Navigator.pop(
                    context,
                  ); // Close the drawer
                },
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(
                  Icons.school_rounded,
                  color: Colors.blueAccent,
                  size: 40,
                ),
                title: Text(
                  'Learn',
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                onTap: () {
                  navController.onDestinationSelected(
                    2,
                  ); // Navigate to Learn
                  Navigator.pop(
                    context,
                  ); // Close the drawer
                },
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(
                  Icons.person_rounded,
                  color: Colors.orangeAccent,
                  size: 40,
                ),
                title: Text(
                  'Profile',
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                onTap: () {
                  navController.onDestinationSelected(
                    4,
                  ); // Navigate to Profile
                  Navigator.pop(
                    context,
                  ); // Close the drawer
                },
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            children: [
              const HeaderWidget(),
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
                        margin: const EdgeInsets.symmetric(
                          vertical: 6,
                        ),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(10),
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
                    icon: Icons.menu_book_sharp,
                    onPressed:
                        () => navController
                            .onDestinationSelected(1),
                  ),
                  OptionButton(
                    label: "Talk",
                    icon: Icons.chat_outlined,
                    onPressed:
                        () => navController
                            .onDestinationSelected(3),
                  ),
                  OptionButton(
                    label: "Role Play",
                    icon: Icons.record_voice_over_outlined,
                    onPressed:
                        () => navController
                            .onDestinationSelected(3),
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
            borderRadius: BorderRadius.circular(25),
            side: const BorderSide(color: Colors.white),
          ),
        ),
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
