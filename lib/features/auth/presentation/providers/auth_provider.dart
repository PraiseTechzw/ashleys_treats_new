import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository_impl.dart';

// Auth State
class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final UserModel? user;
  final String? error;
  final bool hasCheckedSession;

  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.user,
    this.error,
    this.hasCheckedSession = false,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    UserModel? user,
    String? error,
    bool? hasCheckedSession,
    bool clearError = false,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: clearError ? null : (error ?? this.error),
      hasCheckedSession: hasCheckedSession ?? this.hasCheckedSession,
    );
  }
}

// Auth Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepositoryImpl _authRepository;

  AuthNotifier(this._authRepository) : super(const AuthState()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      state = state.copyWith(isLoading: true);
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      final userEmail = prefs.getString('userEmail');
      final userRole = prefs.getString('userRole');
      final userName = prefs.getString('userName');
      final userPhone = prefs.getString('userPhone');

      if (userId != null && userEmail != null && userEmail.isNotEmpty) {
        // Validate that we have the minimum required data
        final user = UserModel(
          userId: userId,
          email: userEmail,
          role: userRole ?? 'customer',
          displayName: userName ?? '',
          phoneNumber: userPhone ?? '',
          addresses: [],
          preferences: {},
          createdAt: DateTime.now(),
          lastActive: DateTime.now(),
        );

        state = state.copyWith(
          isAuthenticated: true,
          user: user,
          isLoading: false,
          hasCheckedSession: true,
        );

        print('Auth: Session restored for user: ${user.email} (${user.role})');
      } else {
        state = state.copyWith(
          isAuthenticated: false,
          user: null,
          isLoading: false,
          hasCheckedSession: true,
        );
        print('Auth: No valid session found');
      }
    } catch (e) {
      print('Auth: Error checking auth status: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to check authentication status',
        hasCheckedSession: true,
      );
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final user = await _authRepository.login(
        email: email,
        password: password,
      );

      if (user != null) {
        // Save user data to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', user.userId);
        await prefs.setString('userEmail', user.email);
        await prefs.setString('userRole', user.role);
        await prefs.setString('userName', user.displayName);
        await prefs.setString('userPhone', user.phoneNumber);

        state = state.copyWith(
          isAuthenticated: true,
          user: user as UserModel,
          isLoading: false,
        );

        print('Auth: User logged in successfully: ${user.email}');
        return true;
      } else {
        state = state.copyWith(isLoading: false, error: 'Invalid credentials');
        return false;
      }
    } catch (e) {
      print('Auth: Login error: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Login failed: ${e.toString()}',
      );
      return false;
    }
  }

  Future<bool> register(
    String email,
    String password,
    String name,
    String phone,
  ) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final user = await _authRepository.register(
        email: email,
        password: password,
        displayName: name,
        phoneNumber: phone,
      );

      if (user != null) {
        // Save user data to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', user.userId);
        await prefs.setString('userEmail', user.email);
        await prefs.setString('userRole', user.role);
        await prefs.setString('userName', user.displayName);
        await prefs.setString('userPhone', user.phoneNumber);

        state = state.copyWith(
          isAuthenticated: true,
          user: user as UserModel,
          isLoading: false,
        );

        print('Auth: User registered successfully: ${user.email}');
        return true;
      } else {
        state = state.copyWith(isLoading: false, error: 'Registration failed');
        return false;
      }
    } catch (e) {
      print('Auth: Registration error: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Registration failed: ${e.toString()}',
      );
      return false;
    }
  }

  Future<void> logout() async {
    try {
      state = state.copyWith(isLoading: true);

      // Clear user data from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('userId');
      await prefs.remove('userEmail');
      await prefs.remove('userRole');
      await prefs.remove('userName');
      await prefs.remove('userPhone');

      state = state.copyWith(
        isAuthenticated: false,
        user: null,
        isLoading: false,
        error: null,
      );

      print('Auth: User logged out successfully');
    } catch (e) {
      print('Auth: Logout error: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Logout failed: ${e.toString()}',
      );
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  Future<bool> forgotPassword(String email) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      await _authRepository.forgotPassword(email: email);

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      print('Auth: Forgot password error: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to send password reset email: ${e.toString()}',
      );
      return false;
    }
  }

  // Check if user has a valid session stored
  Future<bool> hasValidSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      final userEmail = prefs.getString('userEmail');

      return userId != null && userEmail != null && userEmail.isNotEmpty;
    } catch (e) {
      print('Auth: Error checking session validity: $e');
      return false;
    }
  }

  // Refresh auth status (useful for app resume)
  Future<void> refreshAuthStatus() async {
    if (!state.hasCheckedSession) {
      await _checkAuthStatus();
    }
  }

  bool get isAdmin => state.user?.role == 'admin';
  bool get isCustomer => state.user?.role == 'customer';
  bool get hasCheckedSession => state.hasCheckedSession;
}

// Providers
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRepositoryImpl();
  return AuthNotifier(authRepository);
});

final authNotifierProvider = Provider<AuthNotifier>((ref) {
  return ref.read(authProvider.notifier);
});
