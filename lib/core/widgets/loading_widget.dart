import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

enum LoadingType { cupcake, loading, flavors, delivery, celebrate, custom }

class LoadingWidget extends StatelessWidget {
  final LoadingType type;
  final double? size;
  final String? message;
  final Color? color;
  final bool showMessage;

  const LoadingWidget({
    super.key,
    this.type = LoadingType.loading,
    this.size,
    this.message,
    this.color,
    this.showMessage = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Lottie Animation
        SizedBox(
          width: size ?? 120,
          height: size ?? 120,
          child: Lottie.asset(
            _getAnimationPath(),
            fit: BoxFit.contain,
            repeat: true,
            animate: true,
          ),
        ),

        // Loading Message
        if (showMessage && message != null) ...[
          const SizedBox(height: 16),
          Text(
            message!,
            style: AppTheme.elegantBodyStyle.copyWith(
              fontSize: 16,
              color: color ?? AppColors.secondary.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  String _getAnimationPath() {
    switch (type) {
      case LoadingType.cupcake:
        return 'assets/animations/cupcakeani.json';
      case LoadingType.loading:
        return 'assets/animations/loading.json';
      case LoadingType.flavors:
        return 'assets/animations/flavors.json';
      case LoadingType.delivery:
        return 'assets/animations/Delivery.json';
      case LoadingType.celebrate:
        return 'assets/animations/celebrate Confetti.json';
      case LoadingType.custom:
        return 'assets/animations/loading.json';
    }
  }
}

// Full Screen Loading Widget
class FullScreenLoading extends StatelessWidget {
  final LoadingType type;
  final String? message;
  final Color? backgroundColor;

  const FullScreenLoading({
    super.key,
    this.type = LoadingType.loading,
    this.message,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.background,
              AppColors.cardColor.withOpacity(0.3),
              AppColors.background,
            ],
          ),
        ),
        child: Center(
          child: LoadingWidget(
            type: type,
            size: 150,
            message: message ?? 'Loading...',
            showMessage: true,
          ),
        ),
      ),
    );
  }
}

// Overlay Loading Widget
class OverlayLoading extends StatelessWidget {
  final LoadingType type;
  final String? message;
  final bool isVisible;

  const OverlayLoading({
    super.key,
    this.type = LoadingType.loading,
    this.message,
    this.isVisible = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: LoadingWidget(
            type: type,
            size: 80,
            message: message,
            showMessage: message != null,
          ),
        ),
      ),
    );
  }
}

// Small Loading Widget for buttons and small spaces
class SmallLoading extends StatelessWidget {
  final LoadingType type;
  final double? size;

  const SmallLoading({super.key, this.type = LoadingType.loading, this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size ?? 24,
      height: size ?? 24,
      child: Lottie.asset(
        _getAnimationPath(),
        fit: BoxFit.contain,
        repeat: true,
        animate: true,
      ),
    );
  }

  String _getAnimationPath() {
    switch (type) {
      case LoadingType.cupcake:
        return 'assets/animations/cupcakeani.json';
      case LoadingType.loading:
        return 'assets/animations/loading.json';
      case LoadingType.flavors:
        return 'assets/animations/flavors.json';
      case LoadingType.delivery:
        return 'assets/animations/Delivery.json';
      case LoadingType.celebrate:
        return 'assets/animations/celebrate Confetti.json';
      case LoadingType.custom:
        return 'assets/animations/loading.json';
    }
  }
}
