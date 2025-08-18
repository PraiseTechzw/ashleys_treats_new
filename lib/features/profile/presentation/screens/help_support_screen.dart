import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

class HelpSupportScreen extends ConsumerStatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  ConsumerState<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends ConsumerState<HelpSupportScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _expandController;
  late Animation<double> _expandAnimation;

  final List<FAQItem> _faqs = [
    FAQItem(
      question: 'How do I place an order?',
      answer: 'Browse our delicious treats, add items to your cart, and proceed to checkout. You can choose delivery or pickup options.',
    ),
    FAQItem(
      question: 'What are your delivery options?',
      answer: 'We offer standard delivery (2-3 business days), express delivery (same day for orders placed before 2 PM), and free pickup from our store.',
    ),
    FAQItem(
      question: 'How can I track my order?',
      answer: 'You\'ll receive email and SMS updates, and you can track your order in real-time through the app\'s order tracking feature.',
    ),
    FAQItem(
      question: 'What is your return policy?',
      answer: 'We accept returns within 24 hours of delivery for quality issues. Contact our customer service team for assistance.',
    ),
    FAQItem(
      question: 'Do you offer catering services?',
      answer: 'Yes! We provide catering for events, parties, and corporate functions. Contact us for custom orders and pricing.',
    ),
    FAQItem(
      question: 'Are your products allergen-free?',
      answer: 'We offer various allergen-free options. Please check individual product descriptions and contact us for specific dietary requirements.',
    ),
    FAQItem(
      question: 'How do I change my delivery address?',
      answer: 'Go to your profile, select "Delivery Address," and update your information. Changes take effect immediately for new orders.',
    ),
    FAQItem(
      question: 'What payment methods do you accept?',
      answer: 'We accept all major credit cards, debit cards, PayPal, and Apple Pay. Cash is accepted for pickup orders.',
    ),
  ];

  int? _expandedIndex;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _expandController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
    
    _expandAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _expandController, curve: Curves.easeOut));
    
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Help & Support',
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
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildQuickActions(),
              const SizedBox(height: 24),
              
              _buildSectionHeader(
                'Frequently Asked Questions',
                Icons.help_outline_rounded,
                'Find answers to common questions',
              ),
              const SizedBox(height: 16),
              _buildFAQs(),
              const SizedBox(height: 24),
              
              _buildSectionHeader(
                'Contact Us',
                Icons.contact_support_rounded,
                'Get in touch with our support team',
              ),
              const SizedBox(height: 16),
              _buildContactOptions(),
              const SizedBox(height: 24),
              
              _buildSectionHeader(
                'Troubleshooting',
                Icons.build_rounded,
                'Common issues and solutions',
              ),
              const SizedBox(height: 16),
              _buildTroubleshooting(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.accent.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Need Help?',
            style: AppTheme.girlishHeadingStyle.copyWith(
              fontSize: 24,
              color: AppColors.secondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'We\'re here to help you have the best experience with Ashley\'s Treats!',
            style: AppTheme.elegantBodyStyle.copyWith(
              fontSize: 16,
              color: AppColors.secondary.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionButton(
                  'Live Chat',
                  Icons.chat_bubble_rounded,
                  Colors.green,
                  () => _showLiveChat(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionButton(
                  'Call Us',
                  Icons.phone_rounded,
                  Colors.blue,
                  () => _makePhoneCall(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTheme.elegantBodyStyle.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.accent.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.girlishHeadingStyle.copyWith(
                    fontSize: 18,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTheme.elegantBodyStyle.copyWith(
                    fontSize: 14,
                    color: AppColors.secondary.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQs() {
    return Container(
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
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _faqs.length,
        itemBuilder: (context, index) {
          final faq = _faqs[index];
          final isExpanded = _expandedIndex == index;
          
          return Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Text(
                  faq.question,
                  style: AppTheme.elegantBodyStyle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondary,
                  ),
                ),
                trailing: Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: AppColors.primary,
                ),
                onTap: () {
                  setState(() {
                    if (_expandedIndex == index) {
                      _expandedIndex = null;
                    } else {
                      _expandedIndex = index;
                    }
                  });
                },
              ),
              if (isExpanded)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(
                    faq.answer,
                    style: AppTheme.elegantBodyStyle.copyWith(
                      fontSize: 14,
                      color: AppColors.secondary.withValues(alpha: 0.8),
                      height: 1.4,
                    ),
                  ),
                ),
              if (index < _faqs.length - 1)
                Divider(
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                  color: AppColors.secondary.withValues(alpha: 0.1),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContactOptions() {
    return Container(
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
        children: [
          _buildContactOption(
            'Customer Service',
            'Get help with orders and general inquiries',
            '+1 (555) 123-4567',
            Icons.phone_rounded,
            () => _makePhoneCall(),
          ),
          _buildDivider(),
          _buildContactOption(
            'Email Support',
            'Send us a detailed message',
            'support@ashleystreats.com',
            Icons.email_rounded,
            () => _sendEmail(),
          ),
          _buildDivider(),
          _buildContactOption(
            'Store Location',
            'Visit us in person',
            '123 Sweet Street, Dessert City, DC 12345',
            Icons.location_on_rounded,
            () => _openMaps(),
          ),
          _buildDivider(),
          _buildContactOption(
            'Business Hours',
            'When we\'re available to help',
            'Mon-Fri: 8AM-8PM, Sat-Sun: 9AM-6PM',
            Icons.access_time_rounded,
            () {},
          ),
        ],
      ),
    );
  }

  Widget _buildContactOption(
    String title,
    String subtitle,
    String detail,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.all(16),
      leading: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.primary, size: 24),
      ),
      title: Text(
        title,
        style: AppTheme.elegantBodyStyle.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.secondary,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTheme.elegantBodyStyle.copyWith(
              fontSize: 14,
              color: AppColors.secondary.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            detail,
            style: AppTheme.elegantBodyStyle.copyWith(
              fontSize: 14,
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      trailing: onTap != () {} ? Icon(
        Icons.chevron_right,
        color: AppColors.secondary.withValues(alpha: 0.5),
      ) : null,
      onTap: onTap,
    );
  }

  Widget _buildTroubleshooting() {
    return Container(
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
        children: [
          _buildTroubleshootingItem(
            'App not loading?',
            'Try restarting the app or checking your internet connection',
            Icons.wifi_off_rounded,
          ),
          _buildDivider(),
          _buildTroubleshootingItem(
            'Can\'t place order?',
            'Ensure your payment method is valid and delivery address is correct',
            Icons.payment_rounded,
          ),
          _buildDivider(),
          _buildTroubleshootingItem(
            'Delivery issues?',
            'Check your delivery address and contact us for tracking updates',
            Icons.local_shipping_rounded,
          ),
          _buildDivider(),
          _buildTroubleshootingItem(
            'Account problems?',
            'Try logging out and back in, or reset your password',
            Icons.account_circle_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildTroubleshootingItem(
    String title,
    String solution,
    IconData icon,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.all(16),
      leading: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.accent.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.accent, size: 24),
      ),
      title: Text(
        title,
        style: AppTheme.elegantBodyStyle.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.secondary,
        ),
      ),
      subtitle: Text(
        solution,
        style: AppTheme.elegantBodyStyle.copyWith(
          fontSize: 14,
          color: AppColors.secondary.withValues(alpha: 0.7),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      indent: 56,
      endIndent: 16,
      color: AppColors.secondary.withValues(alpha: 0.1),
    );
  }

  void _showLiveChat() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Live Chat',
            style: AppTheme.girlishHeadingStyle.copyWith(
              fontSize: 20,
              color: AppColors.secondary,
            ),
          ),
          content: Text(
            'Our live chat feature is coming soon! For now, please use our phone or email support.',
            style: AppTheme.elegantBodyStyle.copyWith(
              fontSize: 16,
              color: AppColors.secondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
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

  void _makePhoneCall() {
    // TODO: Implement phone call functionality
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Call Support',
            style: AppTheme.girlishHeadingStyle.copyWith(
              fontSize: 20,
              color: AppColors.secondary,
            ),
          ),
          content: Text(
            'Calling +1 (555) 123-4567...',
            style: AppTheme.elegantBodyStyle.copyWith(
              fontSize: 16,
              color: AppColors.secondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: AppTheme.elegantBodyStyle.copyWith(
                  color: AppColors.secondary.withValues(alpha: 0.7),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _sendEmail() {
    // TODO: Implement email functionality
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Email Support',
            style: AppTheme.girlishHeadingStyle.copyWith(
              fontSize: 20,
              color: AppColors.secondary,
            ),
          ),
          content: Text(
            'Opening email app to send message to support@ashleystreats.com',
            style: AppTheme.elegantBodyStyle.copyWith(
              fontSize: 16,
              color: AppColors.secondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
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

  void _openMaps() {
    // TODO: Implement maps functionality
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Store Location',
            style: AppTheme.girlishHeadingStyle.copyWith(
              fontSize: 20,
              color: AppColors.secondary,
            ),
          ),
          content: Text(
            'Opening maps to 123 Sweet Street, Dessert City, DC 12345',
            style: AppTheme.elegantBodyStyle.copyWith(
              fontSize: 16,
              color: AppColors.secondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
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

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}
