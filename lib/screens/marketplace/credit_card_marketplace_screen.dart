import 'package:flutter/material.dart';

class CreditCardMarketplaceScreen extends StatelessWidget {
  const CreditCardMarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample credit card catalog for the MVP
    final List<Map<String, dynamic>> creditCards = [
      {
        'title': 'Elite Travel Rewards Card',
        'provider': 'Aura Bank',
        'fee': '₹2,999 / year',
        'rewardRate': '5X Reward Points on Travel & Dining',
        'type': 'Travel & Lifestyle',
        'perks': ['Complimentary airport lounge access', 'Zero foreign markup fee', 'Welcome bonus 10,000 points'],
        'color': Colors.deepPurple,
      },
      {
        'title': 'Super Cashback Card',
        'provider': 'Apex Finance',
        'fee': '₹499 / year (Free on ₹1L spend)',
        'rewardRate': '5% Cashback on Online Shopping',
        'type': 'Cashback & Shopping',
        'perks': ['Direct statement credit every month', 'Complimentary movie tickets', 'Fuel surcharge waiver'],
        'color': Colors.blueAccent,
      },
      {
        'title': 'Titanium Business Card',
        'provider': 'Metro Trust',
        'fee': '₹4,999 / year',
        'rewardRate': '3% on Business Expenses',
        'type': 'Corporate & Business',
        'perks': ['Expense management portal', 'Higher credit limits up to ₹15 Lakhs', 'Airport spa access'],
        'color': Colors.indigo,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Credit Card Marketplace'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: creditCards.length,
        itemBuilder: (context, index) {
          final card = creditCards[index];
          final Color themeColor = card['color'];

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
                          card['type'],
                          style: TextStyle(color: themeColor, fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      ),
                      Text(
                        card['fee'],
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    card['title'],
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Provider: ${card['provider']}  •  ${card['rewardRate']}',
                    style: TextStyle(color: themeColor, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 10),
                  ...List.generate(
                    card['perks'].length,
                        (pIndex) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Row(
                        children: [
                          Icon(Icons.star, size: 14, color: themeColor),
                          const SizedBox(width: 6),
                          Text(card['perks'][pIndex], style: const TextStyle(fontSize: 12, color: Colors.black87)),
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
                            title: Text('Apply for ${card['title']}'),
                            content: Text('Would you like to initiate your instant digital application with ${card['provider']}?'),
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
                                    SnackBar(content: Text('Application submitted successfully for ${card['title']}!')),
                                  );
                                },
                                child: const Text('Confirm Application'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Text('Apply Now'),
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