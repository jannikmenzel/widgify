import 'package:flutter/material.dart';
import 'package:widgify/screens/notifications_screen.dart';
import 'package:widgify/screens/settings_screen.dart';
import 'package:widgify/styles/typography.dart';
import 'package:widgify/styles/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData? leadingIcon;
  final VoidCallback? onLeadingPressed;
  final IconData? trailingIcon;
  final VoidCallback? onTrailingPressed;
  final bool isCentered;

  const CustomAppBar({
    super.key,
    required this.title,
    this.leadingIcon,
    this.onLeadingPressed,
    this.trailingIcon,
    this.onTrailingPressed,
    this.isCentered = false,
  });

  @override
  Widget build(BuildContext context) {
    Color titleColor = Theme.of(context).brightness == Brightness.dark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimary;

    return AppBar(
      title: isCentered
          ? Center(
        child: Text(
          title,
          style: AppTypography.title.copyWith(color: titleColor),
        ),
      )
          : Text(
        title,
        style: AppTypography.title.copyWith(color: titleColor),
      ),
      leading: leadingIcon != null
          ? IconButton(
        icon: Icon(
          leadingIcon,
          size: 30.0,
        ),
        onPressed: onLeadingPressed ??
                () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsScreen(),
                ),
              );
            },
      )
          : null,
      actions: trailingIcon != null
          ? [
        IconButton(
          icon: Icon(
            trailingIcon,
            size: 30.0,
          ),
          onPressed: onTrailingPressed ??
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
        ),
      ]
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}