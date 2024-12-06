import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  Future<List<Map<String, dynamic>>> _getSessions() async {
    try {
      // Fetch the sessions collection
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('sessions').get();

      // Convert the query snapshot into a list of documents
      return snapshot.docs.map((doc) {
        // Get the answers from the session
        final answers = doc['answers'] as Map;

        // Extract the first answer (name) from the answers map
        final firstAnswer =
            answers['0'] ?? 'Unknown'; // Assuming the first answer is the name

        return {
          'sessionId': doc.id,
          'name': firstAnswer, // Use the first answer as the name
          'timestamp': doc['timestamp'],
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

            if (sessions is List && sessions.isNotEmpty) {
              for (var session in sessions) {
                if (session.containsKey('timestamp')) {
                  final timestamp = session['timestamp'];
                  String formattedTimestamp = 'No Timestamp';

                  // timestamp가 String인 경우 처리
                  if (timestamp is String) {
                    try {
                      final timestampDate = DateTime.parse(timestamp);
                      formattedTimestamp =
                          DateFormat('yyyy년 MM월 dd일 HH시 mm분 ss초')
                              .format(timestampDate);
                    } catch (e) {
                      print('Timestamp parsing error: $e');
                    }
                  }
                  // timestamp가 Timestamp인 경우 처리
                  else if (timestamp is Timestamp) {
                    final timestampDate = timestamp.toDate();
                    formattedTimestamp = DateFormat('yyyy년 MM월 dd일 HH시 mm분 ss초')
                        .format(timestampDate);
                  }

                  print(formattedTimestamp); // 출력 확인
                } else {
                  print('Timestamp가 유효하지 않거나 존재하지 않습니다.');
                }
              }
            } else {
              print('세션 데이터가 비어 있거나 List가 아닙니다.');
            }

            return ListView.builder(
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[index];
                String formattedTimestamp = 'No Timestamp';

                // timestamp가 String인 경우 처리
                if (session.containsKey('timestamp') &&
                    session['timestamp'] is String) {
                  final timestampString = session['timestamp'] as String;
                  try {
                    final timestamp = DateTime.parse(timestampString);
                    formattedTimestamp = DateFormat('yyyy년 MM월 dd일 HH시 mm분 ss초')
                        .format(timestamp);
                  } catch (e) {
                    print('Timestamp parsing error: $e');
                  }
                }
                // timestamp가 Timestamp인 경우 처리
                else if (session.containsKey('timestamp') &&
                    session['timestamp'] is Timestamp) {
                  final timestamp =
                      (session['timestamp'] as Timestamp).toDate();
                  formattedTimestamp =
                      DateFormat('yyyy년 MM월 dd일 HH시 mm분 ss초').format(timestamp);
                }

                return ListTile(
                  title: Text(session['name'] ?? 'Unknown'), // 이름 출력
                  subtitle: Text('$formattedTimestamp'),
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
          .collection('sessions')
          .doc(sessionId)
          .get();

      return snapshot.data() as Map<String, dynamic>;
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
            final answers = session['answers'] as Map;

            final filteredQuestions = _questions
                .where((question) => question['type'] != 'next')
                .toList();

            return ListView.builder(
              itemCount: filteredQuestions.length,
              itemBuilder: (context, index) {
                final question = filteredQuestions[index];
                final answer = answers[index.toString()] ?? 'No answer';
                return ListTile(
                  title: Text(question['text']),
                  subtitle: Text(answer),
                );
              },
            );
          }
        },
      ),
    );
  }
}
