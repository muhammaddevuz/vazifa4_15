import 'dart:io';

import 'package:dars_15/cubits/todo/product_cubit.dart';
import 'package:dars_15/cubits/todo/product_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final titleController = TextEditingController();
  File? imageFile;
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      context.read<ProductCubit>().getProducts();
    });
  }

  void openCamera() async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
        source: ImageSource.camera,
        requestFullMetadata: false,
        imageQuality: 50);
    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        centerTitle: true,
      ),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is InitialState) {
            return const Center(
              child: Text("Ma'lumot hali yuklanmadi"),
            );
          }

          if (state is LoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ErrorState) {
            return Center(
              child: Text(state.message),
            );
          }

          final products = (state as LoadedState).products;
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisExtent: 280),
            itemCount: products.length,
            itemBuilder: (ctx, index) {
              final product = products[index];
              return InkWell(
                onTap: () {
                  titleController.text = product.title;
                  imageFile = product.imageFile;
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Add Product"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: titleController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Enter title",
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  openCamera();
                                },
                                label: const Text("Camera"),
                                icon: const Icon(
                                  Icons.camera,
                                ),
                              ),
                              if (imageFile != null)
                                Container(
                                  height: 200,
                                  width: 200,
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Image.file(
                                    imageFile!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                            ],
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  titleController.clear();
                                  imageFile = null;
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel")),
                            TextButton(
                              onPressed: () {
                                if (imageFile != null) {
                                  context.read<ProductCubit>().editProduct(
                                      product.id,
                                      titleController.text,
                                      imageFile!);
                                  imageFile = null;
                                  titleController.clear();
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text("Edit Product"),
                            ),
                          ],
                        );
                      });
                },
                onLongPress: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Delete Product"),
                          content: const Text(
                              "Are you sure you want to delete this product?"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel")),
                            TextButton(
                                onPressed: () {
                                  context
                                      .read<ProductCubit>()
                                      .deleteProduct(product.id);
                                  Navigator.pop(context);
                                },
                                child: const Text("Delete")),
                          ],
                        );
                      });
                },
                child: Card(
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                        height: 170,
                        width: 170,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.file(
                          product.imageFile,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        product.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          product.isFavorite
                              ? IconButton(
                                  onPressed: () {
                                    context
                                        .read<ProductCubit>()
                                        .changeFavorite(product.id);
                                  },
                                  icon: const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  ),
                                )
                              : IconButton(
                                  onPressed: () {
                                    context
                                        .read<ProductCubit>()
                                        .changeFavorite(product.id);
                                  },
                                  icon: const Icon(
                                    Icons.favorite_border,
                                    color: Colors.grey,
                                  ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Add Product"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter title",
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        openCamera();
                      },
                      label: const Text("Camera"),
                      icon: const Icon(
                        Icons.camera,
                      ),
                    ),
                    if (imageFile != null)
                      Container(
                        height: 200,
                        width: 200,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.file(
                          imageFile!,
                          fit: BoxFit.cover,
                        ),
                      ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      if (imageFile != null) {
                        context.read<ProductCubit>().addProduct(
                            UniqueKey().toString(),
                            titleController.text,
                            imageFile!);
                        imageFile = null;
                        titleController.clear();
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Add Product"),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
