import 'package:flutter/material.dart';
import 'package:loannova_mobile_app/screens/savings/savings_application_screen.dart';
class SavingsMarketplaceScreen extends StatelessWidget {
  const SavingsMarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample savings & deposit products catalog for the MVP
    final List<Map<String, dynamic>> savingsProducts = [
      {
        'title': 'High-Yield Digital Savings Account',
        'provider': 'Aura Bank',
        'rate': '7.25% p.a.',
        'minBalance': '₹10,000',
        'type': 'Savings Account',
        'features': ['Zero balance digital onboarding', 'Unlimited free ATM transactions', 'Monthly interest credit'],
        'color': Colors.teal,
      },
      {
        'title': 'Super Fixed Deposit Scheme',
        'provider': 'Apex Finance Corp',
        'rate': '8.50% p.a.',
        'minBalance': '₹5,000',
        'type': 'Fixed Deposit (1 Year)',
        'features': ['Guaranteed returns', 'Overdraft facility up to 90%', 'Senior citizen +0.5% extra'],
        'color': Colors.blue,
      },
      {
        'title': 'Flexible Recurring Deposit',
        'provider': 'Metro Trust Bank',
        'rate': '7.80% p.a.',
        'minBalance': '₹1,000 / month',
        'type': 'Recurring Deposit',
        'features': ['Deposit small amounts monthly', 'No penalty on early closure after 6 months', 'Auto-debit setup'],
        'color': Colors.indigo,
      },
      {
        'title': 'Corporate Salary Account',
        'provider': 'Vanguard Bank',
        'rate': '6.50% p.a.',
        'minBalance': '₹0 (Zero Balance)',
        'type': 'Salary Account',
        'features': ['Free accidental insurance cover of ₹25 Lakhs', 'Complimentary credit card', 'Preferential loan rates'],
        'color': Colors.purple,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Savings & Deposits Marketplace'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: savingsProducts.length,
        itemBuilder: (context, index) {
          final product = savingsProducts[index];
          final Color themeColor = product['color'];

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
                          product['type'],
                          style: TextStyle(color: themeColor, fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      ),
                      Text(
                        product['rate'],
                        style: TextStyle(color: themeColor, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    product['title'],
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Provider: ${product['provider']}  •  Min Balance: ${product['minBalance']}',
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 10),
                  ...List.generate(
                    product['features'].length,
                        (fIndex) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle_outline, size: 14, color: themeColor),
                          const SizedBox(width: 6),
                          Text(product['features'][fIndex], style: const TextStyle(fontSize: 12, color: Colors.black87)),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SavingsApplicationScreen(
                              productTitle: product['title'],
                              providerName: product['provider'],
                              interestRate: product['rate'],
                            ),
                          ),
                        );
                      },
                      child: const Text('Open Account / Invest'),
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