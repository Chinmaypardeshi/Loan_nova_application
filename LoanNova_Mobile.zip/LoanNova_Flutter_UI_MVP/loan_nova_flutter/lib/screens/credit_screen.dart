import 'package:flutter/material.dart';

class CreditScreen extends StatelessWidget {
  const CreditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Credit Score',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(26),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF111B3A),
                  Color(0xFF263A7A),
                ],
              ),
              borderRadius:
                  BorderRadius.circular(26),
            ),
            child: const Column(
              children: [
                Text(
                  'Your Score',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '782',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 54,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  'Excellent',
                  style: TextStyle(
                    color: Color(0xFF7FE8BF),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _rating(
            'Payment history',
            0.95,
          ),
          _rating(
            'Credit utilization',
            0.72,
          ),
          _rating(
            'Credit age',
            0.88,
          ),
          _rating(
            'New credit',
            0.70,
          ),
        ],
      ),
    );
  }

  Widget _rating(
    String title,
    double value,
  ) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Text(
                  'Good',
                  style: TextStyle(
                    color: Color(0xFF0F9D78),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: value,
            ),
          ],
        ),
      ),
    );
  }
}