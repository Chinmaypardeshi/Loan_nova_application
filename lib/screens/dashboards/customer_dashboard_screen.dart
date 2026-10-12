import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:loannova_mobile_app/screens/providers/app_state.dart';
import 'package:loannova_mobile_app/screens/marketplace/product_catalog_screen.dart';
import 'package:loannova_mobile_app/screens/marketplace/credit_card_marketplace_screen.dart';
import 'package:loannova_mobile_app/screens/calculators/calculator_hub_screen.dart';
import 'package:loannova_mobile_app/screens/kyc/kyc_upload_screen.dart';
import 'package:loannova_mobile_app/screens/notifications/notifications_screen.dart';
import 'package:loannova_mobile_app/notification_service.dart';
import 'package:loannova_mobile_app/screens/marketplace/my_applications_screen.dart';
import 'package:loannova_mobile_app/screens/marketplace/insurance_marketplace_screen.dart';
import 'package:loannova_mobile_app/screens/savings/savings_marketplace_screen.dart';
import 'package:loannova_mobile_app/screens/marketplace/investment_marketplace_screen.dart';
import 'package:loannova_mobile_app/screens/credit_score/credit_score_screen.dart';
import 'package:loannova_mobile_app/screens/user_profile_screen.dart';
import 'package:loannova_mobile_app/screens/ai_assistant/ai_assistant_screen.dart';
import 'package:loannova_mobile_app/screens/profile/referral_screen.dart';
import 'package:loannova_mobile_app/screens/profile/help_support_screen.dart';
import 'package:loannova_mobile_app/screens/profile/profile_screen.dart';

class CustomerDashboardScreen extends StatefulWidget {
  const CustomerDashboardScreen({super.key});

  @override
  State<CustomerDashboardScreen> createState() => _CustomerDashboardScreenState();
}

class _CustomerDashboardScreenState extends State<CustomerDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${appState.userName}'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false, // Prevents back button on home screen
        actions: [
          // 1. Notifications Bell with Live Badge Counter
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

          // 2. Overflow Menu containing all other feature screens
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu),
            tooltip: 'More Options',
            onSelected: (value) {
              Widget destination;
              switch (value) {
                case 'calculators':
                  destination = const CalculatorHubScreen();
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
                default:
                  return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (context) => destination));
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(value: 'calculators', child: ListTile(leading: Icon(Icons.calculate, color: Colors.indigo), title: Text('Calculators Hub'))),
              const PopupMenuItem(value: 'applications', child: ListTile(leading: Icon(Icons.list_alt, color: Colors.indigo), title: Text('My Applications'))),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Credit Score / Overview Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo.shade800, Colors.indigo.shade500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your CIBIL Score',
                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '785 / 900',
                        style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Excellent Financial Health',
                        style: TextStyle(color: Colors.greenAccent.shade200, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const Icon(Icons.speed, color: Colors.white, size: 48),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text('Active Applications Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // Quick summary card of active applications
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSummaryItem('Total Active', '${appState.applications.length}', Colors.indigo),
                    _buildSummaryItem('In Verification', '1', Colors.orange),
                    _buildSummaryItem('Approved', '0', Colors.green),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text('Quick Financial Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // Quick Action Grid with working navigation
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.5,
              children: [
                _buildActionCard(
                  context,
                  Icons.money,
                  'Apply Loan',
                  const ProductCatalogScreen(),
                ),
                _buildActionCard(
                  context,
                  Icons.credit_card,
                  'Credit Cards',
                  const CreditCardMarketplaceScreen(),
                ),
                _buildActionCard(
                  context,
                  Icons.calculate,
                  'Calculators',
                  const CalculatorHubScreen(),
                ),
                _buildActionCard(
                  context,
                  Icons.folder_shared,
                  'KYC Vault',
                  const KycUploadScreen(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context, IconData icon, String title, Widget destinationScreen) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destinationScreen),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.indigo, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}