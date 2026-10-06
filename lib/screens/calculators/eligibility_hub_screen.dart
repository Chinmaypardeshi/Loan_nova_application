import 'package:flutter/material.dart';
import 'package:loannova_mobile_app/screens/calculators/eligibility_calculators/home_loan_calculator_screen.dart';
import 'package:loannova_mobile_app/screens/calculators/eligibility_calculators/debt_to_income_calculator_screen.dart';
import 'package:loannova_mobile_app/screens/calculators/eligibility_calculators/insurance_requirement_calculator_screen.dart';

class EligibilityHubScreen extends StatelessWidget {
  const EligibilityHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eligibility & Assessment Tools'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildToolCard(
            context,
            title: 'Loan Eligibility & Affordability',
            subtitle: 'Calculate maximum borrowing limits based on net income and FOIR.',
            icon: Icons.home,
            destination: const HomeLoanCalculatorScreen(),
          ),
          _buildToolCard(
            context,
            title: 'Debt-to-Income (DTI) Ratio',
            subtitle: 'Evaluate your monthly debt burden relative to income.',
            icon: Icons.pie_chart,
            destination: const DebtToIncomeCalculatorScreen(),
          ),
          _buildToolCard(
            context,
            title: 'Insurance Requirement Calculator',
            subtitle: 'Estimate optimal term life cover based on income and liabilities.',
            icon: Icons.security,
            destination: const InsuranceRequirementCalculatorScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildToolCard(
      BuildContext context, {
        required String title,
        required String subtitle,
        required IconData icon,
        required Widget destination,
      }) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: Colors.indigo, size: 28),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        ),
      ),
    );
  }
}