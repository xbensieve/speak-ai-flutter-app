import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../view_models/topics_progress_vm.dart';

class TopicsScreen extends StatelessWidget {
  final String enrolledCourseId;

  const TopicsScreen({
    Key? key,
    required this.enrolledCourseId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TopicProgressVM viewModel = Get.put(
      TopicProgressVM(),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.fetchTopics(enrolledCourseId);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Course Topics',
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 22,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
          child: RefreshIndicator(
            onRefresh:
                () =>
                    viewModel.fetchTopics(enrolledCourseId),
            color: Colors.white,
            backgroundColor: Colors.blueGrey.shade900,
            child: Obx(() {
              if (viewModel.isLoading.value) {
                return const Center(
                  child: CupertinoActivityIndicator(
                    radius: 24,
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
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.redAccent.shade100,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed:
                            () => viewModel.fetchTopics(
                              enrolledCourseId,
                            ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.blueGrey.shade800,
                          padding:
                              const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10),
                          ),
                          elevation: 4,
                        ),
                        child: Text(
                          'Retry',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (viewModel.topics.isEmpty) {
                return Center(
                  child: Text(
                    'No topics available.',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal:
                      MediaQuery.of(context).size.width *
                      0.06,
                ),
                itemCount: viewModel.topics.length,
                itemBuilder: (context, index) {
                  final topic = viewModel.topics[index];
                  return GestureDetector(
                    onTap: () {
                      Get.snackbar(
                        'Topic',
                        'Tapped on ${topic.topicName}',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor:
                            Colors.blueGrey.shade800,
                        colorText: Colors.white,
                        margin: const EdgeInsets.all(16),
                        borderRadius: 12,
                        duration: const Duration(
                          seconds: 2,
                        ),
                      );
                    },
                    child: Card(
                      margin: EdgeInsets.symmetric(
                        vertical:
                            MediaQuery.of(
                              context,
                            ).size.height *
                            0.012,
                      ),
                      color: Colors.blueGrey.shade900
                          .withOpacity(0.9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          16,
                        ),
                      ),
                      elevation: 6,
                      shadowColor: Colors.black.withOpacity(
                        0.3,
                      ),
                      child: ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(
                                    context,
                                  ).size.width *
                                  0.05,
                              vertical:
                                  MediaQuery.of(
                                    context,
                                  ).size.height *
                                  0.015,
                            ),
                        title: Text(
                          topic.topicName,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize:
                                MediaQuery.of(
                                  context,
                                ).size.width *
                                0.045,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              'Progress: ${topic.progress}%',
                              style: GoogleFonts.poppins(
                                color: Colors.white70,
                                fontSize:
                                    MediaQuery.of(
                                      context,
                                    ).size.width *
                                    0.035,
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 1,
                              overflow:
                                  TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: topic.progress / 100,
                              backgroundColor:
                                  Colors.blueGrey.shade700,
                              valueColor:
                                  AlwaysStoppedAnimation<
                                    Color
                                  >(
                                    topic.isCompleted
                                        ? Colors.green
                                        : Colors.blueAccent,
                                  ),
                              minHeight: 4,
                            ),
                          ],
                        ),
                        trailing:
                            topic.isCompleted
                                ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.greenAccent,
                                  size: 26,
                                )
                                : const Icon(
                                  Icons.hourglass_empty,
                                  color: Colors.grey,
                                  size: 26,
                                ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ),
      ),
    );
  }
}
