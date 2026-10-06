import 'package:flutter/material.dart';

class InsuranceMarketplaceScreen extends StatelessWidget {
  const InsuranceMarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample insurance catalog for the MVP
    final List<Map<String, dynamic>> insuranceProducts = [
      {
        'title': 'SecureShield Term Life Cover',
        'provider': 'Apex Life Insurance',
        'coverage': '₹1 Crore Cover',
        'premium': '₹750 / month',
        'type': 'Term Life Insurance',
        'benefits': ['Coverage up to age 85', 'Tax benefits under Sec 80C & 10(10D)', 'Critical illness add-on available'],
        'color': Colors.teal,
      },
      {
        'title': 'Total Health Guard Family Floater',
        'provider': 'Vanguard Health Insurance',
        'coverage': '₹10 Lakhs Health Cover',
        'premium': '₹1,200 / month',
        'type': 'Health Insurance',
        'benefits': ['Cashless claims at 8,000+ hospitals', 'Free annual health checkup', 'No claim bonus up to 50% extra cover'],
        'color': Colors.blue,
      },
      {
        'title': 'Personal Accident Secure Plan',
        'provider': 'Metro General Insurance',
        'coverage': '₹25 Lakhs Protection',
        'premium': '₹299 / month',
        'type': 'Accident Protection',
        'benefits': ['Worldwide 24/7 coverage', 'Permanent & temporary disability cover', 'Children education benefit'],
        'color': Colors.indigo,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Insurance Marketplace'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: insuranceProducts.length,
        itemBuilder: (context, index) {
          final plan = insuranceProducts[index];
          final Color themeColor = plan['color'];

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: themeColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          plan['type'],
                          style: TextStyle(color: themeColor, fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      ),
                      Text(
                        plan['premium'],
                        style: TextStyle(color: themeColor, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    plan['title'],
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Provider: ${plan['provider']}  •  Coverage: ${plan['coverage']}',
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 10),
                  ...List.generate(
                    plan['benefits'].length,
                        (bIndex) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Row(
                        children: [
                          Icon(Icons.verified_user, size: 14, color: themeColor),
                          const SizedBox(width: 6),
                          Text(plan['benefits'][bIndex], style: const TextStyle(fontSize: 12, color: Colors.black87)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeColor,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Get Quote: ${plan['title']}'),
                            content: Text('Would you like to proceed with medical questionnaire and quote generation for ${plan['provider']}?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: themeColor, foregroundColor: Colors.white),
                                onPressed: () {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Quote requested successfully for ${plan['title']}!')),
                                  );
                                },
                                child: const Text('Proceed'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Text('Get Quote / Buy Plan'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}