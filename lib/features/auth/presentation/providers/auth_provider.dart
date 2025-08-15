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

  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.user,
    this.error,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    UserModel? user,
    String? error,
    bool clearError = false,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: clearError ? null : (error ?? this.error),
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

      if (userId != null && userEmail != null) {
        final user = UserModel(
          userId: userId,
          email: userEmail,
          role: userRole ?? 'customer',
          displayName: prefs.getString('userName') ?? '',
          phoneNumber: prefs.getString('userPhone') ?? '',
          addresses: [],
          preferences: {},
          createdAt: DateTime.now(),
          lastActive: DateTime.now(),
        );
        state = state.copyWith(
          isAuthenticated: true,
          user: user,
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to check authentication status',
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
        return true;
      } else {
        state = state.copyWith(isLoading: false, error: 'Invalid credentials');
        return false;
      }
    } catch (e) {
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
        return true;
      } else {
        state = state.copyWith(isLoading: false, error: 'Registration failed');
        return false;
      }
    } catch (e) {
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
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Logout failed: ${e.toString()}',
      );
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  bool get isAdmin => state.user?.role == 'admin';
  bool get isCustomer => state.user?.role == 'customer';
}

// Providers
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRepositoryImpl();
  return AuthNotifier(authRepository);
});

final authNotifierProvider = Provider<AuthNotifier>((ref) {
  return ref.read(authProvider.notifier);
});
