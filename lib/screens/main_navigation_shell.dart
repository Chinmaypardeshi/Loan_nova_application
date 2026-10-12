import 'package:flutter/material.dart';
import 'package:loannova_mobile_app/screens/dashboards/customer_dashboard_screen.dart';
import 'package:loannova_mobile_app/screens/marketplace/product_catalog_screen.dart';
import 'package:loannova_mobile_app/screens/calculators/calculator_hub_screen.dart';
import 'package:loannova_mobile_app/screens/application_tracking_screen.dart';

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const CustomerDashboardScreen(),
    const ProductCatalogScreen(),
    const CalculatorHubScreen(),
    const ApplicationTrackingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // PopScope prevents the physical back button from closing the app or logging out accidentally
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        // If user presses back on a tab other than Dashboard, switch back to Dashboard first
        if (_currentIndex != 0) {
          setState(() => _currentIndex = 0);
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _tabs,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.indigo,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.storefront),
              label: 'Marketplace',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calculate),
              label: 'Calculators',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.track_changes),
              label: 'Tracking',
            ),
          ],
        ),
      ),
    );
  }
}