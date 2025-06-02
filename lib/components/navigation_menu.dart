import 'package:english_app_with_ai/pages/role_play_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:english_app_with_ai/pages/home_screen.dart';
import 'package:english_app_with_ai/pages/profile_screen.dart';
import 'package:english_app_with_ai/pages/learn_screen.dart';

import 'header.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigationController controller = Get.find<NavigationController>();
    const labels = ['Home', 'Learn', 'Role-play', 'Profile'];

    return Theme(
      data: Theme.of(context).copyWith(
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: const Color(0xFF1F1F39),
          indicatorColor: Colors.blue.withOpacity(0.2),
          labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>((
            states,
          ) {
            if (states.contains(MaterialState.selected)) {
              return const TextStyle(color: Colors.blue);
            }
            return const TextStyle(color: Colors.white);
          }),
          iconTheme: MaterialStateProperty.resolveWith<IconThemeData>((states) {
            if (states.contains(MaterialState.selected)) {
              return const IconThemeData(color: Colors.blue);
            }
            return const IconThemeData(color: Colors.white);
          }),
        ),
      ),
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF6A89FF), Color(0xFF2C2C48)],
                ),
              ),
            ),
            Obx(
              () => Column(
                children: [
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
          return NavigationBar(
            height: 70,
            elevation: 8,
            selectedIndex: currentIndex,
            onDestinationSelected: (index) {
              controller.onDestinationSelected(index);
            },
            backgroundColor: Color(0xFF1F1F39),
            indicatorColor: Colors.blue.withOpacity(0.2),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home),
                selectedIcon: Icon(Icons.home_filled),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.book_outlined),
                selectedIcon: Icon(Icons.book),
                label: 'Learn',
              ),
              NavigationDestination(
                icon: Icon(Icons.chat_outlined),
                selectedIcon: Icon(Icons.chat_rounded),
                label: 'Role-play',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person_rounded),
                label: 'Profile',
              ),
            ],
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          );
        }),
      ),
    );
  }
}

class NavigationController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  final List<Widget> screens = [
    const HomeScreen(),
    LearnScreen(),
    RolePlayScreen(),
    const ProfileScreen(),
  ];

  void onDestinationSelected(int index) {
    selectedIndex.value = index;
  }
}
