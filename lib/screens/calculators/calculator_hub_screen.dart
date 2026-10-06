import 'package:flutter/material.dart';
import 'package:loannova_mobile_app/screens/calculators/financial_calculators/emi_calculator_screen.dart';
import 'package:loannova_mobile_app/screens/calculators/financial_calculators/sip_calculator_screen.dart';
import 'package:loannova_mobile_app/screens/calculators/financial_calculators/fd_rd_calculator_screen.dart';
import 'package:loannova_mobile_app/screens/calculators/financial_calculators/home_loan_calculator_screen.dart';
import 'package:loannova_mobile_app/screens/calculators/financial_calculators/retirement_calculator_screen.dart';
import 'package:loannova_mobile_app/screens/calculators/financial_calculators/inflation_calculator_screen.dart';
import 'package:loannova_mobile_app/screens/calculators/financial_calculators/education_planning_calculator_screen.dart';
import 'package:loannova_mobile_app/screens/calculators/financial_calculators/tax_calculator_screen.dart';
import 'package:loannova_mobile_app/screens/calculators/financial_calculators/business_loan_calculator_screen.dart';

class CalculatorHubScreen extends StatelessWidget {
  const CalculatorHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial Calculators'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Smart Financial Planning Tools',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            'Choose a calculator below to estimate your loans or investment growth.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 20),

          // 1. EMI Calculator Card
          _buildCalculatorCard(
            context,
            title: 'Loan EMI Calculator',
            subtitle: 'Calculate monthly loan installments, interest, and total payable amount.',
            icon: Icons.calculate,
            color: Colors.indigo,
            destination: const EmiCalculatorScreen(),
          ),
          const SizedBox(height: 12),

          // 2. SIP Calculator Card
          _buildCalculatorCard(
            context,
            title: 'SIP & Wealth Calculator',
            subtitle: 'Estimate mutual fund returns, growth, and long-term wealth accumulation.',
            icon: Icons.trending_up,
            color: Colors.purple,
            destination: const SipCalculatorScreen(),
          ),
          //home loan calculator
          _buildCalculatorCard(
            context,
            title: 'Home Loan Eligibility',
            subtitle: 'Check your maximum loan borrowing capacity based on income and existing debt.',
            icon: Icons.home,
            color: Colors.indigoAccent,
            destination: const HomeLoanCalculatorScreen(),
          ),
          //fixed deposit and recurring deposit calculator
          _buildCalculatorCard(
            context,
            title: 'FD & RD Calculator',
            subtitle: 'Calculate maturity earnings for Fixed and Recurring Deposits.',
            icon: Icons.account_balance,
            color: Colors.teal,
            destination: const FdRdCalculatorScreen(),
          ),
          //Retirement calculator
          _buildCalculatorCard(
            context,
            title: 'Retirement Planning',
            subtitle: 'Estimate future living expenses and required monthly SIP for retirement.',
            icon: Icons.beach_access,
            color: Colors.deepOrange,
            destination: const RetirementCalculatorScreen(),
          ),
          //inflation impact calculator
          _buildCalculatorCard(
            context,
            title: 'Inflation Impact Calculator',
            subtitle: 'Understand how inflation erodes purchasing power and increases future expenses.',
            icon: Icons.trending_down,
            color: Colors.redAccent,
            destination: const InflationCalculatorScreen(),
          ),
          //Education planning calculator
          _buildCalculatorCard(
            context,
            title: 'Education Planning',
            subtitle: 'Project future higher-education expenses and calculate required monthly SIP savings.',
            icon: Icons.school,
            color: Colors.blueGrey,
            destination: const EducationPlanningCalculatorScreen(),
          ),
          //Tax and regime calculator
          _buildCalculatorCard(
            context,
            title: 'Tax Savings & Regime Calculator',
            subtitle: 'Compare income tax liability between Old and New tax regimes.',
            icon: Icons.receipt_long,
            color: Colors.purpleAccent,
            destination: const TaxCalculatorScreen(),
          ),
          //Business Calculator
          _buildCalculatorCard(
            context,
            title: 'Business Loan Calculator',
            subtitle: 'Calculate commercial loan EMIs, interest outgo, and working capital cash flows.',
            icon: Icons.business_center,
            color: Colors.brown,
            destination: const BusinessLoanCalculatorScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculatorCard(
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
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 28),
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