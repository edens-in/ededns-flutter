import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AuthHeader extends StatelessWidget {
  final bool isLargeScreen;
  final List<String> navItems;
  final VoidCallback? onMenuPressed;

  const AuthHeader({
    Key? key,
    required this.isLargeScreen,
    this.navItems = const ['Tracking Package', 'FAQ', 'About Us', 'Contact Us'],
    this.onMenuPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Text(
            'Eden\'s',
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          if (isLargeScreen) 
            ...navItems.map((title) => _buildNavItem(title))
          else
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.black87),
              onPressed: onMenuPressed ?? () {
                // Default menu action
              },
            ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          foregroundColor: Colors.black87,
          backgroundColor: Colors.transparent,
        ),
        child: Text(title),
      ),
    );
  }
} 