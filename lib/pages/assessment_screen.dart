import 'package:animate_do/animate_do.dart'; // For animations
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../components/navigation_menu.dart';

class AssessmentScreen extends StatelessWidget {
  final String botResponse;
  final String summary;
  final String strengths;
  final String weaknesses;
  final String suggestions;

  const AssessmentScreen({
    super.key,
    required this.botResponse,
    required this.summary,
    required this.strengths,
    required this.weaknesses,
    required this.suggestions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Assessment',
          style: GoogleFonts.roboto(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF6A89FF), Color(0xFF2C2C48)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 20,
            ),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              crossAxisAlignment:
                  CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: FadeInUp(
                    duration: const Duration(
                      milliseconds: 900,
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              botResponse,
                              style: GoogleFonts.roboto(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildSection(
                              icon: Icons.summarize,
                              title: 'Summary',
                              content: summary,
                              textColor: Colors.white,
                            ),
                            const SizedBox(height: 20),
                            _buildSection(
                              icon: Icons.star,
                              title: 'Keep Up',
                              content: strengths,
                              textColor: Colors.greenAccent,
                              gradient:
                                  const LinearGradient(
                                    colors: [
                                      Colors.greenAccent,
                                      Colors.tealAccent,
                                    ],
                                  ),
                            ),
                            const SizedBox(height: 20),
                            _buildSection(
                              icon: Icons.build,
                              title: 'Work On',
                              content: weaknesses,
                              textColor:
                                  Colors.yellowAccent,
                              gradient:
                                  const LinearGradient(
                                    colors: [
                                      Colors.yellowAccent,
                                      Colors.orangeAccent,
                                    ],
                                  ),
                            ),
                            const SizedBox(height: 20),
                            _buildSection(
                              icon: Icons.lightbulb,
                              title: 'Tips',
                              content: suggestions,
                              textColor: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ZoomIn(
                  duration: const Duration(
                    milliseconds: 1000,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.offAll(
                        () => const NavigationMenu(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 18,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          12,
                        ),
                      ),
                      elevation: 5,
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.black.withOpacity(
                        0.3,
                      ),
                    ).copyWith(
                      backgroundColor:
                          MaterialStateProperty.resolveWith(
                            (states) {
                              return Colors.blueAccent;
                            },
                          ),
                      overlayColor:
                          MaterialStateProperty.resolveWith(
                            (states) {
                              return states.contains(
                                    MaterialState.pressed,
                                  )
                                  ? Colors.blueAccent
                                      .withOpacity(0.5)
                                  : null;
                            },
                          ),
                    ),
                    child: Center(
                      child: Text(
                        'Back to Menu',
                        style: GoogleFonts.roboto(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required String content,
    required Color textColor,
    LinearGradient? gradient,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: textColor, size: 28),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              gradient != null
                  ? ShaderMask(
                    shaderCallback:
                        (bounds) => gradient.createShader(
                          Rect.fromLTWH(
                            0,
                            0,
                            bounds.width,
                            bounds.height,
                          ),
                        ),
                    child: Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.6,
                      ),
                    ),
                  )
                  : Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                      height: 1.6,
                    ),
                  ),
              const SizedBox(height: 5),
              Text(
                content,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: textColor,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
