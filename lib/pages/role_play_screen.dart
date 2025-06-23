import 'package:english_app_with_ai/view_models/topic_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../view_models/ai_view_model.dart';
import 'scenario_prompt_screen.dart';

class RolePlayScreen extends StatefulWidget {
  const RolePlayScreen({super.key});

  @override
  State<RolePlayScreen> createState() =>
      _RolePlayScreenState();
}

class _RolePlayScreenState extends State<RolePlayScreen> {
  final TopicViewModel _topicViewModel = TopicViewModel();
  final AIViewModel _aiViewModel = AIViewModel();
  bool _isLoading = false;

  Future<String?> _fetchScenarioPrompt(int topicId) async {
    return _aiViewModel.getScenarioByTopicId(topicId);
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => Center(
            child: Container(
              padding: EdgeInsets.all(
                MediaQuery.of(context).size.width * 0.05,
              ),
              child: const CupertinoActivityIndicator(
                radius: 20,
                color: Colors.white,
              ),
            ),
          ),
    );
  }

  void _hideLoadingDialog() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth =
        MediaQuery.of(context).size.width;
    final double screenHeight =
        MediaQuery.of(context).size.height;
    final topics = _topicViewModel.getTopics();

    final int crossAxisCount = screenWidth > 600 ? 3 : 2;

    return Scaffold(
      extendBodyBehindAppBar: true,
      // Allow body to extend behind AppBar
      appBar: AppBar(
        title: Text(
          'Role-play',
          style: GoogleFonts.roboto(
            fontSize: screenWidth * 0.06,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        // Transparent background
        elevation: 0, // Remove shadow
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: GridView.builder(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: screenWidth * 0.025,
                  mainAxisSpacing: screenHeight * 0.015,
                  childAspectRatio: 0.75,
                ),
            itemCount: topics.length,
            itemBuilder: (context, index) {
              final topicId = topics.keys.elementAt(index);
              final topicData = topics[topicId]!;
              final topicName = topicData['topic']!;
              final imageUrl = topicData['image']!;

              return GestureDetector(
                onTap: () async {
                  if (_isLoading) return;
                  setState(() {
                    _isLoading = true;
                  });
                  _showLoadingDialog();
                  final scenarioPrompt =
                      await _fetchScenarioPrompt(topicId);
                  _hideLoadingDialog();
                  setState(() {
                    _isLoading = false;
                  });

                  if (scenarioPrompt != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                ScenarioPromptScreen(
                                  topicId: topicId,
                                  scenarioPrompt:
                                      scenarioPrompt,
                                ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Failed to load scenario',
                        ),
                      ),
                    );
                  }
                },
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      screenWidth * 0.03,
                    ),
                  ),
                  color: Colors.white,
                  // Card background for contrast
                  child: Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.vertical(
                                top: Radius.circular(
                                  screenWidth * 0.03,
                                ),
                              ),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: screenHeight * 0.25,
                            errorBuilder:
                                (
                                  context,
                                  error,
                                  stackTrace,
                                ) => const Icon(
                                  Icons.error,
                                  size: 50,
                                ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(
                          screenWidth * 0.02,
                        ),
                        child: Text(
                          topicName,
                          style: GoogleFonts.roboto(
                            fontSize: screenWidth * 0.04,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
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
