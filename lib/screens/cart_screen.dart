import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with AutomaticKeepAliveClientMixin {
  // Sample cart items
  final List<Map<String, dynamic>> _cartItems = [
    {
      'id': 1,
      'name': 'Wireless Headphones',
      'price': 129.99,
      'quantity': 1,
      'image': 'headphones',
    },
    {
      'id': 2,
      'name': 'Smart Watch',
      'price': 199.99,
      'quantity': 1,
      'image': 'watch',
    },
    {
      'id': 3,
      'name': 'Running Shoes',
      'price': 89.99,
      'quantity': 2,
      'image': 'shoes',
    },
    {
      'id': 4,
      'name': 'Running Shoes',
      'price': 89.99,
      'quantity': 2,
      'image': 'shoes',
    },
    {
      'id': 5,
      'name': 'Running Shoes',
      'price': 89.99,
      'quantity': 2,
      'image': 'shoes',
    },
  ];

  @override
  bool get wantKeepAlive => true;

  double get _subtotal => _cartItems.fold(
        0,
        (sum, item) => sum + (item['price'] * item['quantity']),
      );

  double get _tax => _subtotal * 0.08; // 8% tax
  double get _shipping => _subtotal > 100 ? 0 : 10; // Free shipping over $100
  double get _total => _subtotal + _tax + _shipping;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Your cart', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            Text('\$ 27.40', style: TextStyle(fontSize: 14,),)
          ],
        ),
        centerTitle: false,
      ),
      body: _cartItems.isEmpty
          ? _buildEmptyCart()
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _cartItems.length,
                    itemBuilder: (context, index) {
                      final item = _cartItems[index];
                      return _buildCartItem(item);
                    },
                  ),
                ),
                _buildOrderSummary(),
              ],
            ),
    );
  }

  Widget _buildEmptyCart() {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: theme.colorScheme.onSurface.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Add items to your cart to start shopping',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Navigate to home or products page
            },
            child: const Text('Start Shopping'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(
                  _getIconForProduct(item['image']),
                  size: 40,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'],
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${item['price']}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildQuantityButton(
                        icon: Icons.remove,
                        onPressed: () {
                          if (item['quantity'] > 1) {
                            setState(() {
                              item['quantity']--;
                            });
                          } else {
                            _removeItem(item['id']);
                          }
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: theme.colorScheme.outline),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${item['quantity']}',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      _buildQuantityButton(
                        icon: Icons.add,
                        onPressed: () {
                          setState(() {
                            item['quantity']++;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              color: theme.colorScheme.error,
              onPressed: () => _removeItem(item['id']),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outline),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          icon,
          size: 16,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _buildSummaryRow('Subtotal', '\$${_subtotal.toStringAsFixed(2)}'),
          _buildSummaryRow('Tax (8%)', '\$${_tax.toStringAsFixed(2)}'),
          _buildSummaryRow(
            'Shipping',
            _shipping > 0 ? '\$${_shipping.toStringAsFixed(2)}' : 'Free',
          ),
          Divider(color: theme.colorScheme.outline, height: 24),
          _buildSummaryRow(
            'Total',
            '\$${_total.toStringAsFixed(2)}',
            isBold: true,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Proceed to checkout
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Proceed to Checkout'),
            ),
          ),
          SizedBox(
            height: 120,
          )
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: (isBold ? theme.textTheme.titleLarge : theme.textTheme.bodyLarge)?.copyWith(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: (isBold ? theme.textTheme.titleLarge : theme.textTheme.bodyLarge)?.copyWith(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isBold ? AppTheme.primaryColor : theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  void _removeItem(int id) {
    setState(() {
      _cartItems.removeWhere((item) => item['id'] == id);
    });
  }

  IconData _getIconForProduct(String type) {
    switch (type.toLowerCase()) {
      case 'headphones':
        return Icons.headphones;
      case 'watch':
        return Icons.watch;
      case 'shoes':
        return Icons.directions_run;
      default:
        return Icons.shopping_bag;
    }
  }
} 