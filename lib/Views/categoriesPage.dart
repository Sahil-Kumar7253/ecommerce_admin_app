import 'package:ecommerce_admin_app/Container/additionalConfirm.dart';
import 'package:ecommerce_admin_app/controllers/db_service.dart';
import 'package:ecommerce_admin_app/models/categories_model.dart';
import 'package:ecommerce_admin_app/providers/adminProvider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Categoriespage extends StatefulWidget {
  const Categoriespage({super.key});

  @override
  State<Categoriespage> createState() => _CategoriespageState();
}

class _CategoriespageState extends State<Categoriespage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Categories")),
      body: Consumer<Adminprovider>(
        builder: (context, value, child) {
          List<CategoriesModel> categories = CategoriesModel.fromJsonList(
            value.categories,
          );

          if (value.categories.isEmpty) {
            return Center(child: Text("No Categories Found"));
          }

          return ListView.builder(
            itemCount: value.categories.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: SizedBox(
                  height: 50,
                  width: 50,
                  child: Image.network(
                    categories[index].image == ""
                        ? "https://demofree.sirv.com/nope-not-there.jpg"
                        : categories[index].image,
                  ),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: Text("What do you want to do"),
                          content: Text("Delete Action Cannot be undone"),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                showDialog(
                                  context: context,
                                  builder:
                                      (context) => Additionalconfirm(
                                        contentText:
                                            "Are you sure you want to delete this",
                                        onNo: () {
                                          Navigator.pop(context);
                                        },
                                        onYes: () {
                                          DbService().deleteCategories(
                                            id: categories[index].id,
                                          );
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text("Category Deleted"),
                                            ),
                                          );
                                          Navigator.pop(context);
                                        },
                                      ),
                                );
                              },
                              child: Text("Delete Category"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                showDialog(
                                  context: context,
                                  builder:
                                      (context) => ModifyCategory(
                                        isUpdating: true,
                                        categoryId: categories[index].id,
                                        priority: categories[index].priority,
                                        image: categories[index].image,
                                        name: categories[index].name,
                                      ),
                                );
                              },
                              child: Text("Update Category"),
                            ),
                          ],
                        ),
                  );
                },
                title: Text(
                  categories[index].name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                subtitle: Text("Priority : ${categories[index].priority}"),
                trailing: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder:
                          (context) => ModifyCategory(
                            isUpdating: true,
                            categoryId: categories[index].id,
                            priority: categories[index].priority,
                            image: categories[index].image,
                            name: categories[index].name,
                          ),
                    );
                  },
                  icon: Icon(Icons.edit_outlined),
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
            builder:
                (context) => ModifyCategory(
                  isUpdating: false,
                  categoryId: "",
                  priority: 0,
                ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class ModifyCategory extends StatefulWidget {
  final bool isUpdating;
  final String? name;
  final String categoryId;
  final String? image;
  final int priority;

  const ModifyCategory({
    super.key,
    required this.isUpdating,
    this.name,
    required this.categoryId,
    this.image,
    required this.priority,
  });

  @override
  State<ModifyCategory> createState() => _ModifyCategoryState();
}

class _ModifyCategoryState extends State<ModifyCategory> {
  final formkey = GlobalKey<FormState>();
  final ImagePicker picker = ImagePicker();
  XFile? image;
  TextEditingController categoryController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController priorityController = TextEditingController();

  @override
  void initState() {
    if (widget.isUpdating && widget.name != null) {
      categoryController.text = widget.name!;
      imageController.text = widget.image!;
      priorityController.text = widget.priority.toString();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isUpdating ? "Update Category" : "Add Category"),
      content: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("All Will be converted to lowercase"),
              SizedBox(height: 10),
              TextFormField(
                controller: categoryController,
                validator: (v) => v!.isEmpty ? "This Can't be empty. " : null,
                decoration: InputDecoration(
                  hintText: "Category Name",
                  label: Text("Category Name"),
                  fillColor: Colors.grey.shade100,
                  filled: true,
                ),
              ),

              Text("This Will be for ordering Categories"),
              SizedBox(height: 10),
              TextFormField(
                controller: priorityController,
                validator: (v) => v!.isEmpty ? "This Can't be empty. " : null,
                decoration: InputDecoration(
                  hintText: "Priority",
                  label: Text("Priority"),
                  fillColor: Colors.grey.shade100,
                  filled: true,
                ),
              ),

              SizedBox(height: 10),

              ElevatedButton(onPressed: () {}, child: Text("Pick Image")),
              SizedBox(height: 10),
              TextFormField(
                controller: imageController,
                decoration: InputDecoration(
                  hintText: "Image Link",
                  label: Text("Image Link"),
                  fillColor: Colors.grey.shade100,
                  filled: true,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () async {
            if (formkey.currentState!.validate()) {
              if (widget.isUpdating) {
                try {
                  await DbService().updateCategories(
                    id: widget.categoryId,
                    data: {
                      "name": categoryController.text.toLowerCase(),
                      "image": imageController.text,
                      "priority": int.parse(priorityController.text),
                    },
                  );
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Category Updated")));
                } catch (e) {
                  print("Update error: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed to update category: $e")),
                  );
                }
              } else {
                await DbService().createCategories(
                  data: {
                    "name": categoryController.text.toLowerCase(),
                    "image": imageController.text,
                    "priority": int.parse(priorityController.text),
                  },
                );
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Category Added")));
              }
              Navigator.pop(context);
            }
          },
          child: Text(widget.isUpdating ? "Update" : "Add"),
        ),
      ],
    );
  }
}
