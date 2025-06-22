import 'package:ecommerce_admin_app/controllers/db_service.dart';
import 'package:ecommerce_admin_app/models/PromoModel.dart';
import 'package:ecommerce_admin_app/models/productsModel.dart';
import 'package:ecommerce_admin_app/providers/adminProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModifyPromo extends StatefulWidget {
  const ModifyPromo({super.key});

  @override
  State<ModifyPromo> createState() => _ModifyPromoState();
}

class _ModifyPromoState extends State<ModifyPromo> {
  late String promoId = "";
  final formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController imageController = TextEditingController();

  //set data from arguments
  setData(PromoBannersModel data) {
    promoId = data.Id;
    titleController.text = data.title;
    categoryController.text = data.category;
    imageController.text = data.image;
    setState(() {});
  }

  bool _isInitialized = false;
  bool _isPromo = true;
  String text = "";


  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(!_isInitialized) {
        final arguments = ModalRoute
            .of(context)
            ?.settings
            .arguments;
        if (arguments != null && arguments is Map<String, dynamic>) {
          if (arguments['detail'] is PromoBannersModel) {
            setData(arguments['detail']);
          }
          _isPromo = arguments["promo"] ?? true;
        }
        print(_isPromo);
        _isInitialized = true;
        setState(() {});
      }
    });
  }

  String _screenTitle() {
    final isNew = promoId.isEmpty;
    return _isPromo
        ? (isNew ? 'Add Promo'    : 'Update Promo')
        : (isNew ? 'Add Banner'   : 'Update Banner');
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(_screenTitle()),

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
                    controller: titleController,
                    validator: (v) => v!.isEmpty ? "This Cannot be Empty" : null,
                    decoration: InputDecoration(
                      hintText: 'Title',
                      label: Text('Title'),
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
                          "name": titleController.text,
                          "category": categoryController.text,
                          "image": imageController.text,
                        };

                        if (promoId.isNotEmpty) {
                          await DbService().updatePromos(
                            id: promoId,
                            data: data,
                            isPromo: _isPromo
                          );
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("${_isPromo? "Promo" : "Banner"} Updated")),
                          );
                        } else {
                          await DbService().createPromos(data: data, isPromo: _isPromo);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("${_isPromo? "Promo" : "Banner"} Added")),
                          );
                        }
                      }
                    },
                    child: Text(_screenTitle()),
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
