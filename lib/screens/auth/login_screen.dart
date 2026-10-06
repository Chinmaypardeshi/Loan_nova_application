import 'package:flutter/material.dart';
import 'package:loannova_mobile_app/screens/marketplace/product_catalog_screen.dart';

// Import portal placeholders for other user types
import 'package:loannova_mobile_app/screens/portals/partner_portal_screen.dart';
import 'package:loannova_mobile_app/screens/portals/sales_crm_screen.dart';
import 'package:loannova_mobile_app/screens/portals/rm_dashboard_screen.dart';
import 'package:loannova_mobile_app/screens/portals/operations_screen.dart';
import 'package:loannova_mobile_app/screens/portals/admin_portal_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Default selected user type for testing role-based routing
  String _selectedRole = 'Customer';
  final List<String> _roles = [
    'Customer',
    'Financial Partner',
    'Sales Agent',
    'Relationship Manager',
    'Internal Operations',
    'Super Administrator',
  ];

  void _handleLogin() {
    Widget targetScreen;

    switch (_selectedRole) {
      case 'Financial Partner':
        targetScreen = const PartnerPortalScreen();
        break;
      case 'Sales Agent':
        targetScreen = const SalesCrmScreen();
        break;
      case 'Relationship Manager':
        targetScreen = const RmDashboardScreen();
        break;
      case 'Internal Operations':
        targetScreen = const OperationsScreen();
        break;
      case 'Super Administrator':
        targetScreen = const AdminPortalScreen();
        break;
      case 'Customer':
      default:
        targetScreen = const ProductCatalogScreen();
        break;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => targetScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LoanNova Authentication'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Welcome Back', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Select your user portal type to test role-based routing.', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),

            // Role Selector Dropdown
            const Text('Select User Role / Persona', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedRole,
                  items: _roles.map((String role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRole = newValue!;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email Address / Username',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _handleLogin,
                child: Text('Login as $_selectedRole', style: const TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}