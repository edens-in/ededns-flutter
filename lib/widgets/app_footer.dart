import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/theme/theme_bloc.dart';
import '../bloc/theme/theme_state.dart' show ThemeState, ThemeType;

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        final isDark = themeState.themeType == ThemeType.dark;
        final theme = Theme.of(context);
        
        return Container(
          margin: const EdgeInsets.only(top: 100),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: isDark ? Colors.black : Colors.white,
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Branding & Description
              Row(
                children: [
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: Image.asset(
                      isDark ? 'assets/images/logo-dark.png' : 'assets/images/logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    "eden's",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Text(
                "Welcome to Eden's, your go-to e-commerce store for quality products, great deals, and a seamless shopping experience. Shop now!",
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black87,
                  fontSize: 14,
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 16.0),
              // Newsletter Subscription
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
                          hintText: "Type your email address",
                          hintStyle: TextStyle(
                            color: isDark ? Colors.white54 : Colors.black54,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                        ),
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? Colors.white : Colors.black,
                        foregroundColor: isDark ? Colors.black : Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "Submit",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32.0),
              // Links Sections with Horizontal Scroll
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFooterSection(
                      isDark,
                      "POPULAR",
                      ["Shoes", "T-Shirt", "Jackets", "Hat", "Accessories"],
                    ),
                    const SizedBox(width: 24.0),
                    _buildFooterSection(
                      isDark,
                      "MENU",
                      ["All Category", "Gift Cards", "Special Events", "Testimonial", "Blog"],
                    ),
                    const SizedBox(width: 24.0),
                    _buildFooterSection(
                      isDark,
                      "OTHER",
                      ["Tracking Package", "FAQ", "About Us", "Contact Us", "Terms and Conditions"],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              // Copyright
              Text(
                "© 2025 Eden\'s. All Rights Reserved.",
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black54,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 150),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFooterSection(bool isDark, String title, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              item,
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black87,
                fontSize: 14,
              ),
            ),
          )),
        ],
      ),
    );
  }
}
