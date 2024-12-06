import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../home/setting.dart';
import 'phq9_history.dart';

class PHQ9Page extends StatefulWidget {
  const PHQ9Page({super.key});

  @override
  State<PHQ9Page> createState() => _PH9PageState();
}

class _PH9PageState extends State<PHQ9Page> {
  Future<void> saveAnswer(
      String sessionId, Map<String, dynamic> answers) async {
    // Firestore 인스턴스 가져오기
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // sessions collection 내에 sessionId에 해당하는 document 참조
    DocumentReference sessionRef =
        firestore.collection('sessions').doc(sessionId);

    // answers 데이터를 Firestore에 저장
    try {
      await sessionRef.collection('answers').add({
        'timestamp': FieldValue.serverTimestamp(), // 서버 타임스탬프 저장
        'answers': answers, // 전달받은 answers 데이터를 저장
      });
      print('Answer saved successfully!');
    } catch (e) {
      print('Error saving answer: $e');
    }
  }

  final List<Map<String, dynamic>> _questions = [
    {"text": "검사 대상자의 이름이 무엇인가요?", "type": "text"},
    {"text": "나이가 몇 살인가요?", "type": "text"},
    {
      "text": "성별이 어떻게 되나요?",
      "type": "choice",
      "choices": ["남성", "여성", "기타"]
    },
    {
      "text": "예수님을 믿으시나요?",
      "type": "choice",
      "choices": ["네", "아니요"]
    },
    {
      "text": "1) 일 또는 여가 활동을 하는 데 흥미나 즐거움을 느끼지 못함",
      "type": "choice",
      "choices": [
        "전혀 방해 받지 않았다",
        "며칠 동안 방해 받았다",
        "7일 이상 방해 받았다",
        "거의 매일 방해 받았다"
      ]
    },
    {
      "text": "2) 기분이 가라앉거나, 우울하거나, 희망이 없음",
      "type": "choice",
      "choices": [
        "전혀 방해 받지 않았다",
        "며칠 동안 방해 받았다",
        "7일 이상 방해 받았다",
        "거의 매일 방해 받았다"
      ]
    },
    {
      "text": "3) 잠이 들거나 계속 잠을 자는 것이 어려움, 또는 잠을 너무 많이 잠",
      "type": "choice",
      "choices": [
        "전혀 방해 받지 않았다",
        "며칠 동안 방해 받았다",
        "7일 이상 방해 받았다",
        "거의 매일 방해 받았다"
      ]
    },
    {
      "text": "4) 피곤하다고 느끼거나 기운이 거의 없음",
      "type": "choice",
      "choices": [
        "전혀 방해 받지 않았다",
        "며칠 동안 방해 받았다",
        "7일 이상 방해 받았다",
        "거의 매일 방해 받았다"
      ]
    },
    {
      "text": "5) 입맛이 없거나 과식을 함",
      "type": "choice",
      "choices": [
        "전혀 방해 받지 않았다",
        "며칠 동안 방해 받았다",
        "7일 이상 방해 받았다",
        "거의 매일 방해 받았다"
      ]
    },
    {
      "text": "6) 자신을 부정적으로 봄. 혹은 자신이 실패자라고 느끼거나 자신 또는 가족을 실망시킴",
      "type": "choice",
      "choices": [
        "전혀 방해 받지 않았다",
        "며칠 동안 방해 받았다",
        "7일 이상 방해 받았다",
        "거의 매일 방해 받았다"
      ]
    },
    {
      "text": "7) 신문을 읽거나 텔레비전 보는 것과 같은 일에 집중하는 것이 어려움",
      "type": "choice",
      "choices": [
        "전혀 방해 받지 않았다",
        "며칠 동안 방해 받았다",
        "7일 이상 방해 받았다",
        "거의 매일 방해 받았다"
      ]
    },
    {
      "text":
          "8) 다른 사람들이 주목할 정도로 너무 느리게 움직이거나 말을 함. 또는 반대로 평상시보다 많이 움직여서, 너무 안절부절못하거나 들떠 있음",
      "type": "choice",
      "choices": [
        "전혀 방해 받지 않았다",
        "며칠 동안 방해 받았다",
        "7일 이상 방해 받았다",
        "거의 매일 방해 받았다"
      ]
    },
    {
      "text": "9) 자신이 죽는 것이 더 낫다고 생각하거나 어떤 식으로든 자신을 해칠 것이라고 생각함",
      "type": "choice",
      "choices": [
        "전혀 방해 받지 않았다",
        "며칠 동안 방해 받았다",
        "7일 이상 방해 받았다",
        "거의 매일 방해 받았다"
      ]
    },
    {
      "text": "진단 결과",
      "type": "result",
      "calculate": (answers) {
        // 사용자 응답에 기반하여 점수를 계산합니다.
        int score = 0;
        for (int i = 4; i <= 12; i++) {
          final choice = answers[i] ?? "";
          if (choice == "며칠 동안 방해 받았다") score += 1;
          if (choice == "7일 이상 방해 받았다") score += 2;
          if (choice == "거의 매일 방해 받았다") score += 3;
        }
        if (score < 5) {
          return "현재 상태는 양호합니다.";
        } else if (score < 10) {
          return "경미한 우울감이 느껴질 수 있습니다.";
        } else {
          return "전문가와 상담이 필요할 수 있습니다.";
        }
      }
    },
    {"text": "기도제목이 있다면 무엇인가요?", "type": "text"},
    {
      "text": "(재질문) 예수님을 믿으시나요?",
      "type": "choice",
      "choices": ["네", "아니요"]
    },
  ];

