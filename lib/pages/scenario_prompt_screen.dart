import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'tutor_screen.dart';

class ScenarioPromptScreen extends StatelessWidget {
  final int topicId;
  final String scenarioPrompt;

  const ScenarioPromptScreen({
    super.key,
    required this.topicId,
    required this.scenarioPrompt,
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
          'Your Scenario',
          style: GoogleFonts.roboto(
            fontSize: 25 * fontScale,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: isTabletOrLarger,
        // Center title on larger screens
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 24 * fontScale,
          ),
          onPressed: () => Navigator.pop(context),
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 800,
                  ),
                  // Cap width for large screens
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
                            child: Padding(
                              padding: EdgeInsets.all(
                                padding,
                              ),
                              child: SingleChildScrollView(
                                child: Text(
                                  scenarioPrompt,
                                  style: GoogleFonts.roboto(
                                    fontSize:
                                        25 * fontScale,
                                    color: Colors.white,
                                    height: 1.6,
                                  ),
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
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                      ) => TutorScreen(
                                        topicId: topicId,
                                        scenarioPrompt:
                                            scenarioPrompt,
                                      ),
                                  transitionsBuilder: (
                                    context,
                                    animation,
                                    secondaryAnimation,
                                    child,
                                  ) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    );
                                  },
                                  transitionDuration:
                                      const Duration(
                                        milliseconds: 500,
                                      ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.blueAccent,
                              padding:
                                  const EdgeInsets.symmetric(
                                    horizontal: 40,
                                    vertical: 18,
                                  ),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                      12,
                                    ),
                              ),
                              elevation: 2,
                            ),
                            child: Text(
                              'Begin Conversation',
                              style: GoogleFonts.roboto(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
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
}
