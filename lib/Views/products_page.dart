import 'package:ecommerce_admin_app/models/productsModel.dart';
import 'package:ecommerce_admin_app/providers/adminProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: Consumer<Adminprovider>(
        builder: (context, value, child) {
          List<Productsmodel> products = Productsmodel.fromSnapshotList(
            value.products,
          );

          // if (value.products.isEmpty) {
          //   return const Center(child: Text('No Products'));
          // }

          return ListView.builder(
            itemCount: value.products.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  products[index].name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text("Rs ${products[index].new_Price.toString()}"),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/modifyproduct');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
