import 'package:ecommerce_admin_app/controllers/db_service.dart';
import 'package:ecommerce_admin_app/models/productsModel.dart';
import 'package:ecommerce_admin_app/providers/adminProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModifyProduct extends StatefulWidget {
  const ModifyProduct({super.key});

  @override
  State<ModifyProduct> createState() => _ModifyProductState();
}

class _ModifyProductState extends State<ModifyProduct> {
  late String productId = "";
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController newPriceController = TextEditingController();
  TextEditingController oldPriceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController imageController = TextEditingController();

  //set data from arguments
  setData(Productsmodel data) {
    productId = data.id;
    nameController.text = data.name;
    descController.text = data.description;
    newPriceController.text = data.new_Price.toString();
    oldPriceController.text = data.old_Price.toString();
    quantityController.text = data.maxQuantity.toString();
    categoryController.text = data.category;
    imageController.text = data.image;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;
    if (arguments != null && arguments is Productsmodel) {
      setData(arguments);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(productId.isEmpty ? "Add Product" : "Edit Product"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    validator: (v) => v!.isEmpty ? "Enter Product Name" : null,
                    decoration: InputDecoration(
                      hintText: 'Product Name',
                      label: Text('Product Name'),
                      fillColor: Colors.deepPurple.shade50,
                      filled: true,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: oldPriceController,
                    validator: (v) => v!.isEmpty ? "Enter New Price" : null,
                    decoration: InputDecoration(
                      hintText: 'Original Price',
                      label: Text('Original Price'),
                      fillColor: Colors.deepPurple.shade50,
                      filled: true,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: newPriceController,
                    validator: (v) => v!.isEmpty ? "Enter Old Price" : null,
                    decoration: InputDecoration(
                      hintText: 'Sell Price',
                      label: Text('Sell Price'),
                      fillColor: Colors.deepPurple.shade50,
                      filled: true,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: quantityController,
                    validator: (v) => v!.isEmpty ? "Enter Quantity" : null,
                    decoration: InputDecoration(
                      hintText: 'Quantity',
                      label: Text('Quantity'),
                      fillColor: Colors.deepPurple.shade50,
                      filled: true,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: categoryController,
                    validator: (v) => v!.isEmpty ? "Select Category" : null,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: 'Category',
                      label: Text('Category'),
                      fillColor: Colors.deepPurple.shade50,
                      filled: true,
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: Text("Select Category : "),
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(height: 10),
                                  Consumer<Adminprovider>(
                                    builder:
                                        (context, value, child) =>
                                            SingleChildScrollView(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children:
                                                    value.categories
                                                        .map(
                                                          (e) => TextButton(
                                                            onPressed: () {
                                                              categoryController
                                                                      .text =
                                                                  e["name"];
                                                              setState(() {});
                                                              Navigator.pop(
                                                                context,
                                                              );
                                                            },
                                                            child: Text(
                                                              e["name"],
                                                            ),
                                                          ),
                                                        )
                                                        .toList(),
                                              ),
                                            ),
                                  ),
                                ],
                              ),
                            ),
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: descController,
                    validator: (v) => v!.isEmpty ? "Enter description" : null,
                    maxLines: 8,
                    decoration: InputDecoration(
                      hintText: 'Description',
                      label: Text('Description'),
                      fillColor: Colors.deepPurple.shade50,
                      filled: true,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: imageController,
                    validator: (v) => v!.isEmpty ? "Enter Image URL" : null,
                    decoration: InputDecoration(
                      hintText: 'Image URL',
                      label: Text('Image URL'),
                      fillColor: Colors.deepPurple.shade50,
                      filled: true,
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        Map<String, dynamic> data = {
                          "name": nameController.text,
                          "desc": descController.text,
                          "old_Price": int.parse(oldPriceController.text),
                          "new_Price": int.parse(newPriceController.text),
                          "maxQuantity": int.parse(quantityController.text),
                          "category": categoryController.text,
                          "image": imageController.text,
                        };

                        if (productId.isNotEmpty) {
                          await DbService().updateProducts(
                            id: productId,
                            data: data,
                          );
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Product Updated")),
                          );
                        } else {
                          await DbService().createProducts(data: data);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Product Added")),
                          );
                        }
                      }
                    },
                    child: Text(productId.isNotEmpty? "Update Product" : 'Add Product'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
