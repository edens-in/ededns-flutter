import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FeaturedProducts extends StatelessWidget {
  const FeaturedProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Sample featured products
    final products = [
      {
        'name': 'Nike Air Force 1',
        'price': '\$225',
        'image': 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=1000&auto=format&fit=crop',
        'rating': 4.8,
        'type': 'casual',
        'isWide': false,
        'isHot': true,
      },
      {
        'name': 'New Balance 550',
        'price': '\$125',
        'image': 'https://images.unsplash.com/photo-1539185441755-769473a23570?q=80&w=1000&auto=format&fit=crop',
        'rating': 4.5,
        'type': 'skateboard',
        'isWide': true,
        'isHot': true,
      },
      {
        'name': 'Air Jordan 1 Off-White',
        'price': '\$125',
        'image': 'https://images.unsplash.com/photo-1600269452121-4f2416e55c28?q=80&w=1000&auto=format&fit=crop',
        'rating': 4.9,
        'type': 'skateboard',
        'isWide': false,
        'isHot': true,
      },
    ];

    return SizedBox(
      height: MediaQuery.sizeOf(context).width/2 ,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final product = products[index];
          final isWide = product['isWide'] as bool;
          final isHot = product['isHot'] as bool;
          return Container(
            width: isWide ? MediaQuery.sizeOf(context).width * 0.7: MediaQuery.sizeOf(context).width/2 - 32 ,
            margin: const EdgeInsets.only(right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product image and favorite button
                Expanded(
                  child: Stack(
                    children: [
                      // Product image
                      Container(
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[800] : Colors.grey[200],
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: NetworkImage(product['image'] as String),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Favorite button
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.favorite_border,
                            size: 20,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                      if (isHot)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(15),
                                topLeft: Radius.circular(7),
                                ),
                            ),
                            child: const Text('Hot Seller', style: TextStyle(color: Colors.white, fontSize: 12),),
                          ),
                        ),                      
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                // Product info
                Text(
                  product['name'] as String,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: theme.textTheme.titleMedium?.color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product['price'] as String,
                      style: TextStyle(
                        // color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                        // fontSize: 18,
                      ),
                    ),
                    Spacer(),
                    Text(
                      product['type'] as String,
                      style: TextStyle(
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 4,),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
} 