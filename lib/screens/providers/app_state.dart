import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoanApplication {
  final dynamic id;
  final String productName;
  final String category;
  final String status;
  final String date;
  final double? requestedAmount;
  final int? tenureMonths;
  final String applicantName;

  LoanApplication({
    required this.id,
    required this.productName,
    required this.category,
    required this.status,
    required this.date,
    this.requestedAmount,
    this.tenureMonths,
    required this.applicantName,
  });

  factory LoanApplication.fromMap(Map<String, dynamic> map) {
    final rawName = map['product_name'] ?? '';
    final rawCategory = map['category'] ?? 'General';

    // Safely extract full_name from the joined profiles table relation
    String name = 'Customer';
    if (map['profiles'] != null) {
      if (map['profiles'] is Map) {
        name = map['profiles']['full_name'] ?? 'Customer';
      } else if (map['profiles'] is List && (map['profiles'] as List).isNotEmpty) {
        name = map['profiles'][0]['full_name'] ?? 'Customer';
      }
    }

    return LoanApplication(
      id: map['id'],
      productName: rawName.toString().trim().isEmpty ? '$rawCategory Application' : rawName,
      category: rawCategory,
      status: map['status'] ?? 'Submitted',
      date: map['created_at'] != null ? map['created_at'].toString().substring(0, 10) : '',
      requestedAmount: map['requested_amount'] != null ? double.tryParse(map['requested_amount'].toString()) : null,
      tenureMonths: map['tenure_months'] != null ? int.tryParse(map['tenure_months'].toString()) : null,
      applicantName: name,
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

  /// Automatically check for an existing Supabase session on app startup
  Future<void> checkInitialSession() async {
    _isLoading = true;
    notifyListeners();

    try {
      final session = supabase.auth.currentSession;
      if (session != null) {
        _isLoggedIn = true;
        _userEmail = session.user.email ?? '';

        // Fetch user profile role and name from public.profiles table
        try {
          final profile = await supabase
              .from('profiles')
              .select('full_name, role')
              .eq('id', session.user.id)
              .single();

          _userName = profile['full_name'] ?? 'Chinmay Pardeshi';
          _currentUserRole = profile['role'] ?? 'Customer';
        } catch (_) {
          _userName = session.user.email?.split('@')[0] ?? 'User';
        }

        await fetchApplications();
      }
    } catch (e) {
      debugPrint('Error checking initial session: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update application status and assign staff ID in Supabase
  Future<void> updateApplicationStatus(dynamic applicationId, String newStatus) async {
    try {
      final staffId = supabase.auth.currentUser?.id;

      await supabase.from('applications').update({
        'status': newStatus,
        'assigned_staff_id': staffId, // Tracks which staff member processed this
      }).eq('id', applicationId);

      debugPrint('SUCCESS: Application $applicationId updated to $newStatus');
      await fetchApplications(); // Refresh the pipeline queue instantly
    } catch (e) {
      debugPrint('Error updating application status in Supabase: $e');
    }
  }

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
    notifyListeners();
  }

  // Fetch live applications scoped by user role with profile join
  Future<void> fetchApplications() async {
    _isLoading = true;
    notifyListeners();

    try {
      final userId = supabase.auth.currentUser?.id;
      var query = supabase.from('applications').select('*, profiles(full_name)');

      if (_currentUserRole == 'Customer' && userId != null) {
        query = supabase.from('applications').select('*, profiles(full_name)').eq('user_id', userId);
      } else {
        query = supabase.from('applications').select('*, profiles(full_name)');
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

  // Insert new application into Supabase without needing extra table columns
  Future<void> addApplication({
    required String productName,
    required String category,
    double? requestedAmount,
    int? tenureMonths,
  }) async {
    try {
      final userId = supabase.auth.currentUser?.id;

      await supabase.from('applications').insert({
        'user_id': userId,
        'product_name': productName,
        'category': category,
        'status': 'Submitted',
        'requested_amount': requestedAmount,
        'tenure_months': tenureMonths,
      });

      debugPrint('SUCCESS: Applied for "$productName" ($category)');
      await fetchApplications();
    } catch (e) {
      debugPrint('Error inserting application to Supabase: $e');
    }
  }
}