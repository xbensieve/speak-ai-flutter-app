import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Builder(
                  builder:
                      (context) => IconButton(
                        icon: const Icon(
                          Icons.menu_sharp,
                          color: Colors.white,
                          size: 35,
                        ),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                ),
              ],
            ),
            Row(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.local_fire_department_sharp,
                      color: Colors.orange,
                      size: 35,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "99",
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Row(
                  children: [
                    const Icon(
                      Icons.diamond_sharp,
                      color: Colors.purpleAccent,
                      size: 35,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "60",
                      style: GoogleFonts.roboto(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            CircleAvatar(
              backgroundColor: Colors.white24,
              child: Icon(
                Icons.explore_sharp,
                size: 35,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
