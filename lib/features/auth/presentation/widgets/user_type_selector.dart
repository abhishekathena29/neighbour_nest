import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/models/user_model.dart';

class UserTypeSelector extends StatelessWidget {
  final UserType? selectedType;
  final ValueChanged<UserType> onChanged;

  const UserTypeSelector({
    super.key,
    this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'I want to',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _UserTypeCard(
                type: UserType.contributor,
                title: 'Offer Services',
                subtitle: 'Share your skills',
                icon: Icons.person_add,
                isSelected: selectedType == UserType.contributor,
                onTap: () => onChanged(UserType.contributor),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _UserTypeCard(
                type: UserType.customer,
                title: 'Find Services',
                subtitle: 'Get help from neighbors',
                icon: Icons.search,
                isSelected: selectedType == UserType.customer,
                onTap: () => onChanged(UserType.customer),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _UserTypeCard extends StatelessWidget {
  final UserType type;
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _UserTypeCard({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor.withOpacity(0.1)
              : Colors.white,
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : AppTheme.dividerColor,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected
                  ? AppTheme.primaryColor
                  : AppTheme.textSecondary,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: isSelected
                    ? AppTheme.primaryColor
                    : AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isSelected
                    ? AppTheme.primaryColor
                    : AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
