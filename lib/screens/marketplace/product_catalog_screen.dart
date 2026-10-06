import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:loannova_mobile_app/screens/marketplace/apply_screen.dart';
import 'package:loannova_mobile_app/screens/marketplace/my_applications_screen.dart';
import 'package:loannova_mobile_app/screens/credit_score/credit_score_screen.dart';
import 'package:loannova_mobile_app/screens/marketplace/saved_products_screen.dart';
import 'package:loannova_mobile_app/screens/kyc/kyc_upload_screen.dart';
import 'package:loannova_mobile_app/screens/ai_assistant/ai_assistant_screen.dart';
import 'package:loannova_mobile_app/screens/marketplace/loan_comparison_screen.dart';
import 'package:loannova_mobile_app/screens/notifications/notifications_screen.dart';
import 'package:loannova_mobile_app/notification_service.dart';
import 'package:loannova_mobile_app/screens/profile/profile_screen.dart';
import 'package:loannova_mobile_app/screens/profile/help_support_screen.dart';
import 'package:loannova_mobile_app/screens/profile/referral_screen.dart';
import 'package:loannova_mobile_app/screens/savings/savings_marketplace_screen.dart';
import 'package:loannova_mobile_app/screens/marketplace/credit_card_marketplace_screen.dart';
import 'package:loannova_mobile_app/screens/marketplace/insurance_marketplace_screen.dart';
import 'package:loannova_mobile_app/screens/marketplace/investment_marketplace_screen.dart';
import 'package:loannova_mobile_app/screens/calculators/calculator_hub_screen.dart';

class ProductCatalogScreen extends StatefulWidget {
  const ProductCatalogScreen({super.key});

  @override
  State<ProductCatalogScreen> createState() => _ProductCatalogScreenState();
}

class _ProductCatalogScreenState extends State<ProductCatalogScreen> {
  final supabase = Supabase.instance.client;

  // Track compared and saved items via IDs for reliable state toggling
  Set<String> comparedProductIds = {};
  List<Map<String, dynamic>> comparedProducts = [];

  Set<String> savedProductIds = {};
  List<Map<String, dynamic>> savedProducts = [];

  // Fetch products from PostgreSQL via Supabase API
  Future<List<Map<String, dynamic>>> fetchProducts() async {
    final response = await supabase.from('financial_products').select();
    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LoanNova Marketplace'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          // Saved Products / Bookmarks Icon Button
          IconButton(
            icon: const Icon(Icons.favorite),
            tooltip: 'Saved Products',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SavedProductsScreen(
                    savedProducts: savedProducts,
                    onRemove: (product) {
                      setState(() {
                        final id = product['id'].toString();
                        savedProductIds.remove(id);
                        savedProducts.removeWhere((p) => p['id'].toString() == id);
                      });
                    },
                  ),
                ),
              );
            },
          ),
          //Calculator hub
          IconButton(
            icon: const Icon(Icons.calculate),
            tooltip: 'Financial Calculators',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CalculatorHubScreen()),
              );
            },
          ),
          // Applications Tracker Icon Button
          IconButton(
            icon: const Icon(Icons.list_alt),
            tooltip: 'My Applications',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyApplicationsScreen()),
              );
            },
          ),
          //Insurance icon
          IconButton(
            icon: const Icon(Icons.security),
            tooltip: 'Insurance Plans',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const InsuranceMarketplaceScreen()),
              );
            },
          ),
          //Savings and account icon
          IconButton(
            icon: const Icon(Icons.account_balance_wallet),
            tooltip: 'Savings & Deposits',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SavingsMarketplaceScreen()),
              );
            },
          ),
          //Referral Screen
          IconButton(
            icon: const Icon(Icons.card_giftcard),
            tooltip: 'Referral & Rewards',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReferralScreen()),
              );
            },
          ),
          //Credit card
          IconButton(
            icon: const Icon(Icons.credit_card),
            tooltip: 'Credit Cards',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreditCardMarketplaceScreen()),
              );
            },
          ),
          //FAQ Buttons
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: 'Help & FAQ',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
              );
            },
          ),
          //Investment button
          IconButton(
            icon: const Icon(Icons.trending_up),
            tooltip: 'Investments & Wealth',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const InvestmentMarketplaceScreen()),
              );
            },
          ),
          // KYC Documents upload
          IconButton(
            icon: const Icon(Icons.folder_shared),
            tooltip: 'Digital KYC',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const KycUploadScreen()),
              );
            },
          ),
          // AI Chatbot
          IconButton(
            icon: const Icon(Icons.support_agent),
            tooltip: 'AI Assistant',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AiAssistantScreen()),
              );
            },
          ),
          //profile screen
          IconButton(
            icon: const Icon(Icons.account_circle),
            tooltip: 'My Profile',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          // Credit Score Dashboard Icon Button
          IconButton(
            icon: const Icon(Icons.speed),
            tooltip: 'Credit Score',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreditScoreScreen()),
              );
            },
          ),
          // In-App Notifications Bell with Red Badge Indicator
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications),
                if (NotificationService().notifications.isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: Text(
                        '${NotificationService().notifications.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            tooltip: 'Notifications',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationsScreen()),
              ).then((_) {
                setState(() {}); // Refresh badge count upon returning
              });
            },
          ),
          // Compare Products Icon Button
          IconButton(
            icon: const Icon(Icons.compare_arrows),
            tooltip: 'Compare Products',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoanComparisonScreen(
                    comparedProducts: comparedProducts,
                    onRemove: (product) {
                      setState(() {
                        final id = product['id'].toString();
                        comparedProductIds.remove(id);
                        comparedProducts.removeWhere((p) => p['id'].toString() == id);
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Error loading products: ${snapshot.error}'),
              ),
            );
          }
          final products = snapshot.data ?? [];
          if (products.isEmpty) {
            return const Center(
              child: Text('No products available right now.'),
            );
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final productId = product['id'].toString();
              final isSaved = savedProductIds.contains(productId);
              final isCompared = comparedProductIds.contains(productId);

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 3,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    product['title'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Provider: ${product['provider_name']}\nInterest Rate: ${product['interest_rate']}%',
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Compare Checkbox Toggle Button
                      IconButton(
                        icon: Icon(
                          isCompared ? Icons.check_box : Icons.check_box_outline_blank,
                          color: Colors.indigo,
                        ),
                        tooltip: 'Compare',
                        onPressed: () {
                          setState(() {
                            if (isCompared) {
                              comparedProductIds.remove(productId);
                              comparedProducts.removeWhere((p) => p['id'].toString() == productId);
                            } else {
                              if (comparedProducts.length < 3) {
                                comparedProductIds.add(productId);
                                comparedProducts.add(product);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('You can compare up to 3 products at a time.')),
                                );
                              }
                            }
                          });
                        },
                      ),
                      // Heart/Bookmark Toggle Button
                      IconButton(
                        icon: Icon(
                          isSaved ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          setState(() {
                            if (isSaved) {
                              savedProductIds.remove(productId);
                              savedProducts.removeWhere((p) => p['id'].toString() == productId);
                            } else {
                              savedProductIds.add(productId);
                              savedProducts.add(product);
                            }
                          });
                        },
                      ),
                      // Apply Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ApplyScreen(
                                productId: product['id'],
                                productTitle: product['title'],
                                providerName: product['provider_name'],
                              ),
                            ),
                          );
                        },
                        child: const Text('Apply'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}