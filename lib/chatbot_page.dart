import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> messages = [];
  bool isLoading = false;

Future<void> sendMessage(String prompt) async {
  setState(() {
    messages.add({'role': 'user', 'text': prompt});
    isLoading = true;
  });

  try {
    final response = await http.post(
      Uri.parse('https://api.perplexity.ai/chat/completions'),
      headers: {
        'Authorization': 'Bearer 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',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "model": "sonar-pro",  // Use "sonar-pro" or "sonar-small-chat" if "medium" fails
        "messages": [
          {
            "role": "system",
            "content": "You are a helpful travel assistant."
          },
          {
            "role": "user",
            "content": prompt
          }
        ],
        "stream": false,
      }),
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final botReply = decoded['choices'][0]['message']['content'];

      setState(() {
        messages.add({'role': 'assistant', 'text': botReply});
        isLoading = false;
      });
    } else {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      setState(() {
        messages.add({
          'role': 'assistant',
          'text': 'Error ${response.statusCode}: Failed to get response from API.'
        });
        isLoading = false;
      });
    }
  } catch (e) {
    print("Exception: $e");
    setState(() {
      messages.add({'role': 'assistant', 'text': 'Exception: $e'});
      isLoading = false;
    });
  }
}






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Travel Chatbot")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return Align(
                  alignment: msg['role'] == 'user'
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: msg['role'] == 'user'
                          ? Colors.blue[100]
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(msg['text'] ?? ''),
                  ),
                );
              },
            ),
          ),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Generating your response..."),
            ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration:
                      const InputDecoration(hintText: "Ask something..."),
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      _controller.clear();
                      sendMessage(value.trim());
                    }
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  final input = _controller.text.trim();
                  if (input.isNotEmpty) {
                    _controller.clear();
                    sendMessage(input);
                  }
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
