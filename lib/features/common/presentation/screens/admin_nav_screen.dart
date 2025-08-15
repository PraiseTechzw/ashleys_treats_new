import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../admin/presentation/screens/admin_dashboard_screen.dart';
import '../../../admin/presentation/screens/admin_product_management_screen.dart';
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

  static final List<Widget> _screens = [
    const AdminDashboardScreen(),
    const AdminProductManagementScreen(),
  ];

  static final List<Map<String, dynamic>> _navItems = [
    {
      'icon': Icons.dashboard_rounded,
      'label': 'Dashboard',
      'activeIcon': Icons.dashboard_rounded,
    },
    {
      'icon': Icons.inventory_2_outlined,
      'label': 'Products',
      'activeIcon': Icons.inventory_2_rounded,
    },
    {
      'icon': Icons.analytics_outlined,
      'label': 'Analytics',
      'activeIcon': Icons.analytics_rounded,
    },
    {
      'icon': Icons.settings_outlined,
      'label': 'Settings',
      'activeIcon': Icons.settings_rounded,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index >= _screens.length) {
      // Handle additional nav items (Analytics, Settings)
      return;
    }

    setState(() {
      _selectedIndex = index;
    });

    // Add a subtle animation when tapping
    _animationController.forward().then((_) {
      _animationController.reverse();
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
    );
  }
}
