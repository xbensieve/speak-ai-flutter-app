import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../view_models/topics_progress_vm.dart';

class TopicsScreen extends StatelessWidget {
  final String courseId;

  const TopicsScreen({Key? key, required this.courseId})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TopicProgressVM viewModel = Get.put(
      TopicProgressVM(),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.fetchTopics(courseId);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Course Topics',
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
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
          child: Obx(() {
            if (viewModel.isLoading.value) {
              return const Center(
                child: CupertinoActivityIndicator(
                  radius: 20,
                  color: Colors.white,
                ),
              );
            }
            if (viewModel.errorMessage.value.isNotEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Text(
                      viewModel.errorMessage.value,
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        color: Colors.redAccent,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed:
                          () => viewModel.fetchTopics(
                            courseId,
                          ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.blueGrey.shade700,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (viewModel.topics.isEmpty) {
              return const Center(
                child: Text(
                  'No topics available.',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal:
                    MediaQuery.of(context).size.width *
                    0.05,
              ),
              itemCount: viewModel.topics.length,
              itemBuilder: (context, index) {
                final topic = viewModel.topics[index];
                return Card(
                  margin: EdgeInsets.symmetric(
                    vertical:
                        MediaQuery.of(context).size.height *
                        0.01,
                  ),
                  color: Colors.blueGrey.shade900,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal:
                          MediaQuery.of(
                            context,
                          ).size.width *
                          0.04,
                      vertical:
                          MediaQuery.of(
                            context,
                          ).size.height *
                          0.01,
                    ),
                    title: Text(
                      topic.topicName,
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize:
                            MediaQuery.of(
                              context,
                            ).size.width *
                            0.045,
                      ),
                    ),
                    subtitle: Text(
                      'Progress: ${topic.progress}%',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize:
                            MediaQuery.of(
                              context,
                            ).size.width *
                            0.035,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing:
                        topic.isCompleted
                            ? const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 24,
                            )
                            : const Icon(
                              Icons.hourglass_empty,
                              color: Colors.grey,
                              size: 24,
                            ),
                    onTap: () {
                      Get.snackbar(
                        'Topic',
                        'Tapped on ${topic.topicName}',
                      );
                    },
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
