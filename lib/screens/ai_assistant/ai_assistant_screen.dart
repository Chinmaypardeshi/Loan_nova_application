import 'package:flutter/material.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [
    {
      'sender': 'ai',
      'text': 'Hello! I am your LoanNova Assistant. Ask me about loans, interest rates, eligibility, or KYC documents!'
    }
  ];

  void _sendMessage() {
    final userText = _controller.text.trim();
    if (userText.isEmpty) return;

    setState(() {
      _messages.add({'sender': 'user', 'text': userText});
      _controller.clear();
    });

    // Simulate instant local smart response
    Future.delayed(const Duration(milliseconds: 500), () {
      final query = userText.toLowerCase();
      String reply = "I can help with that! You can browse our loan marketplace or use the EMI calculator from the top menu.";

      if (query.contains('eligibility') || query.contains('score') || query.contains('cibil')) {
        reply = "To be eligible for a loan, lenders typically look for a CIBIL credit score of 750+, stable monthly income, and a low existing debt ratio.";
      } else if (query.contains('document') || query.contains('kyc') || query.contains('pan') || query.contains('aadhaar')) {
        reply = "For digital verification, you can securely upload copies of your PAN card and Aadhaar card using our KYC Document module.";
      } else if (query.contains('interest') || query.contains('rate') || query.contains('apr')) {
        reply = "Interest rates on LoanNova range from 8.5% to 24% p.a. depending on the financial provider and loan type you choose.";
      } else if (query.contains('emi') || query.contains('calculator') || query.contains('month')) {
        reply = "You can easily calculate your monthly installments by tapping the calculator icon at the top right of the marketplace screen!";
      } else if (query.contains('hello') || query.contains('hi') || query.contains('hey')) {
        reply = "Hello there! How can I assist you with your loan application today?";
      }

      setState(() {
        _messages.add({'sender': 'ai', 'text': reply});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LoanNova Assistant'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['sender'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.indigo.shade100 : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      msg['text'] ?? '',
                      style: TextStyle(
                        color: isUser ? Colors.indigo.shade900 : Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.grey.shade100,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (_) => _sendMessage(),
                    decoration: const InputDecoration(
                      hintText: 'Ask about loans, eligibility, KYC...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.indigo),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}