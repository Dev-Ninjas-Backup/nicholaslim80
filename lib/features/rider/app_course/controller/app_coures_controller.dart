import 'package:get/get.dart';
import 'package:nicholaslim80/routes/app_routes.dart';

class AppCouresController extends GetxController {
  var currentIndex = 0.obs;
  var selectedOption = ''.obs;
  var selectedOptions = <String>[].obs; // store answers for all questions

  final questions = [
    {
      'question': 'What is the meaning of UI UX Design?',
      'options': [
        'User Interfoce and User Experience',
        'User Introface and User Experience',
        'User Interface and Using Experience',
        'User Interface and User Experience',
        'Using Interface and Using Experience',
      ],
      'answer': 'User Interface and User Experience',
    },
    {
      'question': 'Which of the following is a UI tool?',
      'options': ['Figma', 'Python', 'MySQL', 'Firebase', 'React Native'],
      'answer': 'Figma',
    },
    {
      'question': 'Which color model is used for digital screens?',
      'options': ['CMYK', 'RGB', 'Pantone', 'HEX', 'LAB'],
      'answer': 'RGB',
    },
    {
      'question': 'Which is a common UX research method?',
      'options': [
        'Wireframing',
        'Interview',
        'Typography',
        'Color Pallete',
        'Logo Design',
      ],
      'answer': 'Interview',
    },
    {
      'question': 'What does CSS stand for?',
      'options': [
        'Cascading Style Sheets',
        'Creative Style Sheets',
        'Color Style Sheets',
        'Computer Style Sheets',
        'Code Style Sheets',
      ],
      'answer': 'Cascading Style Sheets',
    },
    {
      'question': 'Which tool is used for prototyping?',
      'options': ['Figma', 'MySQL', 'VS Code', 'Android Studio', 'Excel'],
      'answer': 'Figma',
    },
    {
      'question': 'Which is NOT a UX principle?',
      'options': [
        'Consistency',
        'Accessibility',
        'Clarity',
        'Complexity',
        'Feedback',
      ],
      'answer': 'Complexity',
    },
    {
      'question': 'Which of the following improves usability?',
      'options': [
        'Confusing navigation',
        'Responsive design',
        'Hidden buttons',
        'Tiny fonts',
        'Random colors',
      ],
      'answer': 'Responsive design',
    },
    {
      'question': 'What is a wireframe?',
      'options': [
        'High fidelity design',
        'User flow diagram',
        'Basic layout sketch',
        'Code snippet',
        'Animation',
      ],
      'answer': 'Basic layout sketch',
    },
    {
      'question': 'Which of these is an accessibility feature?',
      'options': [
        'Alt text',
        'Bold fonts only',
        'Bright colors',
        'Animations',
        'Complex menus',
      ],
      'answer': 'Alt text',
    },
  ];

  /// Select option safely
  void selectOption(String option) {
    selectedOption.value = option;

    // Ensure the list has enough elements
    while (selectedOptions.length <= currentIndex.value) {
      selectedOptions.add('');
    }
    selectedOptions[currentIndex.value] = option;
  }

  /// Move to next question or finish quiz
  void nextQuestion() {
    if (currentIndex.value < questions.length - 1) {
      currentIndex.value++;

      // Safely restore previous selection or empty
      if (selectedOptions.length > currentIndex.value) {
        selectedOption.value = selectedOptions[currentIndex.value];
      } else {
        selectedOption.value = '';
      }
    } else {
      // Quiz finished, calculate correct answers
      int correctAnswers = 0;
      for (var i = 0; i < questions.length; i++) {
        if (selectedOptions.length > i &&
            selectedOptions[i] == questions[i]['answer']) {
          correctAnswers++;
        }
      }

      if (correctAnswers == questions.length) {
        Get.toNamed(AppRoutes.getquizCongratulationScreen());
      } else {
        Get.toNamed(AppRoutes.gettryAginScreen());
      }
    }
  }

  /// Move to previous question safely
  void previousQuestion() {
    if (currentIndex.value > 0) {
      currentIndex.value--;

      // Safely restore previous selection or empty
      selectedOption.value = selectedOptions.length > currentIndex.value
          ? selectedOptions[currentIndex.value]
          : '';
    }
  }

  /// Check if option is correct for current question
  bool isCorrect(String option) {
    return option == questions[currentIndex.value]['answer'];
  }
}
