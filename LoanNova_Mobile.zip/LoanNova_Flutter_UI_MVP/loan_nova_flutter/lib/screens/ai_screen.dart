import 'package:flutter/material.dart';

class AiScreen extends StatefulWidget {
  const AiScreen({super.key});

  @override
  State<AiScreen> createState() =>
      _AiScreenState();
}

class _AiScreenState extends State<AiScreen> {
  final controller =
      TextEditingController();

  final List<Map<String, dynamic>> messages = [
    {
      'ai': true,
      'text':
          'Hi! I’m Nova, your finance assistant. Ask me about loans, EMI or eligibility.',
    },
  ];

  void sendMessage() {
    final text = controller.text.trim();

    if (text.isEmpty) {
      return;
    }

    setState(() {
      messages.add({
        'ai': false,
        'text': text,
      });

      messages.add({
        'ai': true,
        'text':
            'This is the demo AI screen. Real AI/backend service can be connected later.',
      });

      controller.clear();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nova AI Assistant',
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(18),
              itemCount: messages.length,
              itemBuilder: (_, index) {
                final isAi =
                    messages[index]['ai'] as bool;

                return Align(
                  alignment: isAi
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Container(
                    margin:
                        const EdgeInsets.only(
                      bottom: 10,
                    ),
                    padding:
                        const EdgeInsets.all(14),
                    constraints:
                        const BoxConstraints(
                      maxWidth: 310,
                    ),
                    decoration: BoxDecoration(
                      color: isAi
                          ? Colors.white
                          : const Color(
                              0xFF3157E8,
                            ),
                      borderRadius:
                          BorderRadius.circular(18),
                    ),
                    child: Text(
                      messages[index]['text'],
                      style: TextStyle(
                        color: isAi
                            ? const Color(
                                0xFF202536,
                              )
                            : Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      onSubmitted: (_) {
                        sendMessage();
                      },
                      decoration:
                          const InputDecoration(
                        hintText:
                            'Ask Nova anything...',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: sendMessage,
                    icon: const Icon(
                      Icons.send,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}