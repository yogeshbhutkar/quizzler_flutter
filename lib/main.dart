import 'package:flutter/material.dart';
import 'package:quizzler_flutter/quiz_brain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void main() {
  runApp(const Quizzler());
}

class Quizzler extends StatelessWidget {
  const Quizzler({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: const SafeArea(
          child: QuizPage(),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Icon> scoreKeeper = [];
  int correctCount = 0;
  void clearList() {
    scoreKeeper.clear();
  }

  void displayAlert() {
    Alert(
      context: context,
      title: "Finished",
      desc: "You scored $correctCount",
    ).show();
  }

  void alertMe(bool userPickedAnswer) {
    if (quizBrain.isFinished() == true) {
      if (quizBrain.getAnswer() == true) {
        correctCount++;
      }
      displayAlert();
      setState(() {
        quizBrain.resetQuestionNumber();
        correctCount = 0;
        clearList();
      });
    } else {
      checkAnswer(userPickedAnswer);
    }
  }

  void checkAnswer(bool userPickedAnswer) {
    bool correctAnswer = quizBrain.getAnswer();
    if (correctAnswer == userPickedAnswer) {
      setState(() {
        scoreKeeper.add(const Icon(
          Icons.check,
          color: Colors.green,
        ));
        correctCount++;
        quizBrain.toNextQuestion();
      });
    } else {
      setState(() {
        scoreKeeper.add(const Icon(
          Icons.close,
          color: Colors.red,
        ));
        quizBrain.toNextQuestion();
      });
    }
  }

  QuizBrain quizBrain = QuizBrain();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizBrain.getQuestion(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: MaterialButton(
              onPressed: () {
                alertMe(true);
              },
              color: Colors.green,
              child: const Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: MaterialButton(
              onPressed: () {
                alertMe(false);
              },
              color: Colors.red,
              child: const Text(
                'False',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
        Row(
          children: scoreKeeper,
        ),
      ],
    );
  }
}
