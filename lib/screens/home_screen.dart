import 'package:edens/widgets/app_footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/home/home_bloc.dart';
import '../bloc/home/home_event.dart';
import '../bloc/home/home_state.dart';
import '../bloc/theme/theme_bloc.dart';
import '../bloc/theme/theme_state.dart' show ThemeState, ThemeType;
import '../bloc/search/search_bloc.dart';
import '../widgets/featured_products.dart';
import '../widgets/category_list.dart';
import '../widgets/promotional_banner.dart';
import '../widgets/fashion_categories_showcase.dart';
import '../widgets/search_section.dart';
import '../theme/app_theme.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  late HomeBloc _homeBloc;
  late SearchBloc _searchBloc;

  @override
  void initState() {
    super.initState();
    _homeBloc = HomeBloc()..add(LoadHomeData());
    _searchBloc = SearchBloc();
  }

  @override
  void dispose() {
    _homeBloc.close();
    _searchBloc.close();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  void _handleSearch(String query) {
    if (query.isNotEmpty) {
      // Navigate to search screen with the query
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchScreen(initialQuery: query),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    
    final textTheme = Theme.of(context).textTheme;
    
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _homeBloc),
        BlocProvider.value(value: _searchBloc),
      ],
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Delivery to',
                    style: textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'New York, NY 10001',
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 18,
                    color: Colors.grey,
                  ),
                ],
              ),
            ],
          ),
          leading: Padding(
            padding: const EdgeInsets.all(10.0),
            child: BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, themeState) {
                // Choose logo based on theme mode
                final String logoPath = themeState.themeType == ThemeType.dark 
                    ? 'assets/images/logo-dark.png'
                    : 'assets/images/logo.png';
                
                return Image.asset(
                  logoPath,
                  fit: BoxFit.contain,
                );
              },
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
              },
              icon: const Icon(Icons.favorite_outline),
            ),
            Stack(
              children: [
                Positioned(
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Text(
                      "1", 
                      style: TextStyle(
                        color: Colors.black, 
                        fontSize: 10, 
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
                  },
                  icon: const Icon(Icons.notifications_none_rounded),
                ),
              ],
            ),
          ],
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state.status == HomeStatus.initial) {
              // Trigger loading when in initial state
              return const Center(child: CircularProgressIndicator());
            }
            
            if (state.status == HomeStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (state.status == HomeStatus.error) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Failed to load data'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        _homeBloc.add(LoadHomeData());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            
            // Success state
            return RefreshIndicator(
              onRefresh: () async {
                _homeBloc.add(LoadHomeData());
                await Future.delayed(const Duration(seconds: 1));
              },
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    
                    // Original content
                    const PromotionalBanner(),
                    const SizedBox(height: 16),

                    // Search section above categories
                    SearchSection(
                      onSearch: _handleSearch,
                    ),
                    const SizedBox(height: 24),
                    const FashionCategoriesShowcase(),
                    const SizedBox(height: 24),
                    
                    // Categories
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Categories',
                            style: textTheme.titleLarge,
                          ),
                          TextButton(
                            onPressed: () {
                              // View all categories
                            },
                            child: Text(
                              'View All',
                              style: TextStyle(
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const CategoryList(),
                    const SizedBox(height: 24),
                    
                    // Featured Products
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Featured Products',
                            style: textTheme.titleLarge,
                          ),
                          TextButton(
                            onPressed: () {
                              // View all featured products
                            },
                            child: Text(
                              'View All',
                              style: TextStyle(
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const FeaturedProducts(),
                    const SizedBox(height: 16),
                    
                    // New Arrivals
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'New Arrivals',
                            style: textTheme.titleLarge,
                          ),
                          TextButton(
                            onPressed: () {
                              // View all new arrivals
                            },
                            child: Text(
                              'View All',
                              style: TextStyle(
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const FeaturedProducts(),
                    AppFooter(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
} 