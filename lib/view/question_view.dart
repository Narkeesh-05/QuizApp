import 'package:flutter/material.dart';
import '../controller/question_controller.dart';

class QuestionView extends StatefulWidget {
  @override
  State<QuestionView> createState() => _QuestionViewState();
}

class _QuestionViewState extends State<QuestionView> {
  final QuestionController _controller = QuestionController();
  String? result;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            child: Padding(
              // padding:   EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              padding: EdgeInsets.zero,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Take a Quiz !!',
                        style: TextStyle(
                          color: Colors.indigoAccent,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                    SizedBox(width: screenWidth*0.1),
                ],
              ),
            ),
          ),
          result != null
              ? Center(
                child: Text(
                  result!,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
              : Expanded(
                child: ListView.builder(
                  itemCount: _controller.questions.length,
                  itemBuilder: (context, index) {
                    final q = _controller.questions[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        left: screenWidth * 0.03,
                        right: screenWidth * 0.03,
                      ),
                      child: Card(
                        color: Colors.white,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    if (_controller.unansweredFlags[index])
                                      const TextSpan(
                                        text: '* ',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    TextSpan(
                                      text: q.question,
                                      style: TextStyle(
                                        fontSize: screenHeight * 0.017,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                                SizedBox(height: screenHeight*0.01),
                              Row(
                                children: [
                                  Checkbox(
                                    value: q.agree,
                                    onChanged:
                                        (_) => setState(
                                          () => _controller.handleSelection(
                                            index,
                                            true,
                                          ),
                                        ),
                                    activeColor: Colors.indigoAccent,
                                    side: const BorderSide(
                                      color: Colors.indigoAccent,
                                    ),
                                  ),
                                  const Text('Agree'),
                                  const SizedBox(width: 20),
                                  Checkbox(
                                    value: q.disagree,
                                    onChanged:
                                        (_) => setState(
                                          () => _controller.handleSelection(
                                            index,
                                            false,
                                          ),
                                        ),
                                    activeColor: Colors.indigoAccent,
                                    side: const BorderSide(
                                      color: Colors.indigoAccent,
                                    ),
                                  ),
                                  const Text('Disagree'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          if (result == null) submitButton(),
        ],
      ),
    );
  }

  Widget submitButton() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.06,
        horizontal: screenWidth * 0.1,
      ),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () async {
            if (_controller.hasUnanswered()) {
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Answer all the questions"),
                  backgroundColor: Colors.black,
                ),
              );
              return;
            }

            String mood = _controller.evaluateMood();
            await _controller.saveResponsesToFirestore(mood);

            setState(() {
              result = mood;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigoAccent,
            shape: const StadiumBorder(),
          ),
          child: const Text(
            'Submit',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
