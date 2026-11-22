import 'package:flutter/material.dart';

class EmiScreen extends StatefulWidget {
  const EmiScreen({super.key});

  @override
  State<EmiScreen> createState() =>
      _EmiScreenState();
}

class _EmiScreenState
    extends State<EmiScreen> {
  double amount = 500000;
  double rate = 10.5;
  double years = 5;

  double get emi {
    final monthlyRate = rate / 12 / 100;
    final months = years * 12;

    if (monthlyRate == 0) {
      return amount / months;
    }

    double power = 1;

    for (int i = 0; i < months; i++) {
      power *= 1 + monthlyRate;
    }

    return amount *
        monthlyRate *
        power /
        (power - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'EMI Calculator',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF3157E8),
                  Color(0xFF6D5DF5),
                ],
              ),
              borderRadius:
                  BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                const Text(
                  'Monthly EMI',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '₹${emi.round()}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          _slider(
            'Loan Amount',
            '₹${amount.round()}',
            amount,
            50000,
            5000000,
            50000,
            (value) {
              setState(() {
                amount = value;
              });
            },
          ),

          _slider(
            'Interest Rate',
            '${rate.toStringAsFixed(1)}%',
            rate,
            5,
            25,
            0.5,
            (value) {
              setState(() {
                rate = value;
              });
            },
          ),

          _slider(
            'Tenure',
            '${years.round()} years',
            years,
            1,
            30,
            1,
            (value) {
              setState(() {
                years = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _slider(
    String title,
    String valueText,
    double value,
    double min,
    double max,
    double division,
    ValueChanged<double> onChanged,
  ) {
    return Column(
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
            Text(
              valueText,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: Color(0xFF3157E8),
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions:
              ((max - min) / division).round(),
          onChanged: onChanged,
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}