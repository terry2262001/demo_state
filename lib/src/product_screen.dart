import 'package:flutter/material.dart';
import 'package:prostate/prostate.dart';

import '../screen/cart_screen.dart';
import 'models/CartItem.dart';
import 'models/Product.dart';

class ProductsScreen extends StatelessWidget {
  final List<Product> products = [
    Product(
      id: '1',
      name: 'SamSung Z Fold 6',
      price: 2000,
      description: 'Powerful laptop for your needs',
    ),
    Product(
      id: '2',
      name: 'Google Pixel 9 Pro',
      price: 3000,
      description: 'Latest smartphone model',
    ),
    Product(
      id: '3',
      name: 'Apple Iphone 16 Pro Max',
      price: 5000,
      description: 'High-quality wireless headphones',
    ),
  ];

  ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stateManager = StateProvider.of(context);

    // Initialize cart state if not exists
    if (stateManager.getState<Map<String, CartItem>>('cart') == null) {
      stateManager.setState<Map<String, CartItem>>('cart', {});
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          // Cart icon with item count
          StateBuilder<Map<String, CartItem>>(
            stateKey: 'cart',
            builder: (context, cart) {
              final itemCount = cart?.values.fold<int>(
                0,
                    (sum, item) => sum + item.quantity,
              ) ?? 0;

              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartScreen(),
                        ),
                      );
                    },
                  ),
                  if (itemCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 20,
                          minHeight: 20,
                        ),
                        child: Text(
                          '$itemCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      // Add to cart button with quantity
                      StateBuilder<Map<String, CartItem>>(
                        stateKey: 'cart',
                        builder: (context, cart) {
                          final quantity = cart?[product.id]?.quantity ?? 0;
                          return Row(
                            children: [
                              if (quantity > 0) ...[
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    final currentCart = Map<String, CartItem>.from(
                                      cart ?? {},
                                    );
                                    if (quantity > 1) {
                                      currentCart[product.id] = CartItem(
                                        product: product,
                                        quantity: quantity - 1,
                                      );
                                    } else {
                                      currentCart.remove(product.id);
                                    }
                                    stateManager.setState('cart', currentCart);
                                  },
                                ),
                                Text('$quantity'),
                              ],
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  final currentCart = Map<String, CartItem>.from(
                                    cart ?? {},
                                  );
                                  currentCart[product.id] = CartItem(
                                    product: product,
                                    quantity: quantity + 1,
                                  );
                                  stateManager.setState('cart', currentCart);
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

