import 'package:flutter/material.dart';

class EligibilityScreen extends StatefulWidget {
  const EligibilityScreen({super.key});

  @override
  State<EligibilityScreen> createState() =>
      _EligibilityScreenState();
}

class _EligibilityScreenState
    extends State<EligibilityScreen> {
  final incomeController =
      TextEditingController();

  final ageController =
      TextEditingController();

  bool? eligible;

  void checkEligibility() {
    final income =
        double.tryParse(
              incomeController.text,
            ) ??
            0;

    final age =
        int.tryParse(
              ageController.text,
            ) ??
            0;

    setState(() {
      eligible = income >= 25000 &&
          age >= 21 &&
          age <= 60;
    });
  }

  @override
  void dispose() {
    incomeController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Eligibility Checker',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Check your estimated eligibility',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 20),

          TextField(
            controller: incomeController,
            keyboardType:
                TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Monthly income',
              prefixIcon:
                  Icon(Icons.currency_rupee),
            ),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: ageController,
            keyboardType:
                TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Age',
              prefixIcon:
                  Icon(Icons.cake_outlined),
            ),
          ),

          const SizedBox(height: 18),

          SizedBox(
            height: 52,
            child: FilledButton(
              onPressed: checkEligibility,
              child: const Text(
                'Check Eligibility',
              ),
            ),
          ),

          if (eligible != null)
            Container(
              margin:
                  const EdgeInsets.only(top: 20),
              padding:
                  const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: eligible!
                    ? const Color(0xFFE9FBF4)
                    : const Color(0xFFFFF0F0),
                borderRadius:
                    BorderRadius.circular(18),
              ),
              child: Text(
                eligible!
                    ? 'You may be eligible based on these demo inputs.'
                    : 'You may need to improve your eligibility based on these demo inputs.',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}