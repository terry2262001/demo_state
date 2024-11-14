import 'package:flutter/material.dart';
import 'package:prostate/prostate.dart';

import '../screen/cart_screen.dart';
import 'models/CartItem.dart';
import 'models/Product.dart';

class ProductsScreen extends StatelessWidget {
  final List<Product> defaultProducts = [
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

  Future<List<Product>> getFakeApiProducts() async {
    await Future.delayed(const Duration(seconds: 2));
    return [
      Product(
          id: '1', name: 'Product A', price: 100, description: 'Description A'),
      Product(
          id: '2', name: 'Product B', price: 150, description: 'Description B'),
      Product(
          id: '3', name: 'Product C', price: 200, description: 'Description C'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final stateManager = StateProvider.of(context);

    // Initialize states if not exists
    if (stateManager.getState<bool>('isApiMode') == null) {
      stateManager.setState<bool>('isApiMode', false);
    }
    if (stateManager.getState<bool>('isLoading') == null) {
      stateManager.setState<bool>('isLoading', false);
    }
    if (stateManager.getState<List<Product>>('products') == null) {
      stateManager.setState<List<Product>>('products', defaultProducts);
    }
    if (stateManager.getState<Map<String, CartItem>>('cart') == null) {
      stateManager.setState<Map<String, CartItem>>('cart', {});
    }

    void toggleDataSource() async {
      final isApiMode = stateManager.getState<bool>('isApiMode') ?? false;
      stateManager.setState<bool>('isApiMode', !isApiMode);
      stateManager.setState<bool>('isLoading', true);
      stateManager.setState<Map<String, CartItem>>('cart', {}); // Reset cart

      if (!isApiMode) {
        // Switching to API mode
        await stateManager.setStateAsync<List<Product>>(
            'products', getFakeApiProducts());
      } else {
        // Switching to default mode
        stateManager.setState<List<Product>>('products', defaultProducts);
      }

      stateManager.setState<bool>('isLoading', false);
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
                    ) ??
                    0;

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
        body: Column(
          children: [
            // Data source toggle section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Use Fake API',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 16),
                  StateBuilder<bool>(
                    stateKey: 'isApiMode',
                    builder: (context, isApiMode) {
                      return Switch(
                        value: isApiMode ?? false,
                        onChanged: (_) => toggleDataSource(),
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: StateBuilder<bool>(
                stateKey: 'isLoading',
                builder: (context, isLoading) {
                  if (isLoading == true) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return StateBuilder<List<Product>>(
                    stateKey: 'products',
                    builder: (context, products) {
                      if (products == null || products.isEmpty) {
                        return const Center(
                            child: Text('No products available'));
                      }

                      return ListView.builder(
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
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    product.description,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '\$${product.price.toStringAsFixed(2)}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      StateBuilder<Map<String, CartItem>>(
                                        stateKey: 'cart',
                                        builder: (context, cart) {
                                          final quantity =
                                              cart?[product.id]?.quantity ?? 0;
                                          return Row(
                                            children: [
                                              if (quantity > 0) ...[
                                                IconButton(
                                                  icon:
                                                      const Icon(Icons.remove),
                                                  onPressed: () {
                                                    final currentCart = Map<
                                                        String, CartItem>.from(
                                                      cart ?? {},
                                                    );
                                                    if (quantity > 1) {
                                                      currentCart[product.id] =
                                                          CartItem(
                                                        product: product,
                                                        quantity: quantity - 1,
                                                      );
                                                    } else {
                                                      currentCart
                                                          .remove(product.id);
                                                    }
                                                    stateManager.setState(
                                                        'cart', currentCart);
                                                  },
                                                ),
                                                Text('$quantity'),
                                              ],
                                              IconButton(
                                                icon: const Icon(Icons.add),
                                                onPressed: () {
                                                  final currentCart = Map<
                                                      String, CartItem>.from(
                                                    cart ?? {},
                                                  );
                                                  currentCart[product.id] =
                                                      CartItem(
                                                    product: product,
                                                    quantity: quantity + 1,
                                                  );
                                                  stateManager.setState(
                                                      'cart', currentCart);
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
                      );
                    },
                  );
                },
              ),
            )
          ],
        ));
  }
}
