import 'package:flutter/material.dart';

/// Responsive wrapper that ensures consistent layout across all mobile screen sizes
/// Constrains maximum width for tablets while maintaining full width on phones
class ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsets? padding;

  const ResponsiveWrapper({
    super.key,
    required this.child,
    this.maxWidth = 600, // Max width for larger screens/tablets
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: padding != null
            ? Padding(padding: padding!, child: child)
            : child,
      ),
    );
  }
}

/// Extension to get responsive values based on screen size
extension ResponsiveExt on BuildContext {
  /// Returns true if device is a phone (width < 600)
  bool get isPhone => MediaQuery.of(this).size.width < 600;

  /// Returns true if device is a tablet (width >= 600 && width < 1200)
  bool get isTablet {
    final width = MediaQuery.of(this).size.width;
    return width >= 600 && width < 1200;
  }

  /// Returns true if device is desktop (width >= 1200)
  bool get isDesktop => MediaQuery.of(this).size.width >= 1200;

  /// Returns responsive padding based on screen size
  double get responsivePadding {
    if (isPhone) return 24.0;
    if (isTablet) return 32.0;
    return 48.0;
  }

  /// Returns responsive font size multiplier
  double get fontSizeMultiplier {
    if (isPhone) return 1.0;
    if (isTablet) return 1.1;
    return 1.2;
  }

  /// Get screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Get screen height
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Returns true if keyboard is visible
  bool get isKeyboardVisible => MediaQuery.of(this).viewInsets.bottom > 0;
}
