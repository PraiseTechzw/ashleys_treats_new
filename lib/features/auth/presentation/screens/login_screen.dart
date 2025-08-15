import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/auth_provider.dart';
import '../../../../core/widgets/custom_toast.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _hasCheckedSession = false;

  @override
  void initState() {
    super.initState();
    _checkExistingSession();
  }

  Future<void> _checkExistingSession() async {
    // Wait a bit for the auth provider to initialize
    await Future.delayed(const Duration(milliseconds: 300));

    if (mounted) {
      final authState = ref.read(authProvider);

      // If user is already authenticated, redirect to home
      if (authState.isAuthenticated && authState.user != null) {
        print('LoginScreen: User already authenticated, redirecting to home');
        _redirectToHome();
        return;
      }

      // If auth provider hasn't checked session yet, wait for it
      if (!authState.hasCheckedSession) {
        print('LoginScreen: Waiting for auth provider to check session...');
        await ref.read(authProvider.notifier).refreshAuthStatus();

        // Check again after refresh
        final refreshedAuthState = ref.read(authProvider);
        if (refreshedAuthState.isAuthenticated &&
            refreshedAuthState.user != null) {
          print(
            'LoginScreen: Session found after refresh, redirecting to home',
          );
          _redirectToHome();
          return;
        }
      }

      setState(() {
        _hasCheckedSession = true;
      });
    }
  }

  void _redirectToHome() {
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/auth');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final success = await ref
          .read(authProvider.notifier)
          .login(_emailController.text.trim(), _passwordController.text);

      if (success && mounted) {
        Navigator.pushReplacementNamed(context, '/auth');
      } else if (mounted) {
        ToastManager.showError(
          context,
          ref.read(authProvider).error ?? 'Login failed',
        );
      }
    } catch (e) {
      if (mounted) {
        ToastManager.showError(context, 'An error occurred: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // Show loading while checking session
    if (!_hasCheckedSession || authState.isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/animations/loading.json',
                width: 80,
                height: 80,
                repeat: true,
                animate: true,
              ),
              const SizedBox(height: 16),
              Text(
                'Checking session...',
                style: AppTheme.elegantBodyStyle.copyWith(
                  fontSize: 16,
                  color: AppColors.secondary.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // If user is authenticated, show loading while redirecting
    if (authState.isAuthenticated && authState.user != null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/animations/loading.json',
                width: 80,
                height: 80,
                repeat: true,
                animate: true,
              ),
              const SizedBox(height: 16),
              Text(
                'Redirecting to home...',
                style: AppTheme.elegantBodyStyle.copyWith(
                  fontSize: 16,
                  color: AppColors.secondary.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),

                // Logo and Welcome
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Lottie.asset(
                          'assets/animations/cupcakeani.json',
                          fit: BoxFit.contain,
                          repeat: true,
                          animate: true,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Welcome Back!',
                        style: AppTheme.authTitleStyle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign in to continue your sweet journey',
                        style: AppTheme.authSubtitleStyle,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 48),

                // Email Field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 32),

                // Login Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.onPrimary,
                            ),
                          ),
                        )
                      : const Text('Sign In'),
                ),

                const SizedBox(height: 24),

                // Register Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account? ',
                      style: AppTheme.authSubtitleStyle,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: Text('Sign Up', style: AppTheme.linkTextStyle),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Forgot Password
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/forgot_password');
                    },
                    child: Text(
                      'Forgot Password?',
                      style: AppTheme.linkTextStyle.copyWith(
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
