import 'package:flutter/material.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Chat message list holding messages with sender identification (user vs. ai)
  final List<Map<String, String>> _messages = [
    {
      'sender': 'ai',
      'text': 'Hello! I am your LoanNova AI Financial Assistant. How can I help you optimize your loans, taxes, or investments today?',
    },
  ];

  // Quick suggestion chips for instant interactivity
  final List<String> _suggestions = [
    'Which tax regime is best for 12 LPA?',
    'Calculate my home loan eligibility',
    'How do I lower my DTI ratio?',
    'Recommend high-growth SIPs',
  ];

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;

    _controller.clear();
    setState(() {
      _messages.add({'sender': 'user', 'text': text});
    });

    _scrollToBottom();

    // Simulate intelligent AI financial response
    Future.delayed(const Duration(milliseconds: 800), () {
      String aiResponse = _generateAiResponse(text);
      setState(() {
        _messages.add({'sender': 'ai', 'text': aiResponse});
      });
      _scrollToBottom();
    });
  }

  String _generateAiResponse(String query) {
    query = query.toLowerCase();
    if (query.contains('tax') || query.contains('regime') || query.contains('lpa')) {
      return 'Based on current tax laws, if your annual salary is around 12 LPA with standard deductions, the New Tax Regime often results in lower tax liability unless you have over ₹2.5 Lakhs in Section 80C/80D/HRA deductions. You can check exact numbers using our Tax Calculator in the Calculator Hub!';
    } else if (query.contains('home loan') || query.contains('eligibility')) {
      return 'Banks typically look at your FOIR (Fixed Obligation to Income Ratio), allowing up to 50% of your net monthly income for EMIs. Try our Home Loan Eligibility Calculator in the Eligibility Hub to see your max borrowing limit.';
    } else if (query.contains('dti') || query.contains('debt')) {
      return 'Your Debt-to-Income (DTI) ratio is your monthly debt payments divided by your gross monthly income. Lenders prefer a DTI ratio below 30% to 40% for quick approvals.';
    } else if (query.contains('sip') || query.contains('invest') || query.contains('growth')) {
      return 'For long-term wealth creation, equity mutual funds via monthly SIPs historically offer strong compounding returns. Check out our Investment Marketplace to explore top-rated funds!';
    } else {
      return 'That is a great question! For detailed processing, you can check your active applications or use our suite of specialized financial calculators under the Calculator Hub.';
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LoanNova AI Assistant'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Chat Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final bool isUser = message['sender'] == 'user';

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.indigo : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      message['text']!,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Quick Prompt Suggestion Chips
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _suggestions.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ActionChip(
                    backgroundColor: Colors.indigo.shade50,
                    label: Text(_suggestions[index], style: const TextStyle(fontSize: 12, color: Colors.indigo)),
                    onPressed: () => _handleSubmitted(_suggestions[index]),
                  ),
                );
              },
            ),
          ),

          // Text Input Bar
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textInputAction: TextInputAction.send,
                    onSubmitted: _handleSubmitted,
                    decoration: InputDecoration(
                      hintText: 'Ask about loans, tax, or investments...',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.indigo,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 18),
                    onPressed: () => _handleSubmitted(_controller.text),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}