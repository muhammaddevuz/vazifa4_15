import 'package:dars_15/cubits/todo/todo_cubit.dart';
import 'package:dars_15/examples/counter/counter_cubit.dart';
import 'package:dars_15/ui/screens/todo_screen.dart';
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
          return CounterCubit();
        }),
        BlocProvider(create: (context) {
          return TodoCubit();
        }),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: TodoScreen(),
      ),
    );
  }
}
