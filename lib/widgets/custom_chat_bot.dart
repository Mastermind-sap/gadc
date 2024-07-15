import 'package:flutter/material.dart';
import 'package:gadc/functions/gemini/api_keys/apiKeys.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:lottie/lottie.dart';

class CustomChatBot extends StatefulWidget {
  const CustomChatBot({Key? key}) : super(key: key);

  @override
  _CustomChatBotState createState() => _CustomChatBotState();
}

class _CustomChatBotState extends State<CustomChatBot> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> chatLog = [];

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                  child: TextFormField(
                controller: _textController,
                decoration: InputDecoration(
                  labelText: 'Ask Gemini',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        24.0), // Adjust the radius as needed
                  ),
                  contentPadding: EdgeInsets.fromLTRB(
                      16.0, 32.0, 16.0, 0), // Add top padding of 16
                  suffixIcon: GestureDetector(
                    onTap: () async {
                      String userInput = _textController.text.trim();
                      // Close the Keyboard and clear the text
                      _textController.clear();
                      FocusScope.of(context).unfocus();

                      if (userInput.isNotEmpty) {
                        setState(() {
                          chatLog.add(ChatMessage(
                            text: userInput,
                            sender: ChatMessageSender.user,
                          ));
                        });

                        try {
                          String response =
                              await _getGenerativeAIResponse(userInput);
                          setState(() {
                            chatLog.add(ChatMessage(
                              text: response,
                              sender: ChatMessageSender.bot,
                            ));
                          });
                        } catch (e) {
                          _textController.clear();
                          FocusScope.of(context).unfocus();
                          print('Error fetching response: $e');
                          setState(() {
                            chatLog.add(ChatMessage(
                              text: 'An error occurred',
                              sender: ChatMessageSender.bot,
                            ));
                          });
                        }
                      }
                    },
                    child: const Icon(Icons.send_rounded),
                  ),
                ),
              )),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: (chatLog.isEmpty)
                ? LottieBuilder.asset("assets/query.json")
                : ListView.builder(
                    reverse: true,
                    itemCount: chatLog.length,
                    itemBuilder: (context, index) {
                      return ChatMessageBubble(
                        message: chatLog[chatLog.length - 1 - index],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Future<String> _getGenerativeAIResponse(String userInput) async {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: GEMINI_API_KEY,
    );

    final content = [Content.text(userInput)];
    final response = await model.generateContent(content);

    return response.text!;
  }
}

enum ChatMessageSender { user, bot }

class ChatMessage {
  final String text;
  final ChatMessageSender sender;

  ChatMessage({required this.text, required this.sender});
}

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatMessageBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.sender == ChatMessageSender.user
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: message.sender == ChatMessageSender.user
              ? Colors.blue[300]
              : Colors.blueAccent[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(message.text),
      ),
    );
  }
}
