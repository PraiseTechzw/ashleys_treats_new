import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/auth_provider.dart';
import '../../../../core/widgets/custom_toast.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  String _selectedCountryCode = '+263'; // Zimbabwe country code

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Formats the name to capitalize the first letter of each word
  String _formatName(String name) {
    if (name.isEmpty) return name;

    // Split the name into words and capitalize each word
    final words = name.split(' ');
    final formattedWords = words.map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).toList();

    // Join the words back together
    return formattedWords.join(' ');
  }

  /// Validates phone number length
  bool _isValidPhoneNumber(String phoneNumber) {
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

    // Zimbabwe phone number validation with specific limits
    if (cleanNumber.startsWith('07')) {
      // Zimbabwe mobile numbers: 07XXXXXXXX (9 digits total)
      return cleanNumber.length == 9;
    } else if (cleanNumber.startsWith('7') && cleanNumber.length == 8) {
      // Zimbabwe mobile numbers without leading 0: 7XXXXXXXX (8 digits)
      return true;
    } else if (cleanNumber.startsWith('263') && cleanNumber.length == 11) {
      // International format: 263XXXXXXXXX (11 digits total)
      return true;
    }

    // General validation for other countries
    return cleanNumber.length >= 7 && cleanNumber.length <= 15;
  }

  /// Get specific phone validation error message
  String _getPhoneValidationMessage(String phoneNumber) {
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

    if (cleanNumber.startsWith('07')) {
      if (cleanNumber.length < 9)
        return 'Zimbabwe mobile number must be 9 digits (07XXXXXXXX)';
      if (cleanNumber.length > 9)
        return 'Zimbabwe mobile number must be exactly 9 digits (07XXXXXXXX)';
      return 'Valid Zimbabwe mobile number';
    } else if (cleanNumber.startsWith('7') && cleanNumber.length == 8) {
      return 'Valid Zimbabwe mobile number (7XXXXXXXX)';
    } else if (cleanNumber.startsWith('263') && cleanNumber.length == 11) {
      return 'Valid international Zimbabwe number (263XXXXXXXXX)';
    } else if (cleanNumber.startsWith('7') || cleanNumber.startsWith('263')) {
      return 'Invalid Zimbabwe number format';
    }

    // General validation message
    if (cleanNumber.length < 7) return 'Phone number must be at least 7 digits';
    if (cleanNumber.length > 15) return 'Phone number cannot exceed 15 digits';
    return 'Invalid phone number format';
  }

  /// Get phone counter text with appropriate limits
  String _getPhoneCounterText(String phoneNumber) {
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

    if (cleanNumber.startsWith('07')) {
      return '${cleanNumber.length}/9 digits (07XXXXXXXX)';
    } else if (cleanNumber.startsWith('7')) {
      return '${cleanNumber.length}/8 digits (7XXXXXXXX)';
    } else if (cleanNumber.startsWith('263')) {
      return '${cleanNumber.length}/11 digits (263XXXXXXXXX)';
    }

    return '${cleanNumber.length}/15 digits';
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    // Additional phone validation
    final phoneNumber = _phoneController.text.trim();
    if (!_isValidPhoneNumber(phoneNumber)) {
      ToastManager.showError(context, _getPhoneValidationMessage(phoneNumber));
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Format name to capitalize first letter of each word
      final formattedName = _formatName(_nameController.text.trim());

      final success = await ref
          .read(authProvider.notifier)
          .register(
            _emailController.text.trim(),
            _passwordController.text,
            formattedName,
            phoneNumber,
          );

      if (success && mounted) {
        ToastManager.showSuccess(
          context,
          'Registration successful! Welcome to Ashley\'s Treats!',
        );
        Navigator.pushReplacementNamed(context, '/welcome', arguments: true);
      } else if (mounted) {
        ToastManager.showError(
          context,
          ref.read(authProvider).error ?? 'Registration failed',
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.secondary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),

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
                              color: AppColors.primary.withOpacity(0.3),
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
                        'Join Ashley\'s Treats!',
                        style: AppTheme.authTitleStyle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Create your account and start your sweet journey',
                        style: AppTheme.authSubtitleStyle,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Name Field
                TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    hintText: 'e.g., John Smith',
                    prefixIcon: Icon(Icons.person_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    if (value.length < 2) {
                      return 'Name must be at least 2 characters';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

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

                // Phone number format info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Zimbabwe mobile numbers: 07XXXXXXXX (9 digits) or 7XXXXXXXX (8 digits)',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Phone Field
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber number) {
                      _selectedCountryCode = number.dialCode ?? '+263';
                      _phoneController.text = number.phoneNumber ?? '';
                    },
                    onInputValidated: (bool value) {
                      // Validation callback
                    },
                    selectorConfig: const SelectorConfig(
                      selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                      showFlags: true,
                      useEmoji: true,
                    ),
                    ignoreBlank: false,
                    autoValidateMode: AutovalidateMode.disabled,
                    selectorTextStyle: const TextStyle(color: Colors.black),
                    initialValue: PhoneNumber(
                      phoneNumber: '',
                      isoCode: 'ZW',
                      dialCode: '+263',
                    ),
                    formatInput: true,
                    maxLength: 15, // Limit phone number to 15 digits
                    keyboardType: const TextInputType.numberWithOptions(
                      signed: true,
                      decimal: true,
                    ),
                    inputDecoration: const InputDecoration(
                      labelText: 'Phone Number',
                      hintText: 'e.g., 07XXXXXXXX or 7XXXXXXXX',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      counterText:
                          '', // Hide the default counter since we have a custom one
                    ),
                    onFieldSubmitted: (_) {
                      // Handle field submission
                    },
                  ),
                ),

                // Phone validation message
                if (_phoneController.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                    child: Row(
                      children: [
                        Icon(
                          _isValidPhoneNumber(_phoneController.text)
                              ? Icons.check_circle
                              : Icons.error,
                          color: _isValidPhoneNumber(_phoneController.text)
                              ? Colors.green[600]
                              : Colors.red[600],
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _getPhoneValidationMessage(_phoneController.text),
                          style: TextStyle(
                            color: _isValidPhoneNumber(_phoneController.text)
                                ? Colors.green[600]
                                : Colors.red[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Phone character counter
                if (_phoneController.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, left: 12.0),
                    child: Text(
                      _getPhoneCounterText(_phoneController.text),
                      style: TextStyle(color: Colors.grey[600], fontSize: 11),
                    ),
                  ),

                const SizedBox(height: 20),

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  textInputAction: TextInputAction.next,
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

                const SizedBox(height: 20),

                // Confirm Password Field
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    hintText: 'Confirm your password',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 32),

                // Register Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _register,
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
                      : const Text('Create Account'),
                ),

                const SizedBox(height: 24),

                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: AppTheme.authSubtitleStyle,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Sign In', style: AppTheme.linkTextStyle),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Terms and Conditions
                Center(
                  child: Text(
                    'By creating an account, you agree to our Terms of Service and Privacy Policy',
                    style: AppTheme.authSubtitleStyle.copyWith(
                      fontSize: 12,
                      color: AppColors.secondary.withOpacity(0.6),
                    ),
                    textAlign: TextAlign.center,
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
