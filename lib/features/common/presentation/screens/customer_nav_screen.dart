import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../products/presentation/screens/product_list_screen.dart';
import '../../../cart/presentation/screens/cart_screen.dart';
import '../../../orders/presentation/screens/order_history_screen.dart';
import '../../../search/presentation/screens/search_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../cart/presentation/providers/cart_provider.dart';

class CustomerNavScreen extends ConsumerStatefulWidget {
  const CustomerNavScreen({super.key});

  @override
  ConsumerState<CustomerNavScreen> createState() => _CustomerNavScreenState();
}

class _CustomerNavScreenState extends ConsumerState<CustomerNavScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  static final List<Widget> _screens = [
    const ProductListScreen(),
    const SearchScreen(),
    const OrderHistoryScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  static final List<Map<String, dynamic>> _navItems = [
    {
      'icon': Icons.home_rounded,
      'label': 'Home',
      'activeIcon': Icons.home_rounded,
    },
    {
      'icon': Icons.search_rounded,
      'label': 'Search',
      'activeIcon': Icons.search_rounded,
    },
    {
      'icon': Icons.receipt_long_outlined,
      'label': 'Orders',
      'activeIcon': Icons.receipt_long_rounded,
    },
    {
      'icon': Icons.shopping_bag_outlined,
      'label': 'Cart',
      'activeIcon': Icons.shopping_bag_rounded,
    },
    {
      'icon': Icons.person_outline_rounded,
      'label': 'Profile',
      'activeIcon': Icons.person_rounded,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  Future<void> _logout() async {
    // Show confirmation dialog
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Logout',
          style: AppTheme.girlishHeadingStyle.copyWith(
            fontSize: 20,
            color: AppColors.secondary,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: AppTheme.elegantBodyStyle.copyWith(
            fontSize: 16,
            color: AppColors.secondary.withValues(alpha: 0.7),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: AppTheme.buttonTextStyle.copyWith(
                color: AppColors.secondary.withValues(alpha: 0.7),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Logout',
              style: AppTheme.buttonTextStyle.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout == true && mounted) {
      await ref.read(authProvider.notifier).logout();
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final cartState = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Ashley\'s Treats',
          style: AppTheme.authTitleStyle.copyWith(
            fontSize: 24,
            color: AppColors.primary,
          ),
        ),
        actions: [
          // User Avatar with Menu
          PopupMenuButton<String>(
            icon: Container(
              margin: const EdgeInsets.only(right: 16),
              child: CircleAvatar(
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Icon(Icons.person, color: AppColors.primary, size: 24),
              ),
            ),
            onSelected: (value) {
              if (value == 'logout') {
                _logout();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person_outline, color: AppColors.primary),
                    const SizedBox(width: 12),
                    Text(
                      'Profile',
                      style: AppTheme.elegantBodyStyle.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: AppColors.accent),
                    const SizedBox(width: 12),
                    Text(
                      'Logout',
                      style: AppTheme.elegantBodyStyle.copyWith(
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0.1, 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                  ),
              child: child,
            ),
          );
        },
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_navItems.length, (index) {
                final item = _navItems[index];
                final isSelected = _selectedIndex == index;

                return GestureDetector(
                  onTap: () => _onItemTapped(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Stack(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedScale(
                              scale: isSelected ? 1.2 : 1.0,
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                isSelected ? item['activeIcon'] : item['icon'],
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.secondary.withValues(
                                        alpha: 0.6,
                                      ),
                                size: 24,
                              ),
                            ),
                            const SizedBox(height: 4),
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 200),
                              style: AppTheme.elegantBodyStyle.copyWith(
                                fontSize: 10,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.secondary.withValues(
                                        alpha: 0.6,
                                      ),
                              ),
                              child: Text(item['label']),
                            ),
                            if (isSelected)
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                          ],
                        ),
                        // Cart badge for cart tab
                        if (index == 3 && cartState.itemCount > 0)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColors.accent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 20,
                                minHeight: 20,
                              ),
                              child: Text(
                                '${cartState.itemCount}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
