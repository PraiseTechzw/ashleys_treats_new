import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../admin/presentation/screens/admin_dashboard_screen.dart';
import '../../../admin/presentation/screens/admin_product_management_screen.dart';
import '../../../admin/presentation/screens/admin_analytics_screen.dart';
import '../../../admin/presentation/screens/admin_settings_screen.dart';
import '../../../admin/presentation/screens/admin_order_management_screen.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class AdminNavScreen extends ConsumerStatefulWidget {
  const AdminNavScreen({super.key});

  @override
  ConsumerState<AdminNavScreen> createState() => _AdminNavScreenState();
}

class _AdminNavScreenState extends ConsumerState<AdminNavScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late AnimationController _bounceController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bounceAnimation;

  static final List<Widget> _screens = [
    const AdminDashboardScreen(),
    const AdminProductManagementScreen(),
    const AdminAnalyticsScreen(),
    const AdminSettingsScreen(),
    const AdminOrderManagementScreen(),
  ];

  static final List<Map<String, dynamic>> _navItems = [
    {
      'icon': Icons.dashboard_rounded,
      'label': 'Dashboard',
      'activeIcon': Icons.dashboard_rounded,
      'color': AppColors.primary,
    },
    {
      'icon': Icons.inventory_2_outlined,
      'label': 'Products',
      'activeIcon': Icons.inventory_2_rounded,
      'color': AppColors.accent,
    },
    {
      'icon': Icons.analytics_outlined,
      'label': 'Analytics',
      'activeIcon': Icons.analytics_rounded,
      'color': AppColors.secondary,
    },
    {
      'icon': Icons.settings_outlined,
      'label': 'Settings',
      'activeIcon': Icons.settings_rounded,
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
    if (index >= _screens.length) {
      // Handle additional nav items (Analytics, Settings)
      return;
    }

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

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Admin Panel',
          style: AppTheme.girlishHeadingStyle.copyWith(
            fontSize: 24,
            color: AppColors.secondary,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.secondary),
        actions: [
          // User Info
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Text(
                  user?.displayName ?? 'Admin',
                  style: AppTheme.elegantBodyStyle.copyWith(
                    fontSize: 14,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: Icon(
                    Icons.admin_panel_settings,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: AppColors.surface,
        child: Column(
          children: [
            // Drawer Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withOpacity(0.1),
                    AppColors.cardColor.withOpacity(0.3),
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Icon(
                        Icons.admin_panel_settings,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Admin Panel',
                      style: AppTheme.girlishHeadingStyle.copyWith(
                        fontSize: 20,
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage your bakery',
                      style: AppTheme.elegantBodyStyle.copyWith(
                        fontSize: 14,
                        color: AppColors.secondary.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Navigation Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: _navItems.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final isSelected = _selectedIndex == index;

                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withOpacity(0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Icon(
                        isSelected ? item['activeIcon'] : item['icon'],
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.secondary.withOpacity(0.7),
                      ),
                      title: Text(
                        item['label'],
                        style: AppTheme.elegantBodyStyle.copyWith(
                          fontSize: 16,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.secondary,
                        ),
                      ),
                      selected: isSelected,
                      onTap: () {
                        _onItemTapped(index);
                        Navigator.pop(context);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            // Logout Section
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Divider(color: AppColors.cardColor),
                  const SizedBox(height: 8),
                  ListTile(
                    leading: Icon(Icons.logout, color: AppColors.accent),
                    title: Text(
                      'Logout',
                      style: AppTheme.elegantBodyStyle.copyWith(
                        fontSize: 16,
                        color: AppColors.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      ref.read(authProvider.notifier).logout();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
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
                final isAvailable = index < _screens.length;

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
                    child: Column(
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
                                  isSelected ? item['activeIcon'] : item['icon'],
                                  color: isSelected
                                      ? item['color']
                                      : isAvailable
                                          ? AppColors.secondary.withValues(alpha: 0.5)
                                          : AppColors.secondary.withValues(alpha: 0.3),
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
                                : isAvailable
                                    ? AppColors.secondary.withValues(alpha: 0.6)
                                    : AppColors.secondary.withValues(alpha: 0.4),
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
                                  color: item['color'].withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                        if (!isAvailable)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Soon',
                              style: AppTheme.elegantBodyStyle.copyWith(
                                fontSize: 8,
                                color: AppColors.secondary.withValues(alpha: 0.5),
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
