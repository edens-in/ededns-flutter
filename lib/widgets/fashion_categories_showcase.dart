import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:flutter/foundation.dart';

class FashionCategoriesShowcase extends StatelessWidget {
  const FashionCategoriesShowcase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fashion Categories',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // First row: Large card on left, two small cards stacked on right
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Large card (top left)
              Expanded(
                flex: 3,
                child: _buildMainCard(
                  context,
                  title: 'Color of Summer',
                  subtitle: '100+ Collections for your outfit inspirations',
                  imagePath: 'https://images.unsplash.com/photo-1686328266442-0ccc963402cf?q=80&w=1972&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                  isNetworkImage: true,
                  isDarkMode: isDarkMode,
                  height: 320,
                  buttonText: 'VIEW COLLECTIONS',
                ),
              ),
              const SizedBox(width: 12),
              // Two stacked cards (top right)
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    _buildCard(
                      context,
                      title: 'Outdoor Active',
                      backgroundColor: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                      imagePath: 'https://images.unsplash.com/photo-1571008887538-b36bb32f4571?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                      isNetworkImage: true,
                      isDarkMode: isDarkMode,
                      height: 154,
                    ),
                    const SizedBox(height: 12),
                    _buildCard(
                      context,
                      title: 'Casual Comfort',
                      backgroundColor: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
                      imagePath: 'https://plus.unsplash.com/premium_photo-1661775840732-62311b0691bf?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8Y2FzdWFsJTIwZmFzaGlvbnxlbnwwfHwwfHx8MA%3D%3D',
                      isNetworkImage: true,
                      isDarkMode: isDarkMode,
                      height: 154,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Second row: Small card on left, large card on right
          Row(
            children: [
              // Small card (bottom left)
              Expanded(
                flex: 2,
                child: _buildCard(
                  context,
                  title: 'Say it with Shirt',
                  backgroundColor: isDarkMode ? Colors.green[800]! : Colors.green[200]!,
                  imagePath: 'https://images.unsplash.com/photo-1527628217451-b2414a1ee733?q=80&w=1587&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                  isNetworkImage: true,
                  isDarkMode: isDarkMode,
                  height: 154,
                ),
              ),
              const SizedBox(width: 12),
              // Large card (bottom right)
              Expanded(
                flex: 3,
                child: _buildCard(
                  context, 
                  title: 'Funky Style',
                  subtitle: 'Bold & colorful fashion that never gets old',
                  backgroundColor: isDarkMode ? Colors.purple[800]! : Colors.purple[200]!,
                  imagePath: 'https://images.unsplash.com/photo-1509631179647-0177331693ae?q=80&w=1288&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                  isNetworkImage: true,
                  isDarkMode: isDarkMode,
                  height: 154,
                  showArrow: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String imagePath,
    required bool isDarkMode,
    required double height,
    required String buttonText,
    bool isNetworkImage = false,
  }) {
    final textTheme = Theme.of(context).textTheme;
    
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: _buildImageWithFallback(
              imagePath,
              isNetworkImage: isNetworkImage,
              fit: BoxFit.cover,
              placeholder: Container(
                color: isDarkMode ? Colors.grey[800] : const Color(0xFFA9B496),
                child: const Center(
                  child: Icon(Icons.image, size: 40, color: Colors.white30),
                ),
              ),
            ),
          ),
          
          // Black overlay for text readability
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(1, 1),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(1, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
                // const SizedBox(height: 16),
                Spacer(),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 3,
                  ),
                  child: Text(buttonText, style: TextStyle(fontSize: 10,),),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCard(
    BuildContext context, {
    required String title,
    String? subtitle,
    required Color backgroundColor,
    String? imagePath,
    required bool isDarkMode,
    required double height,
    bool showArrow = false,
    bool isNetworkImage = false,
  }) {
    final textTheme = Theme.of(context).textTheme;
    // final textColor = _isColorDark(backgroundColor) ? Colors.white : Colors.black87;
    final textColor = Colors.white;
    
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background image
          if (imagePath != null)
            Positioned.fill(
              child: _buildImageWithFallback(
                imagePath,
                isNetworkImage: isNetworkImage,
                fit: BoxFit.cover,
                placeholder: Container(
                  color: backgroundColor,
                  child: Center(
                    child: Icon(Icons.image, size: 30, color: textColor.withOpacity(0.3)),
                  ),
                ),
              ),
            ),
            
          // Black overlay for text readability
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.titleMedium?.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.2),
                            offset: const Offset(0.5, 0.5),
                            blurRadius: 1,
                          ),
                        ],
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: textTheme.bodySmall?.copyWith(
                          color: textColor.withOpacity(0.7),
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.2),
                              offset: const Offset(0.5, 0.5),
                              blurRadius: 1,
                            ),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
                if (showArrow)
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: textColor.withOpacity(0.1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.arrow_forward,
                      color: textColor,
                      size: 16,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper method to handle image loading with fallback
  Widget _buildImageWithFallback(
    String imagePath, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    required Widget placeholder,
    bool isNetworkImage = false,
  }) {
    if (isNetworkImage) {
      // Handle network images
      return Image.network(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        // Add caching for better performance
        cacheWidth: width?.toInt(),
        cacheHeight: height?.toInt(),
        // Show loading indicator while image loads
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return Container(
            width: width,
            height: height,
            color: Colors.transparent,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null,
                strokeWidth: 2,
                color: Theme.of(context).primaryColor,
              ),
            ),
          );
        },
        // Show placeholder on error
        errorBuilder: (context, error, stackTrace) {
          debugPrint('Error loading network image $imagePath: $error');
          // In debug mode, show more detailed error
          if (kDebugMode) {
            print('Stack trace: $stackTrace');
          }
          return placeholder;
        },
      );
    } else {
      // Handle asset images
      return Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('Error loading asset image $imagePath: $error');
          return placeholder;
        },
      );
    }
  }
  
  // Helper to determine if a color is dark
  bool _isColorDark(Color color) {
    return color.computeLuminance() < 0.5;
  }
}

class DiagonalLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width, 0);
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 