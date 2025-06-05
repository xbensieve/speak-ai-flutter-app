import 'package:animate_do/animate_do.dart';
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
    final size = MediaQuery.of(context).size;
    final isTabletOrLarger = size.width >= 600;
    final padding = size.width * 0.05;
    final fontScale = isTabletOrLarger ? 1.2 : 1.0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Assessment',
          style: GoogleFonts.roboto(
            fontSize: 26 * fontScale,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: isTabletOrLarger,
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 800,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: padding,
                      vertical: size.height * 0.02,
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
                                padding: EdgeInsets.all(
                                  padding,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                  children: [
                                    Text(
                                      botResponse,
                                      style:
                                          GoogleFonts.roboto(
                                            fontSize:
                                                20 *
                                                fontScale,
                                            fontWeight:
                                                FontWeight
                                                    .bold,
                                            color:
                                                Colors
                                                    .white,
                                            height: 1.6,
                                          ),
                                    ),
                                    SizedBox(
                                      height:
                                          size.height *
                                          0.02,
                                    ),
                                    _buildSection(
                                      icon: Icons.summarize,
                                      title: 'Summary',
                                      content: summary,
                                      textColor:
                                          Colors.white,
                                      fontScale: fontScale,
                                      size: size,
                                    ),
                                    SizedBox(
                                      height:
                                          size.height *
                                          0.02,
                                    ),
                                    _buildSection(
                                      icon: Icons.star,
                                      title: 'Keep Up',
                                      content: strengths,
                                      textColor:
                                          Colors
                                              .greenAccent,
                                      gradient:
                                          const LinearGradient(
                                            colors: [
                                              Colors
                                                  .greenAccent,
                                              Colors
                                                  .tealAccent,
                                            ],
                                          ),
                                      fontScale: fontScale,
                                      size: size,
                                    ),
                                    SizedBox(
                                      height:
                                          size.height *
                                          0.02,
                                    ),
                                    _buildSection(
                                      icon: Icons.build,
                                      title: 'Work On',
                                      content: weaknesses,
                                      textColor:
                                          Colors
                                              .yellowAccent,
                                      gradient: const LinearGradient(
                                        colors: [
                                          Colors
                                              .yellowAccent,
                                          Colors
                                              .orangeAccent,
                                        ],
                                      ),
                                      fontScale: fontScale,
                                      size: size,
                                    ),
                                    SizedBox(
                                      height:
                                          size.height *
                                          0.02,
                                    ),
                                    _buildSection(
                                      icon: Icons.lightbulb,
                                      title: 'Tips',
                                      content: suggestions,
                                      textColor:
                                          Colors.white,
                                      fontScale: fontScale,
                                      size: size,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        ZoomIn(
                          duration: const Duration(
                            milliseconds: 1000,
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Get.offAll(
                                () =>
                                    const NavigationMenu(),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    size.width * 0.1,
                                vertical:
                                    size.height * 0.02,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                      12,
                                    ),
                              ),
                              elevation: 5,
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  Colors.blueAccent,
                              shadowColor: Colors.black
                                  .withOpacity(0.3),
                            ).copyWith(
                              overlayColor:
                                  MaterialStateProperty.resolveWith(
                                    (states) =>
                                        states.contains(
                                              MaterialState
                                                  .pressed,
                                            )
                                            ? Colors
                                                .blueAccent
                                                .withOpacity(
                                                  0.5,
                                                )
                                            : null,
                                  ),
                            ),
                            child: Center(
                              child: Text(
                                'Back to Menu',
                                style: GoogleFonts.roboto(
                                  fontSize: 20 * fontScale,
                                  fontWeight:
                                      FontWeight.bold,
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
              );
            },
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
    required double fontScale,
    required Size size,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: textColor, size: 28 * fontScale),
        SizedBox(width: size.width * 0.03),
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
                        fontSize: 18 * fontScale,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.6,
                      ),
                    ),
                  )
                  : Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 18 * fontScale,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                      height: 1.6,
                    ),
                  ),
              SizedBox(height: size.height * 0.01),
              Text(
                content,
                style: GoogleFonts.poppins(
                  fontSize: 16 * fontScale,
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
