import 'package:flutter/material.dart';
import 'package:ashleys_treats/core/theme/app_colors.dart';
import 'package:ashleys_treats/core/theme/app_theme.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAllPressed;
  final IconData? icon;
  final String? viewAllText;
  final bool showViewAll;

  const SectionHeader({
    super.key,
    required this.title,
    this.onViewAllPressed,
    this.icon,
    this.viewAllText = 'View All',
    this.showViewAll = true,
  });

  IconData _getDefaultIcon(String title) {
    switch (title.toLowerCase()) {
      case 'featured treats':
        return Icons.star_rounded;
      case 'categories':
        return Icons.category_rounded;
      case 'all cupcakes':
      case 'all cakes':
      case 'all cookies':
      case 'all donuts':
      case 'all muffins':
      case 'all brownies':
      case 'all cake pops':
        return Icons.cake_rounded;
      case 'promotional offers':
        return Icons.local_offer_rounded;
      case 'sweet & savory':
        return Icons.celebration_rounded;
      default:
        return Icons.local_offer_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.surface, AppColors.surface.withOpacity(0.95)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Title section with icon
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withOpacity(0.15),
                        AppColors.accent.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    icon ?? _getDefaultIcon(title),
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: AppTheme.girlishHeadingStyle.copyWith(
                      fontSize: 22,
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // View All button
          if (showViewAll && onViewAllPressed != null)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.1),
                    AppColors.accent.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onViewAllPressed,
                  borderRadius: BorderRadius.circular(25),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          viewAllText!,
                          style: AppTheme.elegantBodyStyle.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: AppColors.primary,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
