import 'package:audioplayers/audioplayers.dart';
import 'package:english_app_with_ai/models/course_content_model.dart';
import 'package:get/get.dart';

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

  late final AudioPlayer _audioPlayer;

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
          ? 'correct.mp3'
          : 'incorrect.mp3',
    );
    showFeedbackPopup();
  }

  void nextQuestion() {
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
    }
  }

  void showFeedbackPopup() {
    showFeedback.value = true;
    Future.delayed(const Duration(seconds: 2), () {
      showFeedback.value = false;
    });
  }

  Future<void> _playAudio(String path) async {
    try {
      print('Playing audio: $path');
      await _audioPlayer.play(AssetSource(path));
    } catch (e) {
      print('Error playing audio: $e');
    }
  }
}
