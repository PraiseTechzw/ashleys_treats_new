import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

class AboutScreen extends ConsumerStatefulWidget {
  const AboutScreen({super.key});

  @override
  ConsumerState<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends ConsumerState<AboutScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'About',
          style: AppTheme.girlishHeadingStyle.copyWith(
            fontSize: 20,
            color: AppColors.secondary,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.secondary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildCompanyHeader(),
                const SizedBox(height: 24),

                _buildAppInfo(),
                const SizedBox(height: 24),

                _buildCompanyStory(),
                const SizedBox(height: 24),

                _buildValues(),
                const SizedBox(height: 24),

                _buildTeam(),
                const SizedBox(height: 24),

                _buildContactInfo(),
                const SizedBox(height: 24),

                _buildLicenses(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.15),
            AppColors.accent.withValues(alpha: 0.1),
            AppColors.background,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.2),
                  AppColors.accent.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.4),
                width: 3,
              ),
            ),
            child: Icon(Icons.cake_rounded, color: AppColors.primary, size: 50),
          ),
          const SizedBox(height: 20),
          Text(
            'Ashley\'s Treats',
            style: AppTheme.girlishHeadingStyle.copyWith(
              fontSize: 28,
              color: AppColors.secondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Bringing Sweet Moments to Life',
            style: AppTheme.elegantBodyStyle.copyWith(
              fontSize: 18,
              color: AppColors.secondary.withValues(alpha: 0.8),
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Est. 2020',
            style: AppTheme.elegantBodyStyle.copyWith(
              fontSize: 14,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'App Information',
                style: AppTheme.girlishHeadingStyle.copyWith(
                  fontSize: 20,
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildInfoRow('Version', '1.0.0'),
          _buildInfoRow('Build Number', '100'),
          _buildInfoRow('Platform', 'Flutter'),
          _buildInfoRow('Last Updated', 'December 2024'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTheme.elegantBodyStyle.copyWith(
              fontSize: 16,
              color: AppColors.secondary.withValues(alpha: 0.7),
            ),
          ),
          Text(
            value,
            style: AppTheme.elegantBodyStyle.copyWith(
              fontSize: 16,
              color: AppColors.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyStory() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.history_rounded, color: AppColors.primary, size: 24),
              const SizedBox(width: 12),
              Text(
                'Our Story',
                style: AppTheme.girlishHeadingStyle.copyWith(
                  fontSize: 20,
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Ashley\'s Treats was born from a simple passion: creating delicious, homemade treats that bring joy to every occasion. What started as a small home kitchen has grown into a beloved local bakery, serving our community with love and dedication.',
            style: AppTheme.elegantBodyStyle.copyWith(
              fontSize: 16,
              color: AppColors.secondary.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Today, we continue to craft each treat with the same care and attention to detail, using only the finest ingredients and traditional recipes passed down through generations.',
            style: AppTheme.elegantBodyStyle.copyWith(
              fontSize: 16,
              color: AppColors.secondary.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValues() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.favorite_rounded, color: AppColors.primary, size: 24),
              const SizedBox(width: 12),
              Text(
                'Our Values',
                style: AppTheme.girlishHeadingStyle.copyWith(
                  fontSize: 20,
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildValueItem(
            'Quality',
            'We never compromise on the quality of our ingredients or the care we put into every treat.',
            Icons.star_rounded,
          ),
          const SizedBox(height: 16),
          _buildValueItem(
            'Community',
            'We believe in building strong relationships with our customers and supporting our local community.',
            Icons.people_rounded,
          ),
          const SizedBox(height: 16),
          _buildValueItem(
            'Innovation',
            'We constantly explore new flavors and techniques to surprise and delight our customers.',
            Icons.lightbulb_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildValueItem(String title, String description, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.elegantBodyStyle.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: AppTheme.elegantBodyStyle.copyWith(
                  fontSize: 14,
                  color: AppColors.secondary.withValues(alpha: 0.7),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTeam() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.group_rounded, color: AppColors.primary, size: 24),
              const SizedBox(width: 12),
              Text(
                'Our Team',
                style: AppTheme.girlishHeadingStyle.copyWith(
                  fontSize: 20,
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildTeamMember(
            'Ashley Johnson',
            'Founder & Head Baker',
            'The heart and soul of Ashley\'s Treats, Ashley brings over 15 years of baking experience and a passion for creating memorable treats.',
          ),
          const SizedBox(height: 16),
          _buildTeamMember(
            'Michael Chen',
            'Pastry Chef',
            'A culinary school graduate with expertise in French pastries and modern dessert techniques.',
          ),
          const SizedBox(height: 16),
          _buildTeamMember(
            'Sarah Williams',
            'Customer Experience Manager',
            'Ensuring every customer interaction is delightful and memorable.',
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMember(String name, String role, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: AppTheme.elegantBodyStyle.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.secondary,
          ),
        ),
        Text(
          role,
          style: AppTheme.elegantBodyStyle.copyWith(
            fontSize: 14,
            color: AppColors.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: AppTheme.elegantBodyStyle.copyWith(
            fontSize: 14,
            color: AppColors.secondary.withValues(alpha: 0.7),
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildContactInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.contact_phone_rounded,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Contact Information',
                style: AppTheme.girlishHeadingStyle.copyWith(
                  fontSize: 20,
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildContactItem(Icons.phone_rounded, 'Phone', '+1 (555) 123-4567'),
          const SizedBox(height: 16),
          _buildContactItem(
            Icons.email_rounded,
            'Email',
            'hello@ashleystreats.com',
          ),
          const SizedBox(height: 16),
          _buildContactItem(
            Icons.location_on_rounded,
            'Address',
            '123 Sweet Street\nDessert City, DC 12345',
          ),
          const SizedBox(height: 16),
          _buildContactItem(
            Icons.access_time_rounded,
            'Hours',
            'Monday - Friday: 8:00 AM - 8:00 PM\nSaturday - Sunday: 9:00 AM - 6:00 PM',
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTheme.elegantBodyStyle.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondary.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: AppTheme.elegantBodyStyle.copyWith(
                  fontSize: 16,
                  color: AppColors.secondary,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLicenses() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.description_rounded,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Licenses & Legal',
                style: AppTheme.girlishHeadingStyle.copyWith(
                  fontSize: 20,
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildLicenseItem(
            'Privacy Policy',
            'Read our privacy policy to understand how we collect and use your information.',
            () => _showPrivacyPolicy(),
          ),
          const SizedBox(height: 16),
          _buildLicenseItem(
            'Terms of Service',
            'Review our terms of service and user agreement.',
            () => _showTermsOfService(),
          ),
          const SizedBox(height: 16),
          _buildLicenseItem(
            'Open Source Licenses',
            'View licenses for open source software used in this app.',
            () => _showOpenSourceLicenses(),
          ),
          const SizedBox(height: 16),
          _buildLicenseItem(
            'Cookie Policy',
            'Learn about how we use cookies and similar technologies.',
            () => _showCookiePolicy(),
          ),
        ],
      ),
    );
  }

  Widget _buildLicenseItem(
    String title,
    String description,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.elegantBodyStyle.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: AppTheme.elegantBodyStyle.copyWith(
                      fontSize: 14,
                      color: AppColors.secondary.withValues(alpha: 0.7),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.secondary.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }

  void _showPrivacyPolicy() {
    _showLicenseDialog(
      'Privacy Policy',
      'Last updated: December 2024\n\n'
          'At Ashley\'s Treats, we respect your privacy and are committed to protecting your personal information. '
          'This Privacy Policy explains how we collect, use, and safeguard your information when you use our mobile application.\n\n'
          'Information We Collect:\n'
          '• Personal information (name, email, phone number)\n'
          '• Delivery addresses\n'
          '• Payment information\n'
          '• Order history\n'
          '• App usage data\n\n'
          'How We Use Your Information:\n'
          '• Process and fulfill your orders\n'
          '• Provide customer support\n'
          '• Send order updates and notifications\n'
          '• Improve our services\n'
          '• Comply with legal obligations\n\n'
          'We never sell your personal information to third parties.',
    );
  }

  void _showTermsOfService() {
    _showLicenseDialog(
      'Terms of Service',
      'Last updated: December 2024\n\n'
          'By using the Ashley\'s Treats mobile application, you agree to these Terms of Service.\n\n'
          'Acceptance of Terms:\n'
          'By accessing or using our app, you agree to be bound by these terms.\n\n'
          'Use of Service:\n'
          '• You must be at least 18 years old to use our services\n'
          '• You are responsible for maintaining the security of your account\n'
          '• You agree not to misuse our services\n\n'
          'Ordering and Payment:\n'
          '• All prices are subject to change without notice\n'
          '• Payment is required at the time of ordering\n'
          '• We reserve the right to refuse service\n\n'
          'Delivery:\n'
          '• Delivery times are estimates only\n'
          '• We are not responsible for delays beyond our control\n'
          '• Risk of loss transfers upon delivery',
    );
  }

  void _showOpenSourceLicenses() {
    _showLicenseDialog(
      'Open Source Licenses',
      'This application uses the following open source software:\n\n'
          'Flutter Framework\n'
          'Copyright 2014 The Flutter Authors\n'
          'Licensed under the Apache License, Version 2.0\n\n'
          'Dart\n'
          'Copyright 2012 The Dart Authors\n'
          'Licensed under the BSD 3-Clause License\n\n'
          'Firebase\n'
          'Copyright 2020 Google LLC\n'
          'Licensed under the Apache License, Version 2.0\n\n'
          'Riverpod\n'
          'Copyright 2020 Remi Rousselet\n'
          'Licensed under the MIT License\n\n'
          'Lottie\n'
          'Copyright 2018 Airbnb\n'
          'Licensed under the Apache License, Version 2.0\n\n'
          'For complete license texts, visit:\n'
          'https://github.com/flutter/flutter\n'
          'https://github.com/dart-lang/sdk\n'
          'https://github.com/firebase/firebase-ios-sdk\n'
          'https://github.com/rrousselGit/riverpod\n'
          'https://github.com/airbnb/lottie-android',
    );
  }

  void _showCookiePolicy() {
    _showLicenseDialog(
      'Cookie Policy',
      'Last updated: December 2024\n\n'
          'This Cookie Policy explains how Ashley\'s Treats uses cookies and similar technologies in our mobile application.\n\n'
          'What Are Cookies:\n'
          'Cookies are small text files stored on your device that help us provide a better user experience.\n\n'
          'Types of Cookies We Use:\n'
          '• Essential Cookies: Required for basic app functionality\n'
          '• Performance Cookies: Help us understand how the app is used\n'
          '• Functional Cookies: Remember your preferences and settings\n'
          '• Analytics Cookies: Provide insights into app usage\n\n'
          'Managing Cookies:\n'
          'You can control cookie settings through your device settings or browser preferences.\n\n'
          'Third-Party Cookies:\n'
          'We may use third-party services that set their own cookies for analytics and advertising purposes.',
    );
  }

  void _showLicenseDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: AppTheme.girlishHeadingStyle.copyWith(
              fontSize: 20,
              color: AppColors.secondary,
            ),
          ),
          content: SingleChildScrollView(
            child: Text(
              content,
              style: AppTheme.elegantBodyStyle.copyWith(
                fontSize: 14,
                color: AppColors.secondary.withValues(alpha: 0.8),
                height: 1.4,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: AppTheme.elegantBodyStyle.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
