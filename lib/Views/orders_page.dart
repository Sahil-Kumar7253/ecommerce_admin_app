import 'package:ecommerce_admin_app/providers/adminProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/db_service.dart';
import '../models/order_model.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {

  totalQuantityCalculator(List<OrderProductModel> products){
    int total = 0;
    for(var product in products){
      total += product.quantity;
    }
    return total;
  }

  Widget statusContainer({required String text,required Color bgColor, required Color textColor}){
    return Container(
      padding: const EdgeInsets.all(8),
      color: bgColor,
      child: Text(text,style: TextStyle(color: textColor)),
    );
  }

  Widget statusIcon(String status){
    if(status == "PAID"){
      return statusContainer(text: status, bgColor: Colors.lightGreen, textColor: Colors.white);
    }
    if(status == "ON_THE_WAY"){
      return statusContainer(text: status, bgColor: Colors.orange, textColor: Colors.white);
    }
    if(status == "DELIVERED"){
      return statusContainer(text: status, bgColor: Colors.blue, textColor: Colors.white);
    }else{
      return statusContainer(text: "CANCELLED", bgColor: Colors.red, textColor: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
        centerTitle: true,
      ),
      body: Consumer<Adminprovider>(
          builder: (context,snapshot,child){
            List<OrderModel> orders = OrderModel.fromJsonList(snapshot.orders);

              if(orders.isEmpty){
                return const Center(child: Text("No Orders Found"));
              }else{
                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index){
                    return ListTile(
                      onTap: (){
                        Navigator.pushNamed(context, "/view_order",arguments: orders[index]);
                      },
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "Ordered By ${orders[index].name}"
                          ),
                          SizedBox(height: 5),
                          Text("Items Worth of Total: ${orders[index].total}"),
                          SizedBox(height: 5),
                        ],
                      ),
                      subtitle: Text("Ordered On ${DateTime.fromMillisecondsSinceEpoch(orders[index].created_at).toString().substring(0,10)}"),
                      trailing: statusIcon(orders[index].status),
                    );
                  },
                );
              }
          }
      ),
    );
  }
}
