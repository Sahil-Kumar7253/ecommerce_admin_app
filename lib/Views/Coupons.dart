import 'package:ecommerce_admin_app/Container/additionalConfirm.dart';
import 'package:ecommerce_admin_app/controllers/db_service.dart';
import 'package:ecommerce_admin_app/models/CouponModel.dart';
import 'package:flutter/material.dart';

class Coupons extends StatefulWidget {
  const Coupons({super.key});

  @override
  State<Coupons> createState() => _CouponsState();
}

class _CouponsState extends State<Coupons> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Coupons"),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: DbService().readCouponCodes(),
          builder: (context ,snapshots){
            if(snapshots.hasData){
              List<CouponModel> coupons = CouponModel.fromJsonList(snapshots.data!.docs);

              if(coupons.isEmpty){
                return Center(child: Text("No Coupons Found"));
              }else {
                return ListView.builder(
                    itemCount: coupons.length,
                    itemBuilder: (context,index){
                      return ListTile(
                        onTap: (){
                          showDialog(context: context, builder: (context) =>
                             AlertDialog(
                               title: Text("What do you want to do"),
                               actions: [
                                 TextButton(onPressed: (){
                                   Navigator.pop(context);
                                   showDialog(context: context, builder: (context) =>
                                      Additionalconfirm(contentText: "Delete Cannot be Undone", onNo:(){
                                        Navigator.pop(context);
                                      }, onYes: (){
                                        DbService().deleteCouponCodes(id: coupons[index].id);
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Coupon Code Deleted")));
                                      })
                                   );
                                 }, child: Text("Delete Coupon")),
                                 TextButton(onPressed: (){
                                   Navigator.pop(context);
                                   showDialog(context: context, builder: (context) => ModifyCoupon(id: coupons[index].id, desc: coupons[index].desc, code: coupons[index].code, discount: coupons[index].discount));
                                 }, child: Text("Update Coupon"))
                               ],
                             )
                          );
                        },
                        title: Text(coupons[index].code),
                        subtitle: Text(coupons[index].desc),
                        trailing: IconButton(onPressed: (){
                          showDialog(context: context, builder: (context) => ModifyCoupon(id: coupons[index].id, desc: coupons[index].desc, code: coupons[index].code, discount: coupons[index].discount));
                        }, icon: Icon(Icons.edit_outlined)),
                      );
                    }
                );
              }
            }else{
              return Center(child: CircularProgressIndicator());
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog(context: context, builder: (context) => ModifyCoupon(id: "", desc: "", code: "", discount: 0));
        },
        child: Icon(Icons.add),
      )
    );
  }
}

class ModifyCoupon extends StatefulWidget {
  final String id,desc,code;
  final int discount;

  const ModifyCoupon({
    super.key,
    required this.id,
    required this.desc,
    required this.code,
    required this.discount
  });

  @override
  State<ModifyCoupon> createState() => _ModifyCouponState();
}

class _ModifyCouponState extends State<ModifyCoupon> {
  final formKey = GlobalKey<FormState>();
  TextEditingController descController  = TextEditingController();
  TextEditingController codeController  = TextEditingController();
  TextEditingController discountController  = TextEditingController();

  @override
  void initState() {
    descController.text = widget.desc;
    codeController.text = widget.code;
    discountController.text = widget.discount.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.id.isNotEmpty ? "Update Coupon" : "Add Coupon"),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("All will be converted to upper Case"),
              SizedBox(height: 10),
              TextFormField(
                controller: codeController,
                validator: (v) => v!.isEmpty ? "Enter Code" : null,
                decoration: InputDecoration(
                  hintText: "Coupon Code",
                  label: Text("Coupon Code"),
                  fillColor: Colors.deepPurple.shade50,
                  filled: true,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: descController,
                validator: (v) => v!.isEmpty ? "Enter description" : null,
                decoration: InputDecoration(
                  hintText: "Description",
                  label: Text("Description"),
                  fillColor: Colors.deepPurple.shade50,
                  filled: true,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: discountController,
                validator: (v) => v!.isEmpty ? "Enter Discount" : null,
                decoration: InputDecoration(
                  hintText: "Discount %",
                  label: Text("Discount %"),
                  fillColor: Colors.deepPurple.shade50,
                  filled: true,
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text("Cancel")),
        TextButton(onPressed: (){
          if(formKey.currentState!.validate()){
            var data = {
              "code" : codeController.text.toUpperCase(),
              "desc" : descController.text,
              "discount" : int.parse(discountController.text)
            };
            if(widget.id.isNotEmpty){
              DbService().updateCouponCodes(id: widget.id, data: data);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Coupon Code Updated")));
            }else{
              DbService().createCouponCodes(data: data);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Coupon Code Added")));
            }

            Navigator.pop(context);
          }
        }, child: Text(widget.id.isNotEmpty ? "Update Coupon" : "Add Coupon"))
      ],
    );
  }
}

