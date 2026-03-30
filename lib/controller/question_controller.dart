import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/question_model.dart';

class QuestionController {
  List<Question> questions = [
    Question("Do you often wake up feeling refreshed and excited for the day?"),
    Question("Do you look forward to interacting with people around you?"),
    Question("Do you enjoy your daily routine and find meaning in it?"),
    Question("Do you feel motivated to achieve your goals?"),
    Question("Do you often find yourself laughing or smiling throughout the day?"),
    Question("Do you feel optimistic about your future?"),
    Question("Do you find joy in small things, like nature or music?"),
    Question("Do you enjoy spending time with family and friends?"),
    Question("Do you feel comfortable expressing your feelings openly?"),
    Question("Do you feel appreciated and valued by those around you?"),
    Question("Do you often feel stressed or overwhelmed by small tasks?"),
    Question("Do you feel disconnected from people, even when you're surrounded by them?"),
    Question("Do you struggle to find motivation to do things you once enjoyed?"),
    Question("Do you often feel tired and drained despite resting well?"),
    Question("Do you feel anxious or worried about your life situations?"),
    Question("Do you experience moments of joy and contentment frequently?"),
    Question("Do you feel good about yourself and your achievements?"),
    Question("Do you think positively about yourself and your future?"),
    Question("Do you feel like you have control over your emotions?"),
    Question("Do you end most days feeling satisfied and fulfilled?"),
  ];

  List<bool> unansweredFlags = [];

  QuestionController() {
    unansweredFlags = List.generate(questions.length, (_) => false);
  }

  void handleSelection(int index, bool isAgree) {
    questions[index].agree = isAgree;
    questions[index].disagree = !isAgree;
    unansweredFlags[index] = false;
  }

  String evaluateMood() {
    int agreeCount = questions.where((q) => q.agree).length;
    int disagreeCount = questions.where((q) => q.disagree).length;

    if (agreeCount > disagreeCount) return "Your mood is: Pleasant 😊";
    if (disagreeCount > agreeCount) return "Your mood is: Depressed 😞";
    return "You are in an Intermediate state 😐";
  }

  bool hasUnanswered() {
    bool flag = false;
    for (int i = 0; i < questions.length; i++) {
      if (!questions[i].agree && !questions[i].disagree) {
        unansweredFlags[i] = true;
        flag = true;
      } else {
        unansweredFlags[i] = false;
      }
    }
    return flag;
  }

  Future<void> saveResponsesToFirestore(String moodResult) async {
    final responses = questions.map((q) {
      return {
        'question': q.question,
        'response': q.agree ? 'Agree' : q.disagree ? 'Disagree' : 'Unanswered',
      };
    }).toList();

    await FirebaseFirestore.instance.collection('quiz_responses').add({
      'timestamp': FieldValue.serverTimestamp(),
      'mood': moodResult,
      'responses': responses,
    });
  }
}


