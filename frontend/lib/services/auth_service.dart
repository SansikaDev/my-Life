import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';

class AuthService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  
  // Dummy users for testing
  static const Map<String, Map<String, dynamic>> _dummyUsers = {
    'john@example.com': {
      'password': 'password123',
      'name': 'John Doe',
      'height': 175.0,
      'weight': 70.0,
      'fitnessGoal': 'Weight Loss',
      'activityLevel': 'Moderately Active',
      'interests': ['Running', 'Strength Training', 'Yoga'],
    },
    'sarah@example.com': {
      'password': 'password123',
      'name': 'Sarah Wilson',
      'height': 165.0,
      'weight': 55.0,
      'fitnessGoal': 'Muscle Gain',
      'activityLevel': 'Very Active',
      'interests': ['Strength Training', 'HIIT', 'Swimming'],
    },
    'mike@example.com': {
      'password': 'password123',
      'name': 'Mike Johnson',
      'height': 180.0,
      'weight': 80.0,
      'fitnessGoal': 'Maintenance',
      'activityLevel': 'Lightly Active',
      'interests': ['Cycling', 'Yoga', 'Hiking'],
    },
  };

  // Current user
  static UserModel? _currentUser;

  // Get current user
  static UserModel? get currentUser => _currentUser;

  // Check if user is logged in
  static bool get isLoggedIn => _currentUser != null;

  // Login with email and password
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Check if user exists
      if (!_dummyUsers.containsKey(email)) {
        return {
          'success': false,
          'message': 'User not found. Please check your email.',
        };
      }

      final userData = _dummyUsers[email]!;
      
      // Check password
      if (userData['password'] != password) {
        return {
          'success': false,
          'message': 'Invalid password. Please try again.',
        };
      }

      // Create user model
      _currentUser = UserModel(
        id: email.hashCode.toString(),
        email: email,
        name: userData['name'],
        height: userData['height'],
        weight: userData['weight'],
        fitnessGoal: userData['fitnessGoal'],
        activityLevel: userData['activityLevel'],
        interests: List<String>.from(userData['interests']),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Save user data to secure storage
      await _saveUserToStorage(_currentUser!);

      return {
        'success': true,
        'message': 'Login successful!',
        'user': _currentUser,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred. Please try again.',
      };
    }
  }

  // Register new user
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    String? gender,
    String? fitnessGoal,
    String? activityLevel,
    List<String>? interests,
  }) async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Check if user already exists
      if (_dummyUsers.containsKey(email)) {
        return {
          'success': false,
          'message': 'User with this email already exists.',
        };
      }

      // Create new user
      _currentUser = UserModel(
        id: email.hashCode.toString(),
        email: email,
        name: name,
        gender: gender,
        fitnessGoal: fitnessGoal,
        activityLevel: activityLevel,
        interests: interests ?? [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Save user data to secure storage
      await _saveUserToStorage(_currentUser!);

      return {
        'success': true,
        'message': 'Registration successful!',
        'user': _currentUser,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred. Please try again.',
      };
    }
  }

  // Logout
  static Future<void> logout() async {
    _currentUser = null;
    await _storage.delete(key: 'user_data');
  }

  // Check if user is logged in on app start
  static Future<bool> checkLoginStatus() async {
    try {
      final userData = await _storage.read(key: 'user_data');
      if (userData != null) {
        final userMap = json.decode(userData);
        _currentUser = UserModel.fromJson(userMap);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Save user to secure storage
  static Future<void> _saveUserToStorage(UserModel user) async {
    final userData = json.encode(user.toJson());
    await _storage.write(key: 'user_data', value: userData);
  }

  // Update user profile
  static Future<Map<String, dynamic>> updateProfile({
    String? name,
    double? height,
    double? weight,
    String? fitnessGoal,
    String? activityLevel,
    List<String>? interests,
  }) async {
    try {
      if (_currentUser == null) {
        return {
          'success': false,
          'message': 'No user logged in.',
        };
      }

      // Update user data
      _currentUser = _currentUser!.copyWith(
        name: name,
        height: height,
        weight: weight,
        fitnessGoal: fitnessGoal,
        activityLevel: activityLevel,
        interests: interests,
        updatedAt: DateTime.now(),
      );

      // Save updated data
      await _saveUserToStorage(_currentUser!);

      return {
        'success': true,
        'message': 'Profile updated successfully!',
        'user': _currentUser,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred. Please try again.',
      };
    }
  }

  // Get dummy login credentials for testing
  static List<Map<String, String>> get testCredentials => [
    {'email': 'john@example.com', 'password': 'password123', 'name': 'John Doe'},
    {'email': 'sarah@example.com', 'password': 'password123', 'name': 'Sarah Wilson'},
    {'email': 'mike@example.com', 'password': 'password123', 'name': 'Mike Johnson'},
  ];
} 