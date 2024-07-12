import 'package:dars_15/cubits/todo/product_cubit.dart';
import 'package:dars_15/ui/screens/products_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) {
          return ProductCubit();
        }),
      ],
      child: MaterialApp(
        darkTheme: ThemeData.dark(),
        theme: ThemeData.light(),
        debugShowCheckedModeBanner: false,
        home: const ProductsScreen(),
      ),
    );
  }
}
