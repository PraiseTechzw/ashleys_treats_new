import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../providers/auth_provider.dart';

class LogoutButton extends ConsumerWidget {
  final VoidCallback? onLogoutComplete;
  final bool showIcon;
  final String? customText;

  const LogoutButton({
    super.key,
    this.onLogoutComplete,
    this.showIcon = true,
    this.customText,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authProvider.select((state) => state.isLoading));

    return PopupMenuButton<String>(
      onSelected: (value) async {
        if (value == 'logout') {
          await _handleLogout(context, ref);
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout, color: AppColors.accent, size: 20),
              const SizedBox(width: 12),
              Text(
                'Logout',
                style: TextStyle(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.accent.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showIcon) ...[
              Icon(Icons.logout, color: AppColors.accent, size: 18),
              const SizedBox(width: 8),
            ],
            if (isLoading)
              const SmallLoading(type: LoadingType.loading, size: 16)
            else
              Text(
                customText ?? 'Logout',
                style: TextStyle(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(authProvider.notifier).logout();

      if (context.mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Logged out successfully'),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

        // Navigate to login screen
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/login', (route) => false);

        // Call callback if provided
        onLogoutComplete?.call();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: ${e.toString()}'),
            backgroundColor: AppColors.accent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }
}

// Alternative simple logout button
class SimpleLogoutButton extends ConsumerWidget {
  final VoidCallback? onLogoutComplete;

  const SimpleLogoutButton({super.key, this.onLogoutComplete});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authProvider.select((state) => state.isLoading));

    return IconButton(
      onPressed: isLoading ? null : () => _handleLogout(context, ref),
      icon: isLoading
          ? const SmallLoading(type: LoadingType.loading, size: 20)
          : Icon(Icons.logout, color: AppColors.accent),
      tooltip: 'Logout',
    );
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(authProvider.notifier).logout();

      if (context.mounted) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/login', (route) => false);

        onLogoutComplete?.call();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: ${e.toString()}'),
            backgroundColor: AppColors.accent,
          ),
        );
      }
    }
  }
}
