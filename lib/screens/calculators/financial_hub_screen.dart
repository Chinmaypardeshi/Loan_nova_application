import 'package:flutter/material.dart';
import 'package:loannova_mobile_app/screens/calculators/financial_calculators/emi_calculator_screen.dart';
import 'package:loannova_mobile_app/screens/calculators/financial_calculators/sip_calculator_screen.dart';
import 'package:loannova_mobile_app/screens/calculators/financial_calculators/fd_rd_calculator_screen.dart';
import 'package:loannova_mobile_app/screens/calculators/financial_calculators/retirement_calculator_screen.dart';
import 'package:loannova_mobile_app/screens/calculators/financial_calculators/inflation_calculator_screen.dart';
import 'package:loannova_mobile_app/screens/calculators/financial_calculators/education_planning_calculator_screen.dart';
import 'package:loannova_mobile_app/screens/calculators/financial_calculators/tax_calculator_screen.dart';
import 'package:loannova_mobile_app/screens/calculators/financial_calculators/business_loan_calculator_screen.dart';

class FinancialHubScreen extends StatelessWidget {
  const FinancialHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial & Wealth Calculators'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildToolCard(context, 'Loan EMI Calculator', 'Calculate loan monthly installments.', Icons.calculate, const EmiCalculatorScreen()),
          _buildToolCard(context, 'SIP & Wealth Calculator', 'Estimate mutual fund growth and returns.', Icons.trending_up, const SipCalculatorScreen()),
          _buildToolCard(context, 'FD & RD Calculator', 'Calculate Fixed and Recurring Deposit earnings.', Icons.account_balance, const FdRdCalculatorScreen()),
          _buildToolCard(context, 'Retirement Planning', 'Estimate future living expenses and corpus.', Icons.beach_access, const RetirementCalculatorScreen()),
          _buildToolCard(context, 'Inflation Impact Calculator', 'Understand purchasing power erosion.', Icons.trending_down, const InflationCalculatorScreen()),
          _buildToolCard(context, 'Education Planning', 'Project higher-education costs for children.', Icons.school, const EducationPlanningCalculatorScreen()),
          _buildToolCard(context, 'Tax Savings & Regime', 'Compare Old vs. New tax regime liabilities.', Icons.receipt_long, const TaxCalculatorScreen()),
          _buildToolCard(context, 'Business Loan Calculator', 'Calculate commercial loan EMIs and cash flows.', Icons.business_center, const BusinessLoanCalculatorScreen()),
        ],
      ),
    );
  }

  Widget _buildToolCard(BuildContext context, String title, String subtitle, IconData icon, Widget destination) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: Colors.indigo, size: 28),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => destination)),
      ),
    );
  }
}