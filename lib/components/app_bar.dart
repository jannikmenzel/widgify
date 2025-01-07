import 'package:flutter/material.dart';
import 'package:widgify/pages/sub/notifications/feed_page.dart';
import 'package:widgify/screens/settings_screen.dart';
import 'package:widgify/styles/colors.dart';
import 'package:widgify/styles/typography.dart';

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

    return PreferredSize(
      preferredSize: preferredSize,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(10),
        ),
        child: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor ??
              AppColors.background,
          automaticallyImplyLeading: false,
          flexibleSpace: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Leading Icon (wenn vorhanden)
                if (leadingIcon != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: IconButton(
                      icon: Icon(
                        leadingIcon,
                        size: 30.0,
                      ),
                      onPressed: onLeadingPressed ??
                              () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FeedPage(),
                              ),
                            );
                          },
                    ),
                  ),
                if (isCentered)
                  Expanded(
                    child: Center(
                      child: Text(
                        title,
                        style: AppTypography.title.copyWith(color: titleColor),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        title,
                        style: AppTypography.title.copyWith(color: titleColor),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                if (trailingIcon != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: IconButton(
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
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70.0);
}