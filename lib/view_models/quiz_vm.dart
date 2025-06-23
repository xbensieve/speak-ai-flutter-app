import 'package:audioplayers/audioplayers.dart';
import 'package:english_app_with_ai/models/course_content_model.dart';
import 'package:get/get.dart';

import '../services/abstract/i_course_service.dart';

class QuizViewModel extends GetxController {
  final Exercise exercise;
  final String courseId;
  final String topicId;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt currentQuestionIndex = 0.obs;
  final RxString selectedAnswer = ''.obs;
  final RxInt score = 0.obs;
  final RxBool isAnswerCorrect = false.obs;
  final RxBool showFeedback = false.obs;
  final ICourseService _courseService =
      Get.find<ICourseService>();

  late final AudioPlayer _audioPlayer;
  final RxString submissionResponse = ''.obs;

  QuizViewModel({
    required this.exercise,
    required this.courseId,
    required this.topicId,
  }) {
    _audioPlayer = AudioPlayer();
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }

  void selectAnswer(String answerId) {
    selectedAnswer.value = answerId;
    final currentQuestion =
        exercise.questions[currentQuestionIndex.value];
    final selected = currentQuestion.answers.firstWhere(
      (answer) => answer.id == answerId,
    );
    isAnswerCorrect.value = selected.isCorrect;

    _playAudio(
      isAnswerCorrect.value
          ? 'correct.wav'
          : 'incorrect.wav',
    );
    showFeedbackPopup();
  }

  void nextQuestion() async {
    if (isAnswerCorrect.value &&
        currentQuestionIndex.value <
            exercise.questions.length - 1) {
      score.value++;
      selectedAnswer.value = '';
      currentQuestionIndex.value++;
      isAnswerCorrect.value = false;
      showFeedback.value = false;
    } else if (isAnswerCorrect.value &&
        currentQuestionIndex.value ==
            exercise.questions.length - 1) {
      score.value++;
      selectedAnswer.value = '';
      isAnswerCorrect.value = false;
      showFeedback.value = false;
      await _submitQuizResults();
    }
  }

  Future<void> _submitQuizResults() async {
    isLoading.value = true;
    try {
      final response = await _courseService.submitAnswer(
        exercise.id,
        exercise.maxPoint,
      );
      submissionResponse.value =
          'Submission successful! Score: ${score.value}/${exercise.questions.length}';
    } catch (e) {
      submissionResponse.value = 'Failed to submit: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void showFeedbackPopup() {
    showFeedback.value = true;
    Future.delayed(const Duration(seconds: 2), () {
      if (isAnswerCorrect.value) {
        nextQuestion();
      } else {
        showFeedback.value = false;
      }
    });
  }

  void resetQuiz() {
    currentQuestionIndex.value = 0;
    score.value = 0;
    selectedAnswer.value = '';
    isAnswerCorrect.value = false;
    showFeedback.value = false;
    errorMessage.value = '';
    submissionResponse.value = '';
  }

  Future<void> _playAudio(String path) async {
    try {
      await _audioPlayer.play(AssetSource(path));
    } catch (e) {
      throw Exception('Error playing audio: $e');
    }
  }
}
