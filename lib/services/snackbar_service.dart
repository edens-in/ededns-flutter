import 'package:flutter/material.dart';

class SnackbarService {
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = 
      GlobalKey<ScaffoldMessengerState>();

  static void showSnackBar({
    required String message,
    Color? backgroundColor,
    Color? textColor,
    IconData? icon,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    try {
      if (scaffoldMessengerKey.currentState == null) {
        debugPrint('SnackbarService: ScaffoldMessengerState is null');
        return;
      }
      
      // Get the current theme brightness
      final BuildContext? context = scaffoldMessengerKey.currentContext;
      final bool isDarkMode = context != null && 
          Theme.of(context).brightness == Brightness.dark;
      
      // Set default colors based on theme
      final Color defaultBackgroundColor = isDarkMode 
          ? Colors.white 
          : Colors.black87;
      
      final Color defaultTextColor = isDarkMode 
          ? Colors.black 
          : Colors.white;
      
      // Hide any existing snackbars
      scaffoldMessengerKey.currentState!.hideCurrentSnackBar();
      
      // Show the new snackbar
      scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: textColor ?? defaultTextColor),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(color: textColor ?? defaultTextColor),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
          backgroundColor: backgroundColor ?? defaultBackgroundColor,
          duration: duration,
          action: action != null 
              ? SnackBarAction(
                  label: action.label,
                  textColor: action.textColor ?? defaultTextColor,
                  onPressed: action.onPressed,
                )
              : null,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    } catch (e) {
      debugPrint('SnackbarService: Error showing snackbar: $e');
    }
  }
} 