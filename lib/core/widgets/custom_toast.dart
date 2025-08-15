import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

enum ToastType { success, error, warning, info }

class CustomToast extends StatelessWidget {
  final String message;
  final ToastType type;
  final Duration duration;
  final VoidCallback? onDismiss;

  const CustomToast({
    super.key,
    required this.message,
    this.type = ToastType.success,
    this.duration = const Duration(seconds: 3),
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: _getBackgroundColor(),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: _getBackgroundColor().withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
                border: Border.all(color: _getBorderColor(), width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon or Animation
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: _getBackgroundColor().withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: _buildIcon(),
                  ),
                  const SizedBox(width: 12),

                  // Message
                  Flexible(
                    child: Text(
                      message,
                      style: AppTheme.elegantBodyStyle.copyWith(
                        fontSize: 14,
                        color: _getTextColor(),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Close button
                  GestureDetector(
                    onTap: onDismiss,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: _getBackgroundColor().withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.close,
                        size: 16,
                        color: _getTextColor(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIcon() {
    switch (type) {
      case ToastType.success:
        return Lottie.asset(
          'assets/animations/cupcakeani.json',
          fit: BoxFit.contain,
          repeat: false,
          animate: true,
        );
      case ToastType.error:
        return const Icon(
          Icons.error_outline,
          color: AppColors.accent,
          size: 20,
        );
      case ToastType.warning:
        return const Icon(
          Icons.warning_amber_outlined,
          color: Colors.orange,
          size: 20,
        );
      case ToastType.info:
        return const Icon(
          Icons.info_outline,
          color: AppColors.primary,
          size: 20,
        );
    }
  }

  Color _getBackgroundColor() {
    switch (type) {
      case ToastType.success:
        return AppColors.primary.withValues(alpha: 0.95);
      case ToastType.error:
        return AppColors.accent.withValues(alpha: 0.95);
      case ToastType.warning:
        return Colors.orange.withValues(alpha: 0.95);
      case ToastType.info:
        return AppColors.secondary.withValues(alpha: 0.95);
    }
  }

  Color _getBorderColor() {
    switch (type) {
      case ToastType.success:
        return AppColors.primary;
      case ToastType.error:
        return AppColors.accent;
      case ToastType.warning:
        return Colors.orange;
      case ToastType.info:
        return AppColors.secondary;
    }
  }

  Color _getTextColor() {
    switch (type) {
      case ToastType.success:
        return AppColors.onPrimary;
      case ToastType.error:
        return AppColors.onSecondary;
      case ToastType.warning:
        return Colors.white;
      case ToastType.info:
        return AppColors.onSecondary;
    }
  }
}

// Toast Manager
class ToastManager {
  static void showSuccess(BuildContext context, String message) {
    _showToast(context, message, ToastType.success);
  }

  static void showError(BuildContext context, String message) {
    _showToast(context, message, ToastType.error);
  }

  static void showWarning(BuildContext context, String message) {
    _showToast(context, message, ToastType.warning);
  }

  static void showInfo(BuildContext context, String message) {
    _showToast(context, message, ToastType.info);
  }

  static void _showToast(BuildContext context, String message, ToastType type) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 20,
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: CustomToast(
            message: message,
            type: type,
            onDismiss: () {
              overlayEntry.remove();
            },
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Auto dismiss after duration
    Future.delayed(const Duration(seconds: 3), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }
}
