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
  late AnimationController _bounceController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bounceAnimation;

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
      'color': AppColors.primary,
    },
    {
      'icon': Icons.search_rounded,
      'label': 'Search',
      'activeIcon': Icons.search_rounded,
      'color': AppColors.accent,
    },
    {
      'icon': Icons.receipt_long_outlined,
      'label': 'Orders',
      'activeIcon': Icons.receipt_long_rounded,
      'color': AppColors.secondary,
    },
    {
      'icon': Icons.shopping_bag_outlined,
      'label': 'Cart',
      'activeIcon': Icons.shopping_bag_rounded,
      'color': AppColors.accent,
    },
    {
      'icon': Icons.person_outline_rounded,
      'label': 'Profile',
      'activeIcon': Icons.person_rounded,
      'color': AppColors.secondary,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return; // Prevent re-tapping same item

    setState(() {
      _selectedIndex = index;
    });

    // Enhanced animation sequence
    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    _bounceController.forward().then((_) {
      _bounceController.reverse();
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
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.15),
              blurRadius: 25,
              offset: const Offset(0, -8),
              spreadRadius: 2,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_navItems.length, (index) {
                final item = _navItems[index];
                final isSelected = _selectedIndex == index;

                return GestureDetector(
                  onTap: () => _onItemTapped(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    padding: EdgeInsets.symmetric(
                      horizontal: isSelected ? 16 : 12,
                      vertical: isSelected ? 12 : 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? item['color'].withValues(alpha: 0.15)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: isSelected
                          ? Border.all(
                              color: item['color'].withValues(alpha: 0.3),
                              width: 1.5,
                            )
                          : null,
                    ),
                    child: Stack(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedBuilder(
                              animation: _bounceController,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: isSelected && _selectedIndex == index
                                      ? _bounceAnimation.value
                                      : 1.0,
                                  child: AnimatedScale(
                                    scale: isSelected ? 1.3 : 1.0,
                                    duration: const Duration(milliseconds: 200),
                                    child: Icon(
                                      isSelected
                                          ? item['activeIcon']
                                          : item['icon'],
                                      color: isSelected
                                          ? item['color']
                                          : AppColors.secondary.withValues(
                                              alpha: 0.5,
                                            ),
                                      size: 26,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 6),
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 200),
                              style: AppTheme.elegantBodyStyle.copyWith(
                                fontSize: 11,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isSelected
                                    ? item['color']
                                    : AppColors.secondary.withValues(
                                        alpha: 0.6,
                                      ),
                              ),
                              child: Text(item['label']),
                            ),
                            if (isSelected)
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.only(top: 6),
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: item['color'],
                                  borderRadius: BorderRadius.circular(3),
                                  boxShadow: [
                                    BoxShadow(
                                      color: item['color'].withValues(
                                        alpha: 0.4,
                                      ),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        // Enhanced cart badge for cart tab
                        if (index == 3 && cartState.itemCount > 0)
                          Positioned(
                            right: -2,
                            top: -2,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.accent,
                                    AppColors.accent.withValues(alpha: 0.8),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.accent.withValues(
                                      alpha: 0.4,
                                    ),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 24,
                                minHeight: 24,
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
