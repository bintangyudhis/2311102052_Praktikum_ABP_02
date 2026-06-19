import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/cart_cubit.dart';
import '../models/product.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  String _rupiah(int value) {
    final text = value.toString();
    final result = StringBuffer();
    for (var i = 0; i < text.length; i++) {
      if (i > 0 && (text.length - i) % 3 == 0) result.write('.');
      result.write(text[i]);
    }
    return 'Rp$result';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Katalog Kita', style: TextStyle(fontWeight: FontWeight.w800)),
            Text('Temukan barang favoritmu', style: TextStyle(fontSize: 12)),
          ],
        ),
        actions: [
          BlocBuilder<CartCubit, List<Product>>(
            builder: (context, cart) => Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Badge(
                key: const Key('cart-badge'),
                label: Text('${cart.length}'),
                isLabelVisible: cart.isNotEmpty,
                child: IconButton.filledTonal(
                  tooltip: 'Keranjang (${cart.length} item)',
                  onPressed: () => _showCart(context),
                  icon: const Icon(Icons.shopping_bag_outlined),
                ),
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<CartCubit, List<Product>>(
        builder: (context, cart) {
          final cubit = context.read<CartCubit>();
          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 360,
              mainAxisExtent: 282,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final quantity = cubit.quantityOf(product);
              return Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 104,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: product.color,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(product.icon, size: 52),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        product.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _rupiah(product.price),
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          if (quantity > 0) ...[
                            IconButton.outlined(
                              key: Key('remove-${product.id}'),
                              constraints: const BoxConstraints.tightFor(
                                width: 36,
                                height: 36,
                              ),
                              padding: EdgeInsets.zero,
                              onPressed: () => cubit.removeProduct(product),
                              icon: const Icon(Icons.remove, size: 18),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Text(
                                '$quantity',
                                key: Key('quantity-${product.id}'),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                          IconButton.filled(
                            key: Key('add-${product.id}'),
                            tooltip: 'Tambah ${product.name}',
                            constraints: const BoxConstraints.tightFor(
                              width: 36,
                              height: 36,
                            ),
                            padding: EdgeInsets.zero,
                            onPressed: () => cubit.addProduct(product),
                            icon: const Icon(Icons.add, size: 19),
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
      ),
      bottomNavigationBar: BlocBuilder<CartCubit, List<Product>>(
        builder: (context, cart) => Container(
          padding: const EdgeInsets.fromLTRB(20, 13, 20, 18),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: const [
              BoxShadow(color: Color(0x18000000), blurRadius: 16),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.shopping_cart_outlined),
              const SizedBox(width: 10),
              Text(
                '${cart.length} item',
                key: const Key('cart-count'),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              Text(
                _rupiah(context.read<CartCubit>().totalPrice),
                key: const Key('cart-total'),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCart(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => BlocProvider.value(
        value: context.read<CartCubit>(),
        child: BlocBuilder<CartCubit, List<Product>>(
          builder: (context, cart) => Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
            child: cart.isEmpty
                ? const SizedBox(
                    height: 180,
                    child: Center(child: Text('Keranjang masih kosong')),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Keranjang (${cart.length} item)',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...products.where((p) => cart.contains(p)).map((product) {
                        final quantity = context.read<CartCubit>().quantityOf(
                          product,
                        );
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor: product.color,
                            child: Icon(product.icon, size: 21),
                          ),
                          title: Text(product.name),
                          subtitle: Text(
                            '$quantity x ${_rupiah(product.price)}',
                          ),
                          trailing: IconButton(
                            tooltip: 'Hapus satu ${product.name}',
                            onPressed: () => context
                                .read<CartCubit>()
                                .removeProduct(product),
                            icon: const Icon(Icons.delete_outline),
                          ),
                        );
                      }),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
