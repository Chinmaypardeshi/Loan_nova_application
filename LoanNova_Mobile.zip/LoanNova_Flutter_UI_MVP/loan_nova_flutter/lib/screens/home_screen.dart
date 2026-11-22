import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../api/api_service.dart';
import '../models/loan.dart';
import '../widgets/loan_card.dart';
import 'ai_screen.dart';
import 'category_screen.dart';
import 'credit_screen.dart';
import 'eligibility_screen.dart';
import 'emi_screen.dart';
import 'notifications_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  List<Loan> userLoans = [];

  String userName = 'User';
  int creditScore = 782;

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat();

    _loadHomeData();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future<void> _loadHomeData() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final userId = await ApiService.getUserId();

      if (userId == null) {
        throw Exception(
          'User session not found. Please login again',
        );
      }

      final userData = await ApiService.getUserById(userId);

      final loanData = await ApiService.getUserLoans(userId);

      final loadedLoans = loanData
          .map(
            (item) => Loan.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();

      if (!mounted) return;

      setState(() {
        userName = (userData['name'] ?? 'User').toString();

        creditScore =
            (userData['creditScore'] as num?)?.toInt() ?? 782;

        userLoans = loadedLoans;

        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  void goTo(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => page,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadHomeData,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverToBoxAdapter(
            child: _topBar(),
          ),
          SliverToBoxAdapter(
            child: _hero(),
          ),
          SliverToBoxAdapter(
            child: _search(),
          ),
          SliverToBoxAdapter(
            child: _sectionTitle(
              'Explore financial products',
              'View all',
              () {
                goTo(
                  const CategoryScreen(
                    title: 'All Products',
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: _categories(),
          ),
          SliverToBoxAdapter(
            child: _sectionTitle(
              'Your loans',
              'See all',
              () {
                goTo(
                  RecommendedLoansScreen(
                    loans: userLoans,
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: _loanSection(),
          ),
          SliverToBoxAdapter(
            child: _creditScore(),
          ),
          SliverToBoxAdapter(
            child: _quickTools(),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 30),
          ),
        ],
      ),
    );
  }

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        16,
        20,
        10,
      ),
      child: Row(
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF3157E8),
                  Color(0xFF6D5DF5),
                ],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'Good day 👋',
                  style: TextStyle(
                    color: Color(0xFF737A8C),
                    fontSize: 13,
                  ),
                ),
                Text(
                  isLoading ? 'Loading...' : userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              goTo(
                const NotificationsScreen(),
              );
            },
            icon: const Icon(
              Icons.notifications_none_rounded,
            ),
          ),
        ],
      ),
    );
  }

  Widget _hero() {
    return AnimatedBuilder(
      animation: animationController,
      builder: (_, __) {
        final t =
            animationController.value * 2 * math.pi;

        return Container(
          margin: const EdgeInsets.fromLTRB(
            16,
            8,
            16,
            16,
          ),
          height: 224,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF172B78),
                Color(0xFF3157E8),
                Color(0xFF7058E8),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -30 + math.sin(t) * 10,
                top: -50,
                child: _circle(150),
              ),
              Positioned(
                left: -70 + math.cos(t) * 8,
                bottom: -80,
                child: _circle(170),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  24,
                  24,
                  20,
                  20,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color:
                            Colors.white.withOpacity(0.13),
                        borderRadius:
                            BorderRadius.circular(30),
                      ),
                      child: const Text(
                        '✦ SMART FINANCE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Find the right\nfinancial solution.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        height: 1.08,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Compare. Choose. Apply. All in one place.',
                      style: TextStyle(
                        color: Color(0xFFDCE4FF),
                        fontSize: 13,
                      ),
                    ),
                    const Spacer(),
                    FilledButton(
                      onPressed: () {
                        goTo(
                          const CategoryScreen(
                            title: 'Loans',
                          ),
                        );
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor:
                            const Color(0xFF3157E8),
                      ),
                      child: const Text(
                        'Explore loans →',
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 20,
                bottom: 20,
                child: Transform.rotate(
                  angle: math.sin(t) * 0.08,
                  child: Container(
                    height: 78,
                    width: 78,
                    decoration: BoxDecoration(
                      color:
                          Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.account_balance,
                      size: 38,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _circle(double size) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _search() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        0,
        20,
        18,
      ),
      child: InkWell(
        onTap: () {
          showSearch(
            context: context,
            delegate: LoanSearchDelegate(),
          );
        },
        child: Container(
          height: 56,
          padding:
              const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFE8EAF1),
            ),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.search_rounded,
                color: Color(0xFF7A8091),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Search loans, cards, insurance...',
                  style: TextStyle(
                    color: Color(0xFF9297A7),
                  ),
                ),
              ),
              Icon(
                Icons.mic_none_rounded,
                color: Color(0xFF3157E8),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(
    String title,
    String action,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        4,
        20,
        12,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          TextButton(
            onPressed: onTap,
            child: Text(action),
          ),
        ],
      ),
    );
  }

  Widget _categories() {
    final categories = [
      (
        'Personal',
        Icons.person_outline,
        const Color(0xFF3157E8),
      ),
      (
        'Home',
        Icons.home_outlined,
        const Color(0xFF8B5CF6),
      ),
      (
        'Business',
        Icons.business_center_outlined,
        const Color(0xFF0F9D78),
      ),
      (
        'Vehicle',
        Icons.directions_car_outlined,
        const Color(0xFFF59E0B),
      ),
      (
        'Education',
        Icons.school_outlined,
        const Color(0xFFEF476F),
      ),
    ];

    return SizedBox(
      height: 105,
      child: ListView.separated(
        padding:
            const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) {
          return const SizedBox(width: 12);
        },
        itemBuilder: (_, index) {
          final category = categories[index];

          return InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              goTo(
                CategoryScreen(
                  title: category.$1,
                ),
              );
            },
            child: SizedBox(
              width: 76,
              child: Column(
                children: [
                  Container(
                    height: 62,
                    width: 62,
                    decoration: BoxDecoration(
                      color:
                          category.$3.withOpacity(0.1),
                      borderRadius:
                          BorderRadius.circular(20),
                    ),
                    child: Icon(
                      category.$2,
                      color: category.$3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category.$1,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
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

  Widget _loanSection() {
    if (isLoading) {
      return const Padding(
        padding:
            EdgeInsets.symmetric(horizontal: 20),
        child: Card(
          elevation: 0,
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      );
    }

    if (errorMessage != null) {
      return Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 20),
        child: Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 42,
                  color: Colors.red,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Unable to load your loans',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                TextButton(
                  onPressed: _loadHomeData,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (userLoans.isEmpty) {
      return Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 20),
        child: Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Icon(
                  Icons.account_balance_outlined,
                  size: 42,
                  color: Color(0xFF3157E8),
                ),
                const SizedBox(height: 8),
                const Text(
                  'No loans found',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Your active loans will appear here.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 20),
      child: LoanCard(
        loan: userLoans.first,
      ),
    );
  }

  Widget _creditScore() {
    final double progress =
        ((creditScore - 300) / (900 - 300))
            .clamp(0.0, 1.0);

    return InkWell(
      onTap: () {
        goTo(const CreditScreen());
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(
          20,
          2,
          20,
          18,
        ),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF111B3A),
              Color(0xFF263A7A),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            SizedBox(
              height: 82,
              width: 82,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 8,
                    backgroundColor:
                        const Color(0x332E3D70),
                    valueColor:
                        const AlwaysStoppedAnimation(
                      Color(0xFF62E6B2),
                    ),
                  ),
                  Text(
                    creditScore.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Credit Score',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    _creditScoreLabel(),
                    style: const TextStyle(
                      color: Color(0xFFBFC8E8),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'View detailed credit report →',
                    style: TextStyle(
                      color: Color(0xFF7FE8BF),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _creditScoreLabel() {
    if (creditScore >= 750) {
      return 'Excellent • Updated monthly';
    }

    if (creditScore >= 700) {
      return 'Good • Updated monthly';
    }

    if (creditScore >= 650) {
      return 'Fair • Updated monthly';
    }

    return 'Needs improvement • Updated monthly';
  }

  Widget _quickTools() {
    final tools = [
      (
        'EMI Calculator',
        Icons.calculate_outlined,
        const EmiScreen(),
      ),
      (
        'Eligibility',
        Icons.verified_user_outlined,
        const EligibilityScreen(),
      ),
      (
        'AI Assistant',
        Icons.auto_awesome_outlined,
        const AiScreen(),
      ),
      (
        'Insurance',
        Icons.shield_outlined,
        const CategoryScreen(
          title: 'Insurance',
        ),
      ),
    ];

    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick tools',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics:
                const NeverScrollableScrollPhysics(),
            itemCount: tools.length,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.25,
            ),
            itemBuilder: (_, index) {
              return InkWell(
                borderRadius:
                    BorderRadius.circular(18),
                onTap: () {
                  goTo(tools[index].$3);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(18),
                    border: Border.all(
                      color:
                          const Color(0xFFE9EBF2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        tools[index].$2,
                        color:
                            const Color(0xFF3157E8),
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Text(
                          tools[index].$1,
                          style:
                              const TextStyle(
                            fontSize: 12,
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class LoanSearchDelegate
    extends SearchDelegate<String> {
  final List<String> options = [
    'Personal Loan',
    'Home Loan',
    'Business Loan',
    'Vehicle Loan',
    'Education Loan',
    'Gold Loan',
    'Insurance',
  ];

  @override
  List<Widget>? buildActions(
    BuildContext context,
  ) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(
    BuildContext context,
  ) {
    return IconButton(
      onPressed: () {
        close(context, '');
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(
    BuildContext context,
  ) {
    return _results(context);
  }

  @override
  Widget buildSuggestions(
    BuildContext context,
  ) {
    return _results(context);
  }

  Widget _results(BuildContext context) {
    final filtered = options
        .where(
          (item) => item
              .toLowerCase()
              .contains(
                query.toLowerCase(),
              ),
        )
        .toList();

    return ListView(
      children: filtered
          .map(
            (item) => ListTile(
              leading: const Icon(
                Icons.account_balance_wallet_outlined,
              ),
              title: Text(item),
              onTap: () {
                close(context, item);
              },
            ),
          )
          .toList(),
    );
  }
}

class RecommendedLoansScreen
    extends StatelessWidget {
  final List<Loan> loans;

  const RecommendedLoansScreen({
    super.key,
    required this.loans,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Loans',
        ),
      ),
      body: loans.isEmpty
          ? const Center(
              child: Text(
                'No loans found',
              ),
            )
          : ListView.builder(
              padding:
                  const EdgeInsets.only(
                top: 15,
                bottom: 20,
              ),
              itemCount: loans.length,
              itemBuilder: (_, index) {
                return LoanCard(
                  loan: loans[index],
                );
              },
            ),
    );
  }
}