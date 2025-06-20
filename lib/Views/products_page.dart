import 'package:ecommerce_admin_app/Container/additionalConfirm.dart';
import 'package:ecommerce_admin_app/controllers/db_service.dart';
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
          var totalProducts = value.products.length.toString();
          if (value.products.isEmpty) {
            return const Center(child: Text("No Products Found"));
          }
          return ListView.builder(
            itemCount: value.products.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: (){
                  Navigator.pushNamed(context, "/viewproduct",arguments: products[index]);
                },
                onLongPress: (){
                  showDialog(context: context, builder: (context) => AlertDialog(
                    title: Text("Choose What you want to delete"),
                    content: Text("Delete Cannot be undone"),
                    actions: [
                      TextButton(onPressed: (){
                        showDialog(context: context, builder: (context) =>
                         Additionalconfirm(
                             contentText: "Are You Suer you want to Delete the Product",
                             onNo: (){
                               Navigator.pop(context);
                             },
                             onYes: (){
                               DbService().deleteProducts(id: products[index].id);
                               Navigator.pop(context);
                               Navigator.pop(context);
                             })
                        );

                      }, child: Text("Delete Product")),
                      TextButton(onPressed: (){}, child: Text("Edit Product"))
                    ],
                  ));
                },
                leading: Container(height: 50,width: 50,
                  child: Image.network(products[index].image),
                ),
                title: Text(
                  products[index].name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Rs ${products[index].new_Price.toString()}"),
                    Container(padding : EdgeInsets.all(4),
                    color: Colors.green
                    ,child: Text(products[index].category.toUpperCase(),style: TextStyle(color: Colors.white),))
                  ],
                ),
                trailing: IconButton(onPressed:(){
                  Navigator.pushNamed(context, "/modifyproduct",arguments: products[index]);
                }, icon: Icon(Icons.edit_outlined)),
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
