import 'dart:io';

import 'package:dars_15/cubits/todo/product_state.dart';
import 'package:dars_15/data/models/product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(InitialState());
  List<Product> products = [];

  Future<void> getProducts() async {
    try {
      emit(LoadingState());
      await Future.delayed(const Duration(seconds: 1));

      // throw("Xatolik");

      emit(LoadedState(products));
    } catch (e) {
      // ignore: avoid_print
      print("Xatolik sodir bo'ldi");
      emit(ErrorState("Rejalarni ololmadim"));
    }
  }

  Future<void> addProduct(String id, String title, File imageFile) async {
    try {
      if (state is LoadedState) {
        products = (state as LoadedState).products;
      }

      emit(LoadingState());
      await Future.delayed(const Duration(seconds: 1));
      // await ProductHttpService.getProducts();

      products.add(Product(id: id, title: title, imageFile: imageFile));
      emit(LoadedState(products));
    } catch (e) {
      // ignore: avoid_print
      print("Qo'shishda xatolik");
      emit(ErrorState("Qo'shishda xatolik"));
    }
  }

  Future<void> editProduct(String id, String newTitle, File imageFile) async {
    try {
      if (state is LoadedState) {
        products = (state as LoadedState).products;
      }

      emit(LoadingState());
      await Future.delayed(const Duration(seconds: 1));

      for (var product in products) {
        if (product.id == id) {
          product.title = newTitle;
          product.imageFile = imageFile;
          product.isFavorite = false;
        }
      }

      emit(LoadedState(products));
    } catch (e) {
      emit(ErrorState("Xatolik"));
    }
  }

  Future<void> deleteProduct(String id) async {
    if (state is LoadedState) {
      products = (state as LoadedState).products;
    }

    emit(LoadingState());
    await Future.delayed(const Duration(seconds: 1));

    products.removeWhere((product) {
      return product.id == id;
    });

    emit(LoadedState(products));
  }

  void changeFavorite(String id) {
    if (state is LoadedState) {
      products = (state as LoadedState).products;
    }

    for (var product in products) {
      if (product.id == id) {
        product.isFavorite = !product.isFavorite;
        break;
      }
    }

    emit(LoadedState(products));
  }
}
