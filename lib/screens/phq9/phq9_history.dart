import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final int firstQuestionIndex = 0;
final List<Map<String, dynamic>> _questions = [
  {"text": "이름이 무엇인가요?", "type": "text"},
  {"text": "나이가 몇 살인가요?", "type": "text"},
  {
    "text": "성별이 어떻게 되나요?",
    "type": "choice",
    "choices": ["남성", "여성", "기타"]
  },
  {
    "text": "예수님 믿으세요?",
    "type": "choice",
    "choices": ["네", "아니요"]
  },
  {
    "text": "1) 일 또는 여가 활동을 하는 데 흥미나 즐거움을 느끼지 못함",
    "type": "choice",
    "choices": ["전혀 방해 받지 않았다", "며칠 동안 방해 받았다", "7일 이상 방해 받았다", "거의 매일 방해 받았다"]
  },
  {
    "text": "2) 기분이 가라앉거나, 우울하거나, 희망이 없음",
    "type": "choice",
    "choices": ["전혀 방해 받지 않았다", "며칠 동안 방해 받았다", "7일 이상 방해 받았다", "거의 매일 방해 받았다"]
  },
  {
    "text": "3) 잠이 들거나 계속 잠을 자는 것이 어려움, 또는 잠을 너무 많이 잠",
    "type": "choice",
    "choices": ["전혀 방해 받지 않았다", "며칠 동안 방해 받았다", "7일 이상 방해 받았다", "거의 매일 방해 받았다"]
  },
  {
    "text": "4) 피곤하다고 느끼거나 기운이 거의 없음",
    "type": "choice",
    "choices": ["전혀 방해 받지 않았다", "며칠 동안 방해 받았다", "7일 이상 방해 받았다", "거의 매일 방해 받았다"]
  },
  {
    "text": "5) 입맛이 없거나 과식을 함",
    "type": "choice",
    "choices": ["전혀 방해 받지 않았다", "며칠 동안 방해 받았다", "7일 이상 방해 받았다", "거의 매일 방해 받았다"]
  },
  {
    "text": "6) 자신을 부정적으로 봄. 혹은 자신이 실패자라고 느끼거나 자신 또는 가족을 실망시킴",
    "type": "choice",
    "choices": ["전혀 방해 받지 않았다", "며칠 동안 방해 받았다", "7일 이상 방해 받았다", "거의 매일 방해 받았다"]
  },
  {
    "text": "7) 신문을 읽거나 텔레비전 보는 것과 같은 일에 집중하는 것이 어려움",
    "type": "choice",
    "choices": ["전혀 방해 받지 않았다", "며칠 동안 방해 받았다", "7일 이상 방해 받았다", "거의 매일 방해 받았다"]
  },
  {
    "text":
        "8) 다른 사람들이 주목할 정도로 너무 느리게 움직이거나 말을 함. 또는 반대로 평상시보다 많이 움직여서, 너무 안절부절못하거나 들떠 있음",
    "type": "choice",
    "choices": ["전혀 방해 받지 않았다", "며칠 동안 방해 받았다", "7일 이상 방해 받았다", "거의 매일 방해 받았다"]
  },
  {
    "text": "9) 자신이 죽는 것이 더 낫다고 생각하거나 어떤 식으로든 자신을 해칠 것이라고 생각함",
    "type": "choice",
    "choices": ["전혀 방해 받지 않았다", "며칠 동안 방해 받았다", "7일 이상 방해 받았다", "거의 매일 방해 받았다"]
  },
  {"text": "기도제목이 있다면 무엇인가요?", "type": "text"},
  {
    "text": "다시 한번 묻겠습니다. 예수님 믿으세요?",
    "type": "choice",
    "choices": ["네", "아니요"]
  },
];

class PHQ9History extends StatelessWidget {
  const PHQ9History({super.key});

  Future<List<Map<String, dynamic>>> _getSessions() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('phq9_responses').get();

      return snapshot.docs.map((doc) {
        final responses = doc['responses'] as Map?;
        final firstAnswer = responses != null &&
                responses[firstQuestionIndex.toString()] != null
            ? responses[firstQuestionIndex.toString()]
            : 'Unknown';

        return {
          'sessionId': doc.id,
          'name': firstAnswer,
          'timestamp': doc['timestamp'],
          'totalScore': doc['totalScore'] ?? 0,
          'diagnosis': doc['diagnosis'] ?? 'No diagnosis',
        };
      }).toList();
    } catch (e) {
      throw Exception('Error loading data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("History")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getSessions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available.'));
          } else {
            final sessions = snapshot.data!;

            return ListView.builder(
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[index];
                String formattedTimestamp = 'No Timestamp';

                if (session.containsKey('timestamp') &&
                    session['timestamp'] is Timestamp) {
                  final timestamp =
                      (session['timestamp'] as Timestamp).toDate();
                  formattedTimestamp =
                      DateFormat('yyyy년 MM월 dd일 HH시 mm분').format(timestamp);
                }

                return ListTile(
                  title: Text(session['name'] ?? 'Unknown'),
                  subtitle: Text(
                      '날짜: $formattedTimestamp\n진단 결과: ${session['diagnosis']}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SessionDetailPage(sessionId: session['sessionId']),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class SessionDetailPage extends StatelessWidget {
  final String sessionId;

  const SessionDetailPage({super.key, required this.sessionId});

  Future<Map<String, dynamic>> _getSessionDetail() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('phq9_responses')
          .doc(sessionId)
          .get();

      Map<String, dynamic> sessionData =
          snapshot.data() as Map<String, dynamic>;

      // responses에서 13번째와 14번째 질문의 답변 순서를 변경합니다.
      final responses = sessionData['responses'] as Map<String, dynamic>;

      // 13번째와 14번째 답변 위치 변경
      final temp = responses['13'];
      responses['13'] = responses['14'];
      responses['14'] = responses['15']; // 14번째 답변을 13번째로
      responses['15'] = temp; // 13번째 답변을 14번째로

      return sessionData;
    } catch (e) {
      throw Exception('Error loading session details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Session Details")),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _getSessionDetail(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available.'));
          } else {
            final session = snapshot.data!;
            final responses = session['responses'] as Map<String, dynamic>;
            final totalScore = session['totalScore'] ?? 0;
            final diagnosis = session['diagnosis'] ?? 'No diagnosis';

            return ListView(
              children: [
                ListTile(
                  title: const Text('총 점수'),
                  subtitle: Text(totalScore.toString()),
                ),
                ListTile(
                  title: const Text('진단 결과'),
                  subtitle: Text(diagnosis),
                ),
                const Divider(),
                ..._questions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final question = entry.value;
                  final response =
                      responses[index.toString()] ?? 'No answer provided';

                  return ListTile(
                    title: Text(question['text']),
                    subtitle: Text(response),
                  );
                }).toList(),
              ],
            );
          }
        },
      ),
    );
  }
}
