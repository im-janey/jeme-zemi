import 'dart:convert';

import 'package:http/http.dart' as http;

class ChatGPT {
  final String apiKey;
  final String apiUrl = "https://api.openai.com/v1/chat/completions";

  ChatGPT(this.apiKey);

  Future<String> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: json.encode({
          "model": "gpt-4", // ChatGPT 모델 선택
          "messages": [
            {"role": "system", "content": "You are a helpful assistant."},
            {"role": "user", "content": message}
          ],
          "max_tokens": 100,
          "temperature": 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        return 'Error: Unable to fetch response';
      }
    } catch (e) {
      return 'Exception occurred';
    }
  }
}
