import 'package:flutter/material.dart';

import 'application_screen.dart';
import '../models/loan.dart';
import 'emi_screen.dart';
import 'repayments_screen.dart';

class LoanDetailScreen extends StatelessWidget {
  final Loan loan;

  const LoanDetailScreen({
    super.key,
    required this.loan,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan Details'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // =========================
          // LOAN HEADER
          // =========================
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  loan.color,
                  loan.color.withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(26),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  loan.icon,
                  color: Colors.white,
                  size: 38,
                ),
                const SizedBox(height: 18),
                Text(
                  loan.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  loan.subtitle,
                  style: const TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // =========================
          // LOAN INFORMATION
          // =========================
          _info(
            'Interest rate',
            loan.rate,
          ),

          _info(
            'Tenure',
            loan.tenureText,
          ),

          _info(
            'Processing fee',
            loan.fee,
          ),

          _info(
            'Estimated EMI',
            loan.emiText,
          ),

          const SizedBox(height: 15),

          // =========================
          // EMI CALCULATOR
          // =========================
          OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const EmiScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.calculate_outlined,
            ),
            label: const Text(
              'Calculate EMI',
            ),
          ),

          const SizedBox(height: 10),

          // =========================
          // REPAYMENT SCHEDULE
          // =========================
          OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RepaymentsScreen(
                    loanId: loan.id,
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.receipt_long_outlined,
            ),
            label: const Text(
              'View EMI Schedule',
            ),
          ),

          const SizedBox(height: 10),

          // =========================
          // APPLY NOW
          // =========================
          SizedBox(
            height: 52,
            child: FilledButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ApplicationScreen(
                      loanId: loan.id,
                      loanName: loan.title,
                      maxAmount: loan.amount,
                      interestRate: loan.interestRate,
                    ),
                  ),
                );
              },
              child: const Text(
                'Apply Now',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // INFO ROW
  // =========================
  Widget _info(
    String title,
    String value,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE8EAF1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF7B8190),
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}