  int _currentQuestionIndex = 0;
  final Map<int, String> _answers = {};
  final TextEditingController _textController = TextEditingController();

  double _getProgress() {
    return (_currentQuestionIndex + 1) / _questions.length;
  }

  void _handleNextQuestion([String? response]) {
    if (response != null) {
      _answers[_currentQuestionIndex] = response;
    }

    setState(() {
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
        _textController.clear();
      } else {
        _showCompletionDialog();
      }
    });
  }

  void _handlePreviousQuestion() {
    setState(() {
      if (_currentQuestionIndex > 0) {
        _currentQuestionIndex--;
        _textController.clear();
      }
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("검사 완료"),
        content: const Text("모든 질문이 완료되었습니다."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _currentQuestionIndex = 0; // 진행도 초기화
                _answers.clear(); // 사용자 응답 초기화
                _textController.clear();
              });
            },
            child: const Text(
              "다시 시작",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentQuestionIndex];
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.list),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PHQ9History()),
            );
          },
        ),
        title: const Text("PHQ-9"),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // 프로그레스 바
            LinearProgressIndicator(
              value: _getProgress(),
              backgroundColor:
                  isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            const SizedBox(height: 10),
            Text(
              "질문 진행도: ${(_getProgress() * 100).toStringAsFixed(0)}%",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 40),
            // 질문 텍스트
            Text(
              currentQuestion["text"] as String,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const Spacer(),
            // 답변 및 버튼 영역
            Padding(
              padding: const EdgeInsets.only(bottom: 50), // 바닥에서 띄우기
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (currentQuestion["type"] == "text")
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20), // 답변 창 간격
                      child: TextField(
                        controller: _textController,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                        decoration: InputDecoration(
                          labelText: "답변을 입력하세요",
                          labelStyle: TextStyle(
                            color:
                                isDarkMode ? Colors.grey.shade400 : Colors.grey,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: isDarkMode
                                  ? Colors.grey.shade600
                                  : Colors.grey.shade400,
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    )
                  else if (currentQuestion["type"] == "choice")
                    Column(
                      children: (currentQuestion["choices"] as List<String>)
                          .map(
                            (choice) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: ElevatedButton(
                                onPressed: () => _handleNextQuestion(choice),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14, horizontal: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  choice,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  const SizedBox(height: 35),
                  // 이전 및 다음 버튼
                  Row(
                    children: [
                      // 이전 버튼
                      if (_currentQuestionIndex > 0)
                        ElevatedButton.icon(
                          onPressed: _handlePreviousQuestion,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.withOpacity(0.8),
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "이전",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      if (_currentQuestionIndex > 0) const Spacer(), // 간격 추가

                      // 다음 버튼
                      ElevatedButton.icon(
                        onPressed: () => _handleNextQuestion(
                            currentQuestion["type"] == "text"
                                ? _textController.text
                                : null),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.withOpacity(1.0),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "다음",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
