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
    // Safely access the NavigationController
    final NavigationController controller = Get.find<NavigationController>();

    // List of labels for reference
    const labels = ['Home', 'Learn', 'AI Tutor', 'Profile'];

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("lib/assets/images/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 10.0,
              sigmaY: 10.0,
            ), // Existing blur
            child: Container(
              color: Colors.transparent, // Required for BackdropFilter
            ),
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
        // Determine active/inactive state for each label
        final currentIndex = controller.selectedIndex.value;

        // Print active/inactive state for each label (for debugging)
        for (int i = 0; i < labels.length; i++) {
          final isActive = i == currentIndex;
          debugPrint('${labels[i]} is ${isActive ? "Active" : "Inactive"}');
        }

        return NavigationBar(
          height: 80,
          elevation: 8,
          backgroundColor:
              Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          selectedIndex: currentIndex,
          onDestinationSelected: (index) {
            controller.onDestinationSelected(index);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home),
              selectedIcon: Icon(Icons.home_filled),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.menu_book),
              selectedIcon: Icon(Icons.menu_book_rounded),
              label: 'Learn',
            ),
            NavigationDestination(
              icon: Icon(Icons.speaker_notes_outlined),
              selectedIcon: Icon(Icons.speaker_notes),
              label: 'AI Tutor',
            ),
            NavigationDestination(
              icon: Icon(Icons.person),
              selectedIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        );
      }),
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
