import 'package:flutter/material.dart';
import 'package:loannova_mobile_app/screens/calculators/eligibility_hub_screen.dart';
import 'package:loannova_mobile_app/screens/calculators/financial_hub_screen.dart';

class CalculatorHubScreen extends StatelessWidget {
  const CalculatorHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LoanNova Calculators'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Financial & Eligibility Tools',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            'Select a category below to access specialized calculators.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 20),

          // 1. Eligibility Calculators Hub Card
          _buildHubCategoryCard(
            context,
            title: 'Eligibility Calculators',
            subtitle: 'Check home loan borrowing limits, DTI ratios, and max approvals.',
            icon: Icons.verified_user,
            color: Colors.blueAccent,
            destination: const EligibilityHubScreen(),
          ),
          const SizedBox(height: 16),

          // 2. Financial & Wealth Calculators Hub Card
          _buildHubCategoryCard(
            context,
            title: 'Financial & Wealth Calculators',
            subtitle: 'Plan your EMIs, SIPs, FD/RDs, retirement, inflation, and tax savings.',
            icon: Icons.account_balance_wallet,
            color: Colors.purple,
            destination: const FinancialHubScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildHubCategoryCard(
      BuildContext context, {
        required String title,
        required String subtitle,
        required IconData icon,
        required Color color,
        required Widget destination,
      }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}