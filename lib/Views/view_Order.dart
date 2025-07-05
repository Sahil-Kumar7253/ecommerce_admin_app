import 'package:flutter/material.dart';

import '../controllers/db_service.dart';
import '../models/order_model.dart';

class ViewOrder extends StatefulWidget {
  const ViewOrder({super.key});

  @override
  State<ViewOrder> createState() => _ViewOrderState();
}

class _ViewOrderState extends State<ViewOrder> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as OrderModel;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Summary"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text("Delivery Details",
                  style:TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Order Id : ${args.id}"),
                    SizedBox(height: 5),
                    Text("Ordered On : ${DateTime.fromMillisecondsSinceEpoch(args.created_at).toString().substring(0,10)}"),
                    SizedBox(height: 5),
                    Text("Name : ${args.name}"),
                    SizedBox(height: 5),
                    Text("Phone : ${args.phone}"),
                    SizedBox(height: 5),
                    Text("Address : ${args.address}"),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: args.products
                    .map((e) =>
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(e.image),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  e.name,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                          Text(
                            "₹${e.single_price.toString()} x ${e.quantity.toString()} quantity",
                            style: TextStyle(
                                fontWeight: FontWeight.w600
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Total : ₹${e.total_price.toString()}",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800
                            ),
                          ),
                        ],
                      ),
                    )
                )
                    .toList(),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Discount : ₹${args.discount}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Total : ₹${args.total}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "STATUS : ${args.status}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width*.9,
                child: ElevatedButton(
                  onPressed: (){
                    showDialog(context: context, builder: (context) => ModifyOrder(order: args));
                  },
                  child: Text("Modify Order"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


class ModifyOrder extends StatefulWidget {
  final OrderModel order;

  const ModifyOrder({super.key, required this.order});

  @override
  State<ModifyOrder> createState() => _ModifyOrderState();
}

class _ModifyOrderState extends State<ModifyOrder> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Modify This Order"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text("Choose What You Want to Set."),
          ),
          SizedBox(height: 10),
          TextButton(onPressed: () async {
            await DbService().updateOrderStatus(docId: widget.order.id, data:{
              "status" : "PAID"
            });
            Navigator.pop(context);
            Navigator.pop(context);

          }, child: Text("Order Paid by the Customer")),
          TextButton(onPressed: () async {
            await DbService().updateOrderStatus(docId: widget.order.id, data:{
              "status" : "ON_THE_WAY"
            });
            Navigator.pop(context);
            Navigator.pop(context);

          }, child: Text("Order Shipped")),
          TextButton(onPressed: () async {
            await DbService().updateOrderStatus(docId: widget.order.id, data:{
              "status" : "DELIVERED"
            });
            Navigator.pop(context);
            Navigator.pop(context);

          }, child: Text("Order Delivered")),
          TextButton(onPressed: () async {
            await DbService().updateOrderStatus(docId: widget.order.id, data:{
              "status" : "CANCELLED"
            });
          Navigator.pop(context);
          Navigator.pop(context);
          }, child: Text("Cancel Order")),
        ],
      ),
    );
  }
}
