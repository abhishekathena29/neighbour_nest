import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String icon;
  final String color;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorValue = Color(int.parse(color.replaceAll('#', '0xFF')));

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? colorValue.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
          border: Border.all(
            color: isSelected ? colorValue : AppTheme.dividerColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getIconData(icon),
              color: isSelected ? colorValue : AppTheme.textSecondary,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isSelected ? colorValue : AppTheme.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'school':
        return Icons.school;
      case 'business':
        return Icons.business;
      case 'palette':
        return Icons.palette;
      case 'favorite':
        return Icons.favorite;
      case 'computer':
        return Icons.computer;
      case 'home':
        return Icons.home;
      case 'star':
        return Icons.star;
      case 'more_horiz':
        return Icons.more_horiz;
      default:
        return Icons.category;
    }
  }
}
