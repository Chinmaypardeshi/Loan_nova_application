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
import 'package:loannova_mobile_app/screens/application_tracking_screen.dart';
import 'package:loannova_mobile_app/screens/user_profile_screen.dart';

class ProductCatalogScreen extends StatefulWidget {
  const ProductCatalogScreen({super.key});

  @override
  State<ProductCatalogScreen> createState() => _ProductCatalogScreenState();
}

class _ProductCatalogScreenState extends State<ProductCatalogScreen> {
  final supabase = Supabase.instance.client;

  Set<String> comparedProductIds = {};
  List<Map<String, dynamic>> comparedProducts = [];

  Set<String> savedProductIds = {};
  List<Map<String, dynamic>> savedProducts = [];

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
          // 1. Saved / Favorites Button (Quick Access)
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

          // 2. Notifications Bell with Badge (Quick Access)
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
                      constraints: const BoxConstraints(minWidth: 12, minHeight: 12),
                      child: Text(
                        '${NotificationService().notifications.length}',
                        style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
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
              ).then((_) => setState(() {}));
            },
          ),

          // 3. Clean Overflow Menu containing all other feature screens (Zero Overflow)
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu),
            tooltip: 'More Options',
            onSelected: (value) {
              Widget destination;
              switch (value) {
                case 'calculators':
                  destination = const CalculatorHubScreen();
                  break;
                case 'tracking':
                  destination = const ApplicationTrackingScreen();
                  break;
                case 'applications':
                  destination = const MyApplicationsScreen();
                  break;
                case 'insurance':
                  destination = const InsuranceMarketplaceScreen();
                  break;
                case 'savings':
                  destination = const SavingsMarketplaceScreen();
                  break;
                case 'investments':
                  destination = const InvestmentMarketplaceScreen();
                  break;
                case 'credit_cards':
                  destination = const CreditCardMarketplaceScreen();
                  break;
                case 'credit_score':
                  destination = const CreditScoreScreen();
                  break;
                case 'kyc':
                  destination = const KycUploadScreen();
                  break;
                case 'user_vault':
                  destination = const UserProfileScreen();
                  break;
                case 'ai_assistant':
                  destination = const AiAssistantScreen();
                  break;
                case 'referral':
                  destination = const ReferralScreen();
                  break;
                case 'help':
                  destination = const HelpSupportScreen();
                  break;
                case 'profile':
                  destination = const ProfileScreen();
                  break;
                case 'compare':
                  destination = LoanComparisonScreen(
                    comparedProducts: comparedProducts,
                    onRemove: (product) {
                      setState(() {
                        final id = product['id'].toString();
                        comparedProductIds.remove(id);
                        comparedProducts.removeWhere((p) => p['id'].toString() == id);
                      });
                    },
                  );
                  break;
                default:
                  return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (context) => destination));
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(value: 'calculators', child: ListTile(leading: Icon(Icons.calculate, color: Colors.indigo), title: Text('Calculators Hub'))),
              const PopupMenuItem(value: 'tracking', child: ListTile(leading: Icon(Icons.track_changes, color: Colors.indigo), title: Text('Track Applications'))),
              const PopupMenuItem(value: 'applications', child: ListTile(leading: Icon(Icons.list_alt, color: Colors.indigo), title: Text('My Applications'))),
              const PopupMenuItem(value: 'compare', child: ListTile(leading: Icon(Icons.compare_arrows, color: Colors.indigo), title: Text('Compare Products'))),
              const PopupMenuItem(value: 'insurance', child: ListTile(leading: Icon(Icons.security, color: Colors.indigo), title: Text('Insurance Marketplace'))),
              const PopupMenuItem(value: 'savings', child: ListTile(leading: Icon(Icons.account_balance_wallet, color: Colors.indigo), title: Text('Savings & Deposits'))),
              const PopupMenuItem(value: 'investments', child: ListTile(leading: Icon(Icons.trending_up, color: Colors.indigo), title: Text('Investments & Wealth'))),
              const PopupMenuItem(value: 'credit_cards', child: ListTile(leading: Icon(Icons.credit_card, color: Colors.indigo), title: Text('Credit Cards'))),
              const PopupMenuItem(value: 'credit_score', child: ListTile(leading: Icon(Icons.speed, color: Colors.indigo), title: Text('Credit Score Dashboard'))),
              const PopupMenuItem(value: 'kyc', child: ListTile(leading: Icon(Icons.folder_shared, color: Colors.indigo), title: Text('Digital KYC Upload'))),
              const PopupMenuItem(value: 'user_vault', child: ListTile(leading: Icon(Icons.person, color: Colors.indigo), title: Text('User Profile & Vault'))),
              const PopupMenuItem(value: 'ai_assistant', child: ListTile(leading: Icon(Icons.support_agent, color: Colors.indigo), title: Text('AI Financial Assistant'))),
              const PopupMenuItem(value: 'referral', child: ListTile(leading: Icon(Icons.card_giftcard, color: Colors.indigo), title: Text('Referral & Rewards'))),
              const PopupMenuItem(value: 'help', child: ListTile(leading: Icon(Icons.help_outline, color: Colors.indigo), title: Text('Help & FAQ'))),
              const PopupMenuItem(value: 'profile', child: ListTile(leading: Icon(Icons.account_circle, color: Colors.indigo), title: Text('My Account Profile'))),
            ],
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