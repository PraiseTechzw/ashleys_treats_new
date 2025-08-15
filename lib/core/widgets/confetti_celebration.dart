import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ConfettiCelebration extends StatefulWidget {
  final VoidCallback? onComplete;
  final Duration duration;

  const ConfettiCelebration({
    super.key,
    this.onComplete,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<ConfettiCelebration> createState() => _ConfettiCelebrationState();
}

class _ConfettiCelebrationState extends State<ConfettiCelebration>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _startCelebration();
  }

  void _startCelebration() async {
    _animationController.forward();

    // Wait for animation to complete
    await Future.delayed(widget.duration);

    if (mounted) {
      widget.onComplete?.call();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.transparent,
        child: Stack(
          children: [
            // Full screen confetti animation
            Positioned.fill(
              child: Lottie.asset(
                'assets/animations/celebrate Confetti.json',
                fit: BoxFit.cover,
                repeat: false,
                animate: true,
              ),
            ),

            // Center celebration message
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 24,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Success icon
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Lottie.asset(
                        'assets/animations/cupcakeani.json',
                        fit: BoxFit.contain,
                        repeat: false,
                        animate: true,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Success message
                    const Text(
                      'Success! 🎉',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 8),

                    const Text(
                      'Welcome to Ashley\'s Treats!',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Confetti Manager for easy usage
class ConfettiManager {
  static void showCelebration(
    BuildContext context, {
    VoidCallback? onComplete,
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => ConfettiCelebration(
        onComplete: () {
          overlayEntry.remove();
          onComplete?.call();
        },
        duration: duration,
      ),
    );

    overlay.insert(overlayEntry);
  }
}
 