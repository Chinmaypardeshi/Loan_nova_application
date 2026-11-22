import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  void _showComingSoon(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title feature will be available soon'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Help & Support',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 10),

          const Icon(
            Icons.support_agent_outlined,
            size: 64,
            color: Color(0xFF3157E8),
          ),

          const SizedBox(height: 16),

          const Text(
            'How can we help?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Find answers to common questions or get help with your LoanNova account.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 30),

          _helpItem(
            context,
            Icons.question_answer_outlined,
            'Frequently Asked Questions',
            'Find answers to common questions',
            () {
              _showComingSoon(
                context,
                'FAQs',
              );
            },
          ),

          _helpItem(
            context,
            Icons.email_outlined,
            'Contact Support',
            'Get help from the LoanNova support team',
            () {
              _showComingSoon(
                context,
                'Contact Support',
              );
            },
          ),

          _helpItem(
            context,
            Icons.report_problem_outlined,
            'Report a Problem',
            'Tell us if something is not working',
            () {
              _showComingSoon(
                context,
                'Report Problem',
              );
            },
          ),

          _helpItem(
            context,
            Icons.info_outline,
            'About LoanNova',
            'Learn more about the application',
            () {
              showAboutDialog(
                context: context,
                applicationName: 'LoanNova',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(
                  Icons.account_balance,
                  color: Color(0xFF3157E8),
                ),
                children: const [
                  Text(
                    'LoanNova is a loan management application designed to help users manage loans, applications, EMIs and repayments.',
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _helpItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6,
        ),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF0FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF3157E8),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(subtitle),
        ),
        trailing: const Icon(
          Icons.chevron_right,
        ),
      ),
    );
  }
}