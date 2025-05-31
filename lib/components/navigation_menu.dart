import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:english_app_with_ai/pages/home_screen.dart';
import 'package:english_app_with_ai/pages/profile_screen.dart';
import 'package:english_app_with_ai/pages/tutor_screen.dart';
import 'package:english_app_with_ai/pages/learn_screen.dart';
import 'header.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigationController controller = Get.find<NavigationController>();
    const labels = ['Home', 'Learn', 'AI Tutor', 'Profile'];

    return Theme(
      data: Theme.of(context).copyWith(
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.grey[900], // Dark background for nav bar
          unselectedItemColor: Colors.grey[400], // Unselected items
          selectedItemColor: Colors.white, // Base color for selected item
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        ),
      ),
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("lib/assets/images/background.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(color: Colors.transparent),
            ),
            Obx(
              () => Column(
                children: [
                  const HeaderWidget(),
                  Expanded(
                    child: controller.screens[controller.selectedIndex.value],
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Obx(() {
          final currentIndex = controller.selectedIndex.value;

          return Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, -2), // Shadow above the bar
                ),
              ],
            ),
            child: NavigationBar(
              height: 80,
              elevation: 8, // Floating effect
              backgroundColor: Colors.grey[900], // Dark theme for nav bar
              selectedIndex: currentIndex,
              onDestinationSelected: (index) {
                controller.onDestinationSelected(index);
              },
              indicatorColor: Colors.blue.withOpacity(
                0.2,
              ), // Semi-transparent oval
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home),
                  selectedIcon: _GradientIcon(
                    icon: Icons.home_filled,
                    gradient: LinearGradient(
                      colors: [Color(0xFF007BFF), Color(0xFF87CEFA)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.menu_book),
                  selectedIcon: _GradientIcon(
                    icon: Icons.menu_book_rounded,
                    gradient: LinearGradient(
                      colors: [Color(0xFF007BFF), Color(0xFF87CEFA)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  label: 'Learn',
                ),
                NavigationDestination(
                  icon: Icon(Icons.speaker_notes_outlined),
                  selectedIcon: _GradientIcon(
                    icon: Icons.speaker_notes,
                    gradient: LinearGradient(
                      colors: [Color(0xFF007BFF), Color(0xFF87CEFA)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  label: 'AI Tutor',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person),
                  selectedIcon: _GradientIcon(
                    icon: Icons.person_rounded,
                    gradient: LinearGradient(
                      colors: [Color(0xFF007BFF), Color(0xFF87CEFA)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  label: 'Profile',
                ),
              ],
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            ),
          );
        }),
      ),
    );
  }
}

// Custom widget for gradient icons
class _GradientIcon extends StatelessWidget {
  final IconData icon;
  final Gradient gradient;

  const _GradientIcon({required this.icon, required this.gradient});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(bounds),
      child: Icon(icon, color: Colors.white), // Base color for gradient
    );
  }
}

class NavigationController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  final List<Widget> screens = const [
    HomeScreen(),
    LearnScreen(),
    TutorScreen(),
    ProfileScreen(),
  ];

  void onDestinationSelected(int index) {
    selectedIndex.value = index;
  }
}
