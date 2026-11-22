import 'package:flutter/material.dart';

import '../api/api_service.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState
    extends State<PersonalInformationScreen> {
  String name = '';
  String email = '';
  String phone = '';
  String role = '';

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUserInformation();
  }

  Future<void> _loadUserInformation() async {
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

      final data = await ApiService.getUserById(userId);

      if (!mounted) return;

      setState(() {
        name = (data['name'] ?? '').toString();
        email = (data['email'] ?? '').toString();
        phone = (data['phone'] ?? '').toString();
        role = (data['role'] ?? 'USER').toString();

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

  String _displayValue(String value) {
    if (value.trim().isEmpty) {
      return 'Not provided';
    }

    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Personal Information',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadUserInformation,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 10),

            // Profile Avatar
            const CircleAvatar(
              radius: 48,
              backgroundColor: Color(0xFFEAF0FF),
              child: Icon(
                Icons.person,
                size: 52,
                color: Color(0xFF3157E8),
              ),
            ),

            const SizedBox(height: 16),

            // Loading
            if (isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: CircularProgressIndicator(),
                ),
              ),

            // Error
            if (!isLoading && errorMessage != null)
              Center(
                child: Column(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Unable to load your information',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _loadUserInformation,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),

            // User Information
            if (!isLoading && errorMessage == null) ...[
              _infoCard(
                icon: Icons.person_outline,
                title: 'Full Name',
                value: _displayValue(name),
              ),

              _infoCard(
                icon: Icons.email_outlined,
                title: 'Email Address',
                value: _displayValue(email),
              ),

              _infoCard(
                icon: Icons.phone_outlined,
                title: 'Phone Number',
                value: _displayValue(phone),
              ),

              _infoCard(
                icon: Icons.badge_outlined,
                title: 'Account Type',
                value: role.toUpperCase(),
              ),

              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F8FC),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Color(0xFF3157E8),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your personal information is fetched securely from your LoanNova account.',
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6,
        ),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF0FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF3157E8),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}