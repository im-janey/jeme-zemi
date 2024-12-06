import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:uuid/uuid.dart';

import 'history.dart';
import 'setting.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _saveAnswersToFirestore() async {
    final sessionId = const Uuid().v4();
    final timestamp = DateTime.now();

    final Map<String, String> formattedAnswers = _answers.map(
      (key, value) => MapEntry(key.toString(), value.toString()),
    );

    try {
      await _firestore.collection('sessions').doc(sessionId).set({
        "sessionId": sessionId,
        "timestamp": timestamp.toIso8601String(),
        "answers": formattedAnswers,
      });
      print("Answers saved to Firestore with sessionId: $sessionId");
    } catch (e) {
      print("Failed to save answers: $e");
    }
  }

  final List<Map<String, dynamic>> _questions = [
    {"text": "이름이 무엇인가요?", "type": "text"},
    {
      "text": "예수님 믿으세요?",
      "type": "choice",
      "choices": ["네", "아니요"]
    },
    {
      "text": "진지한 질문 하나만 해도 될까요?",
      "type": "choice",
      "choices": ["네", "아니요"]
    },
    {
      "text": "당신이 오늘 죽으면 천국, 지옥이 존재한다고 할 때 이 중 어디에 갈 것 같으세요?",
      "type": "choice",
      "choices": ["천국", "지옥"]
    },
    {
      "text": "“내가 왜 널 천국에 들여보내줘야 하지?“ 하나님께서 물으시면 당신은 어떤 이유를 들어 대답하시겠어요?",
      "type": "text"
    },
    {"text": "또 질문해볼테니 대답해주세요.", "type": "next"},
    {
      "text": "지금까지 살면서 한 번이라도 훔쳐본 적 있으세요?",
      "type": "choice",
      "choices": ["네", "아니요"]
    },
    {
      "text": "그러면 살면서 거짓말 한 적 있으세요?",
      "type": "choice",
      "choices": ["네", "아니요"]
    },
    {
      "text": "살면서 부모님을 공경하지 않은 적 있으세요? 등등",
      "type": "choice",
      "choices": ["네", "아니요"]
    },
    {"text": "당신도 나도 누구도 우리 모두는 죄 지어본 적 있는 죄인입니다.", "type": "next"},
    {"text": "우리가 좋은 일을 얼마나 많이 했든,", "type": "next"},
    {"text": "얼마나 좋은 사람이든,", "type": "next"},
    {"text": "하나님은 love 사랑이시면서 동시에 justice 공의(정의)로운 분이시기에", "type": "next"},
    {"text": "죄인인 우리 모두는 하나님의 법칙에 따라 죽어서 지옥에 가야만 마땅합니다.", "type": "next"},
    {
      "text": "이 모든 내용을 이해하고 믿으시나요?",
      "type": "choice",
      "choices": ["네", "아니요"]
    },
    {"text": "그러나 하나님께서 우리를 사랑하셔서", "type": "next"},
    {"text": "당신의 아들인 예수님을 이 땅에 내려보내셨고", "type": "next"},
    {"text": "예수님은 지옥에 가야 마땅한", "type": "next"},
    {"text": "죄인인 당신의 죄를 대신하여", "type": "next"},
    {"text": "십자가에 못 박혀 죽으신 후", "type": "next"},
    {"text": "3일 만에 다시 사셨습니다.", "type": "next"},
    {"text": "당신은 \"예수님을 믿는 것,\" 이 이유 하나만으로 천국에 갈 수 있습니다.", "type": "next"},
    {
      "text": "예수님을 믿고 천국에 가시겠어요?",
      "type": "choice",
      "choices": ["네", "아니요"]
    },
  ];

  int _currentQuestionIndex = 0;
  final Map<int, String> _answers = {};
  final TextEditingController _textController = TextEditingController();

  void _nextQuestion([String? response]) {
    // 로그 추가
    print(
        "Current Question Index: $_currentQuestionIndex, Response: $response");
    setState(() {
      if (response != null) {
        _answers[_currentQuestionIndex] = response;
      }

      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
        print("Moving to next question: $_currentQuestionIndex");
        _textController.clear();
      } else {
        print("All questions answered");
        _showCompletionDialog();
      }
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("질문 완료"),
          content: const Text("모든 질문이 완료되었습니다!"),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _saveAnswersToFirestore();
                setState(() {
                  _currentQuestionIndex = 0;
                  _answers.clear();
                  _textController.clear();
                });
              },
              child: const Text("처음으로"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.list),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HistoryPage()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Center(
              child: Lottie.asset(
                'assets/Animation - 1732720971734.json',
                width: 350,
                height: 220,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 40),

            // 말풍선 카드
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    currentQuestion["text"] as String,
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.blue.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 답변 영역
            if (currentQuestion["type"] == "text")
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: const InputDecoration(
                          labelText: "답변을 입력하세요",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(80, 60), // 최소 크기: 가로 200, 세로 60
                        padding: EdgeInsets.symmetric(
                            vertical: 15, horizontal: 10), // 버튼 내부 패딩
                        textStyle: TextStyle(fontSize: 18), // 글씨 크기ㅇㅁㄴㅇㄹ
                      ),
                      onPressed: () {
                        if (_textController.text.isNotEmpty) {
                          _nextQuestion(_textController.text);
                        }
                      },
                      child: const Text("다음"),
                    ),
                  ],
                ),
              )
            else if (currentQuestion["type"] == "choice")
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: (currentQuestion["choices"] as List<String>)
                    .map((choice) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize:
                                  Size(180, 60), // 최소 크기: 가로 200, 세로 60
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 40), // 버튼 내부 패딩
                              textStyle: TextStyle(fontSize: 24), // 글씨 크기
                            ),
                            onPressed: () => _nextQuestion(choice),
                            child: Text(choice),
                          ),
                        ))
                    .toList(),
              )
            else if (currentQuestion["type"] == "next")
              Center(
                child: ElevatedButton(
                  onPressed: () => _nextQuestion(),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(180, 60), // 최소 크기: 가로 200, 세로 60
                    padding: EdgeInsets.symmetric(
                        vertical: 15, horizontal: 40), // 버튼 내부 패딩
                    textStyle: TextStyle(fontSize: 24), // 글씨 크기
                  ),
                  child: const Text("다음"),
                ),
              ),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
