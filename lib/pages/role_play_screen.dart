import 'package:english_app_with_ai/view_models/topic_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'scenario_prompt_screen.dart';
import 'package:flutter/cupertino.dart';

class RolePlayScreen extends StatefulWidget {
  const RolePlayScreen({super.key});

  @override
  State<RolePlayScreen> createState() => _RolePlayScreenState();
}

class _RolePlayScreenState extends State<RolePlayScreen> {
  final TopicViewModel _topicViewModel = TopicViewModel();
  bool _isLoading = false;

  Future<String?> _fetchScenarioPrompt(int topicId) async {
    try {
      final response = await http.post(
        Uri.parse('http://sai.runasp.net/api/ai/start'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'topicId': topicId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['scenarioPrompt'] as String?;
      } else {
        print('API error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching scenario prompt: $e');
      return null;
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: const CupertinoActivityIndicator(radius: 20),
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
    final topics = _topicViewModel.getTopics();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Role-play',
          style: GoogleFonts.roboto(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.8,
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
                final scenarioPrompt = await _fetchScenarioPrompt(topicId);
                _hideLoadingDialog();
                setState(() {
                  _isLoading = false;
                });

                if (scenarioPrompt != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ScenarioPromptScreen(
                            topicId: topicId,
                            scenarioPrompt: scenarioPrompt,
                          ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to load scenario')),
                  );
                }
              },
              child: Card(
                elevation: 4,
                color: Colors.white.withOpacity(0.9), // Slight transparency
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(10),
                        ),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) =>
                                  const Icon(Icons.error),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        topicName,
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
