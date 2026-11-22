import 'package:flutter/material.dart';

import '../models/loan.dart';
import '../screens/loan_detail_screen.dart';

class LoanCard extends StatelessWidget {
  final Loan loan;

  const LoanCard({
    super.key,
    required this.loan,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFE8EAF1),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: loan.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  loan.icon,
                  color: loan.color,
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      loan.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      loan.subtitle,
                      style: const TextStyle(
                        color: Color(0xFF7B8190),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              _statusBadge(loan.status),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              _stat('Interest', loan.rate),
              _stat('Tenure', loan.tenureText),
              _stat('Amount', '₹${loan.amount.toStringAsFixed(0)}'),
            ],
          ),

          const SizedBox(height: 15),

          Row(
            children: [
              Expanded(
                child: Text(
                  'EMI ₹${loan.emi.toStringAsFixed(2)}/mo',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              FilledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          LoanDetailScreen(loan: loan),
                    ),
                  );
                },
                child: const Text('View'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color color;

    switch (status) {
      case 'APPROVED':
      case 'ACTIVE':
        color = const Color(0xFF0F9D78);
        break;

      case 'REJECTED':
        color = Colors.red;
        break;

      default:
        color = const Color(0xFFF59E0B);
    }

    return Text(
      status,
      style: TextStyle(
        color: color,
        fontSize: 9,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget _stat(String title, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF8A90A0),
              fontSize: 11,
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