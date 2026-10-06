import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // List of frequently asked questions and answers
    final List<Map<String, String>> faqs = [
      {
        'question': 'What documents are required to apply for a loan?',
        'answer': 'You will need a scanned copy of your PAN Card, Aadhaar Card for identity/address verification, and optionally your last 3 months salary slips or income proof.'
      },
      {
        'question': 'How long does loan approval take?',
        'answer': 'Initial provisional approval happens instantly upon submitting your application. Final lender verification and disbursal typically take 24 to 48 working hours.'
      },
      {
        'question': 'Is my personal and financial data secure?',
        'answer': 'Yes! LoanNova uses enterprise-grade encryption (TLS & AES-256) to protect all your documents and personal information securely.'
      },
      {
        'question': 'How is my EMI calculated?',
        'answer': 'EMIs are calculated using your loan principal amount, the annual interest rate, and the loan tenure (in months) using the reducing balance formula.'
      },
      {
        'question': 'Can I compare multiple loan offers side-by-side?',
        'answer': 'Yes, you can select up to 3 loan products in our marketplace using the checkbox icon and tap the comparison icon in the app bar to view them side-by-side.'
      },
      {
        'question': 'How do I check my credit health?',
        'answer': 'You can access our built-in Credit Score module from the marketplace app bar to check your CIBIL score simulator and health reports.'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support FAQ'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Banner Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.indigo.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.indigo.shade100),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.indigo,
                  child: Icon(Icons.support_agent, size: 35, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'How can we help you?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Browse our FAQs below or reach out to our 24/7 support team.',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Frequently Asked Questions',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // FAQ Accordion List
          ...faqs.map((faq) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              elevation: 1,
              child: ExpansionTile(
                title: Text(
                  faq['question']!,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Text(
                      faq['answer']!,
                      style: const TextStyle(color: Colors.black87, fontSize: 13, height: 1.4),
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 24),

          // Contact Support Card
          Card(
            color: Colors.grey.shade50,
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Still need assistance?',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Our support desk is available Monday through Saturday.',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(foregroundColor: Colors.indigo),
                          icon: const Icon(Icons.email),
                          label: const Text('Email Us'),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Support email copied: support@loannova.app')),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.phone),
                          label: const Text('Call Helpline'),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Calling 1800-LOAN-NOVA...')),
                            );
                          },
                        ),
                      ),
                    ],
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