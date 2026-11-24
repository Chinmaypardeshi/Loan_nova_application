import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // 🔧 UPDATE after deploying to Render:
  // Replace with your Render URL e.g. https://loannova-backend.onrender.com/api
  // For local dev (Android emulator): http://10.0.2.2:5000/api
  // For local dev (iOS simulator):    http://localhost:5000/api
  static const String baseUrl = 'http://10.0.2.2:5000/api';

  // =========================
  // LOGIN
  // =========================
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final token = data['token'];

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('token', token);

      // Save userId if backend sends it
      if (data['userId'] != null) {
        await prefs.setInt(
          'userId',
          (data['userId'] as num).toInt(),
        );
      }

      return data;
    }

    throw Exception(
      data['message'] ?? 'Login failed',
    );
  }
    // =========================
  // REGISTER
  // =========================
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return Map<String, dynamic>.from(data);
    }

    throw Exception(
      data is Map
          ? (data['message'] ?? 'Registration failed')
          : 'Registration failed',
    );
  }

  // =========================
  // GET TOKEN
  // =========================
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('token');
  }

  // =========================
  // GET USER ID
  // =========================
  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getInt('userId');
  }

  // =========================
  // LOGOUT
  // =========================
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('token');
    await prefs.remove('userId');
  }

  // =========================
  // AUTH HEADERS
  // =========================
  static Future<Map<String, String>> getAuthHeaders() async {
    final token = await getToken();

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // =========================
  // DASHBOARD
  // =========================
  static Future<Map<String, dynamic>> getDashboard(
    int userId,
  ) async {
    final headers = await getAuthHeaders();

    final response = await http.get(
      Uri.parse('$baseUrl/dashboard/user/$userId'),
      headers: headers,
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(data);
    }

    throw Exception(
      data is Map
          ? (data['message'] ?? 'Failed to load dashboard')
          : 'Failed to load dashboard',
    );
  }

  // =========================
  // GET USER LOANS
  // =========================
  static Future<List<dynamic>> getUserLoans(
    int userId,
  ) async {
    final headers = await getAuthHeaders();

    final response = await http.get(
      Uri.parse('$baseUrl/loans/user/$userId'),
      headers: headers,
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(
      data is Map
          ? (data['message'] ?? 'Failed to load loans')
          : 'Failed to load loans',
    );
  }
    // =========================
  // GET ALL AVAILABLE LOANS
  // =========================
  static Future<List<dynamic>> getAllLoans() async {
    final headers = await getAuthHeaders();

    final response = await http.get(
      Uri.parse('$baseUrl/loans'),
      headers: headers,
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(
      data is Map
          ? (data['message'] ?? 'Failed to load loans')
          : 'Failed to load loans',
    );
  }

  // =========================
  // GET USER APPLICATIONS
  // =========================
  static Future<List<dynamic>> getUserApplications(
    int userId,
  ) async {
    final headers = await getAuthHeaders();

    final response = await http.get(
      Uri.parse('$baseUrl/applications/user/$userId'),
      headers: headers,
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(
      data is Map
          ? (data['message'] ?? 'Failed to load applications')
          : 'Failed to load applications',
    );
  }

  // =========================
  // GET LOAN REPAYMENTS
  // =========================
  static Future<List<dynamic>> getLoanRepayments(
    int loanId,
  ) async {
    final headers = await getAuthHeaders();

    final response = await http.get(
      Uri.parse('$baseUrl/repayments/loan/$loanId'),
      headers: headers,
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(
      data is Map
          ? (data['message'] ?? 'Failed to load repayments')
          : 'Failed to load repayments',
    );
  }

  // =========================
  // GET REPAYMENT SUMMARY
  // =========================
  static Future<Map<String, dynamic>> getRepaymentSummary(
    int loanId,
  ) async {
    final headers = await getAuthHeaders();

    final response = await http.get(
      Uri.parse('$baseUrl/repayments/loan/$loanId/summary'),
      headers: headers,
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(data);
    }

    throw Exception(
      data is Map
          ? (data['message'] ?? 'Failed to load EMI summary')
          : 'Failed to load EMI summary',
    );
  }

  // =========================
  // PAY REPAYMENT
  // =========================
  static Future<Map<String, dynamic>> payRepayment(
    int repaymentId,
    String paymentReference,
  ) async {
    final headers = await getAuthHeaders();

    final uri = Uri.parse(
      '$baseUrl/repayments/$repaymentId/pay',
    ).replace(
      queryParameters: {
        'paymentReference': paymentReference,
      },
    );

    final response = await http.put(
      uri,
      headers: headers,
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(data);
    }

    throw Exception(
      data is Map
          ? (data['message'] ?? 'Payment failed')
          : 'Payment failed',
    );
  }
  static Future<Map<String, dynamic>> getUserById(int userId) async {
  final headers = await getAuthHeaders();

  final response = await http.get(
    Uri.parse('$baseUrl/users/$userId'),
    headers: headers,
  );

  final data = jsonDecode(response.body);

  if (response.statusCode == 200) {
    return Map<String, dynamic>.from(data);
  }

  throw Exception(
    data is Map
        ? (data['message'] ?? 'Failed to load user profile')
        : 'Failed to load user profile',
  );
}
  static Future<List<dynamic>> getUserNotifications(
  int userId,
) async {
  final headers = await getAuthHeaders();

  final response = await http.get(
    Uri.parse('$baseUrl/notifications/user/$userId'),
    headers: headers,
  );

  final data = jsonDecode(response.body);

  if (response.statusCode == 200) {
    return data;
  }

  throw Exception(
    data is Map
        ? (data['message'] ?? 'Failed to load notifications')
        : 'Failed to load notifications',
  );
}

static Future<int> getUnreadNotificationCount(
  int userId,
) async {
  final headers = await getAuthHeaders();

  final response = await http.get(
    Uri.parse(
      '$baseUrl/notifications/user/$userId/unread-count',
    ),
    headers: headers,
  );

  final data = jsonDecode(response.body);

  if (response.statusCode == 200) {
    if (data is num) {
      return data.toInt();
    }

    if (data is Map && data['count'] is num) {
      return (data['count'] as num).toInt();
    }

    return 0;
  }

  throw Exception(
    data is Map
        ? (data['message'] ?? 'Failed to load unread count')
        : 'Failed to load unread count',
  );
}

static Future<Map<String, dynamic>> markNotificationAsRead(
  int notificationId,
) async {
  final headers = await getAuthHeaders();

  final response = await http.put(
    Uri.parse(
      '$baseUrl/notifications/$notificationId/read',
    ),
    headers: headers,
  );

  final data = jsonDecode(response.body);

  if (response.statusCode == 200) {
    return Map<String, dynamic>.from(data);
  }

  throw Exception(
    data is Map
        ? (data['message'] ?? 'Failed to mark notification as read')
        : 'Failed to mark notification as read',
  );
}

static Future<void> markAllNotificationsAsRead(
  int userId,
) async {
  final headers = await getAuthHeaders();

  final response = await http.put(
    Uri.parse(
      '$baseUrl/notifications/user/$userId/read-all',
    ),
    headers: headers,
  );

  if (response.statusCode == 200) {
    return;
  }

  final data = jsonDecode(response.body);

  throw Exception(
    data is Map
        ? (data['message'] ?? 'Failed to mark notifications as read')
        : 'Failed to mark notifications as read',
  );
}
  // =========================
// GENERATE REPAYMENT SCHEDULE
// =========================
static Future<List<dynamic>> generateRepaymentSchedule(
  int loanId,
) async {
  final headers = await getAuthHeaders();

  final response = await http.post(
    Uri.parse('$baseUrl/repayments/loan/$loanId/generate'),
    headers: headers,
  );

  final data = jsonDecode(response.body);

  if (response.statusCode == 200 || response.statusCode == 201) {
    // Backend may return generated list
    if (data is List) {
      return data;
    }

    // If backend returns a message/object,
    // return empty list and fetch schedule separately.
    return [];
  }

  throw Exception(
    data is Map
        ? (data['message'] ?? 'Failed to generate repayment schedule')
        : 'Failed to generate repayment schedule',
  );
}
// =========================
// CREATE LOAN APPLICATION
// =========================
static Future<Map<String, dynamic>> createLoanApplication(
  int userId,
  int loanId,
  double requestedAmount,
  int tenure,
) async {
  final headers = await getAuthHeaders();

  final response = await http.post(
    Uri.parse(
      '$baseUrl/applications/user/$userId/loan/$loanId',
    ),
    headers: headers,
    body: jsonEncode({
      'requestedAmount': requestedAmount,
      'tenure': tenure,
    }),
  );

  final data = jsonDecode(response.body);

  if (response.statusCode == 201) {
    return Map<String, dynamic>.from(data);
  }

  throw Exception(
    data is Map
        ? (data['message'] ?? 'Failed to submit loan application')
        : 'Failed to submit loan application',
  );
}
static Future<void> changePassword(
  int userId,
  String currentPassword,
  String newPassword,
) async {
  final headers = await getAuthHeaders();

  final response = await http.put(
    Uri.parse('$baseUrl/users/$userId/password'),
    headers: headers,
    body: jsonEncode({
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    }),
  );

  final data = jsonDecode(response.body);

  if (response.statusCode == 200) {
    return;
  }

  throw Exception(
    data is Map
        ? (data['message'] ?? 'Failed to change password')
        : 'Failed to change password',
  );
}
}