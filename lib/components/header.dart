import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SizedBox(width: 10),
                  Icon(Icons.menu, color: Colors.white),
                ],
              ),
              Row(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.local_fire_department,
                        color: Colors.orange,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      const Text("1", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Row(
                    children: [
                      const Icon(
                        Icons.diamond,
                        color: Colors.purpleAccent,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      const Text("60", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ],
              ),
              CircleAvatar(
                radius: 14,
                backgroundColor: Colors.white24,
                child: Icon(Icons.explore, size: 16, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
