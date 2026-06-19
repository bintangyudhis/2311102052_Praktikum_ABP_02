import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/cart_cubit.dart';
import 'pages/product_page.dart';

void main() => runApp(const ProductApp());

class ProductApp extends StatelessWidget {
  const ProductApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CartCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Katalog Kita',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF8F7FC),
          cardTheme: const CardThemeData(elevation: 0, margin: EdgeInsets.zero),
        ),
        home: const ProductPage(),
      ),
    );
  }
}
