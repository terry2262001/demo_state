import 'package:flutter/material.dart';
import 'package:prostate/prostate.dart';
import '../src/models/CartItem.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stateManager = StateProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        actions: [
          // Clear cart button
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              stateManager.setState<Map<String, CartItem>>('cart', {});
            },
          ),
        ],
      ),
      body: StateBuilder<Map<String, CartItem>>(
        stateKey: 'cart',
        builder: (context, cart) {
          if (cart == null || cart.isEmpty) {
            return const Center(
              child: Text('Your cart is empty'),
            );
          }

          final items = cart.values.toList();
          final total = items.fold<double>(
            0,
                (sum, item) => sum + item.total,
          );

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ListTile(
                      title: Text(item.product.name),
                      subtitle: Text(
                        '${item.quantity} x \$${item.product.price.toStringAsFixed(2)}',
                      ),
                      trailing: Text(
                        '\$${item.total.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$${total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}