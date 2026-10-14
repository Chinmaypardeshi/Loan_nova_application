import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoanApplication {
  final dynamic id;
  final String productName;
  final String category;
  final String status;
  final String date;

  LoanApplication({
    required this.id,
    required this.productName,
    required this.category,
    required this.status,
    required this.date,
  });

  factory LoanApplication.fromMap(Map<String, dynamic> map) {
    final rawName = map['product_name'] ?? '';
    final rawCategory = map['category'] ?? 'General';

    return LoanApplication(
      id: map['id'],
      // Fallback to category if product_name is empty/null
      productName: rawName.toString().trim().isEmpty ? '$rawCategory Application' : rawName,
      category: rawCategory,
      status: map['status'] ?? 'Pending',
      date: map['created_at'] != null ? map['created_at'].toString().substring(0, 10) : '',
    );
  }
}

class AppState extends ChangeNotifier {
  final supabase = Supabase.instance.client;

  String _currentUserRole = 'Customer';
  String _userName = 'Chinmay Pardeshi';
  String _userEmail = 'chinmay@loannova.com';
  bool _isLoggedIn = false;

  List<LoanApplication> _applications = [];
  bool _isLoading = false;

  // Getters
  String get currentUserRole => _currentUserRole;
  String get userName => _userName;
  String get userEmail => _userEmail;
  bool get isLoggedIn => _isLoggedIn;
  List<LoanApplication> get applications => _applications;
  bool get isLoading => _isLoading;

  // Actions
  void setRole(String role) {
    _currentUserRole = role;
    notifyListeners();
    fetchApplications(); // Re-fetch data when role changes
  }

  void login(String name, String email, String role) {
    _userName = name;
    _userEmail = email;
    _currentUserRole = role;
    _isLoggedIn = true;
    notifyListeners();
    fetchApplications(); // Fetch cloud applications based on role on login
  }

  void logout() {
    _isLoggedIn = false;
    _userName = '';
    _userEmail = '';
    _currentUserRole = 'Customer';
    _applications = [];
    notifyListeners(); // This triggers the root widget to rebuild and show login
  }

  // Fetch live applications scoped by user role
  Future<void> fetchApplications() async {
    _isLoading = true;
    notifyListeners();

    try {
      final userId = supabase.auth.currentUser?.id;
      var query = supabase.from('applications').select();

      // Role-based data scoping
      if (_currentUserRole == 'Customer' && userId != null) {
        // Customers see ONLY their own applications
        query = supabase.from('applications').select().eq('user_id', userId);
      } else {
        // Staff, Partners, Operations, and Admins see the full enterprise pipeline queue
        query = supabase.from('applications').select();
      }

      final response = await query;
      _applications = List<Map<String, dynamic>>.from(response)
          .map((map) => LoanApplication.fromMap(map))
          .toList();
    } catch (e) {
      debugPrint('Error fetching role-scoped applications from Supabase: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Insert new application directly into Supabase cloud database
  Future<void> addApplication({required String productName, required String category}) async {
    try {
      final userId = supabase.auth.currentUser?.id;

      await supabase.from('applications').insert({
        'user_id': userId, // Links to authenticated user table
        'product_name': productName,
        'category': category,
        'status': 'Submitted',
      });

      // Refresh the local state list from the cloud database
      await fetchApplications();
    } catch (e) {
      debugPrint('Error inserting application to Supabase: $e');
    }
  }
}