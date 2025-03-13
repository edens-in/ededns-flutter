import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/app_theme.dart';
import '../bloc/banner/banner_bloc.dart';
import '../bloc/banner/banner_event.dart';
import '../bloc/banner/banner_state.dart';

class PromotionalBanner extends StatefulWidget {
  const PromotionalBanner({Key? key}) : super(key: key);

  @override
  State<PromotionalBanner> createState() => _PromotionalBannerState();
}

class _PromotionalBannerState extends State<PromotionalBanner> {
  final PageController _pageController = PageController();
  late final BannerBloc _bannerBloc;

  // Define promotional items
  static final List<PromotionalItem> promotionalItems = [
    PromotionalItem(
      title: 'Summer Sale',
      subtitle: 'sale on all products',
      buttonText: 'View Deals',
      overlayColor: Colors.black.withOpacity(0.2),
      networkImageUrl: 'https://plus.unsplash.com/premium_photo-1668896123844-be3aec7a4776?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8c3VtbWVyJTIwZmFzaGlvbnxlbnwwfHwwfHx8MA%3D%3D',
    ),
    // Gradient card (original design)
    PromotionalItem(
      title: 'Summer Sale',
      subtitle: 'Up to 50% off',
      buttonText: 'Shop Now',
      gradientColors: [
        AppTheme.primaryColor,
        AppTheme.primaryVariantColor,
      ],
      icon: Icons.shopping_bag_outlined,
    ),
    // Image-based card from internet
    PromotionalItem(
      title: 'New Collection',
      subtitle: 'Discover the latest trends',
      buttonText: 'Explore',
      networkImageUrl: 'https://plus.unsplash.com/premium_photo-1683817138481-dcdf64a40859?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8ZmFzaGlvbnxlbnwwfDB8MHx8fDA%3D',
      overlayColor: Colors.black.withOpacity(0.4),
    ),
    // Another gradient card
    PromotionalItem(
      title: 'Premium Electronics',
      subtitle: 'Free shipping on orders over \$100',
      buttonText: 'View Deals',
      overlayColor: Colors.black.withOpacity(0.3),
      networkImageUrl: 'https://images.unsplash.com/photo-1588508065123-287b28e013da?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTF8fGVsZWN0cm9uaWNzfGVufDB8fDB8fHww',
    ),
    // Another network image card
    PromotionalItem(
      title: 'Home Decor',
      subtitle: 'Transform your space',
      buttonText: 'Discover',
      networkImageUrl: 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3',
      overlayColor: Colors.black.withOpacity(0.3),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _bannerBloc = BannerBloc(itemCount: promotionalItems.length);

    // Listen to banner state changes to update page controller
    _bannerBloc.stream.listen((state) {
      if (_pageController.hasClients && 
          _pageController.page?.round() != state.currentPage) {
        _pageController.animateToPage(
          state.currentPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _bannerBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    print("banner build -------------------------");
    return BlocProvider.value(
      value: _bannerBloc,
      child: BlocBuilder<BannerBloc, BannerState>(
        builder: (context, state) {
          return Column(
            children: [
              GestureDetector(
                onPanDown: (_) {
                  context.read<BannerBloc>().add(BannerAutoPlayToggled(false));
                },
                onPanCancel: () {
                  context.read<BannerBloc>().add(BannerAutoPlayToggled(true));
                },
                onPanEnd: (_) {
                  context.read<BannerBloc>().add(BannerAutoPlayToggled(true));
                },
                child: Container(
                  height: MediaQuery.of(context).size.width - 32,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8.0),
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: promotionalItems.length,
                    onPageChanged: (index) {
                      context.read<BannerBloc>().add(BannerPageChanged(index));
                    },
                    itemBuilder: (context, index) {
                      final item = promotionalItems[index];
                      return _buildPromotionalCard(context, item, isDark);
                    },
                  ),
                ),
              ),
              
              // Carousel indicators
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    promotionalItems.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 6,
                      width: state.currentPage == index ? 30 : 6,
                      decoration: BoxDecoration(
                        color: state.currentPage == index 
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.primary.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPromotionalCard(BuildContext context, PromotionalItem item, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(12),
        gradient: item.gradientColors != null 
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: item.gradientColors!,
              )
            : null,
        image: item.backgroundImageUrl != null
            ? DecorationImage(
                image: AssetImage(item.backgroundImageUrl!),
                fit: BoxFit.cover,
              )
            : item.networkImageUrl != null
                ? DecorationImage(
                    image: NetworkImage(item.networkImageUrl!),
                    fit: BoxFit.cover,
                  )
                : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Overlay for image-based promotions
          if ((item.overlayColor != null) && 
              (item.backgroundImageUrl != null || item.networkImageUrl != null))
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(12),
                  color: item.overlayColor,
                ),
              ),
            ),
            
          // Background icon
          if (item.icon != null)
            Positioned(
              right: -20,
              bottom: -20,
              child: Icon(
                item.icon,
                size: 150,
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            
          // Content
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.subtitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Navigate to items
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? Colors.grey[900] : Colors.white,
                    foregroundColor: item.gradientColors != null 
                        ? item.gradientColors![0] 
                        : AppTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: Text(item.buttonText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PromotionalItem {
  final String title;
  final String subtitle;
  final String buttonText;
  final List<Color>? gradientColors;
  final String? backgroundImageUrl; // For asset images
  final String? networkImageUrl;    // For network images
  final IconData? icon;
  final Color? overlayColor;

  PromotionalItem({
    required this.title,
    required this.subtitle,
    required this.buttonText,
    this.gradientColors,
    this.backgroundImageUrl,
    this.networkImageUrl,
    this.icon,
    this.overlayColor,
  }) : assert(
         (gradientColors != null) || (backgroundImageUrl != null) || (networkImageUrl != null),
         'Either gradientColors, backgroundImageUrl, or networkImageUrl must be provided'
       );
} 