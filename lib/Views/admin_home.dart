import 'package:ecommerce_admin_app/Container/dashboard_text.dart';
import 'package:ecommerce_admin_app/Container/home_button.dart';
import 'package:ecommerce_admin_app/controllers/auth_service.dart';
import 'package:ecommerce_admin_app/providers/adminProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              Provider.of<Adminprovider>(context,listen: false).cancelProvider();
              await AuthService().signOut();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 280,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                border: Border.all(color: Colors.grey.shade500,width: 4),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Consumer<Adminprovider>(
                  builder: (context,value,child) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DashboardText(
                        keyText: "Total Categories",
                        valueText: "${value.categories.length}",
                      ),
                      SizedBox(height: 8),
                      DashboardText(
                        keyText: "Total Products",
                        valueText: "${value.products.length}",
                      ),
                      SizedBox(height: 8),
                      DashboardText(
                        keyText: "Total Orders",
                        valueText: "${value.totalOrders}",
                      ),
                      SizedBox(height: 8),
                      DashboardText(
                        keyText: "Total Paid",
                        valueText: "${value.orderPaid}",
                      ),
                      SizedBox(height: 8),
                      DashboardText(
                        keyText: "Total Shipped",
                        valueText: "${value.orderOnWay}",
                      ),
                      SizedBox(height: 8),
                      DashboardText(
                        keyText: "Total Delivered",
                        valueText: "${value.orderDelivered}",
                      ),
                      SizedBox(height: 8),
                      DashboardText(
                        keyText: "Total Cancelled",
                        valueText: "${value.orderCancelled}",
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    border: Border.all(color: Colors.grey.shade500,width: 4),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: HomeButton(
                    onTap: () {
                      Navigator.pushNamed(context, "/products");
                    },
                    name: "Products",
                  ),
                ),
                SizedBox(width: 6),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    border: Border.all(color: Colors.grey.shade500,width: 4),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: HomeButton(onTap: () {
                    Navigator.pushNamed(context, "/orders");
                  }, name: "Orders"),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    border: Border.all(color: Colors.grey.shade500,width: 4),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: HomeButton(onTap: () {
                    Navigator.pushNamed(context, "/promobanners",arguments: {"promo":true});
                  }, name: "Promos"),
                ),
                SizedBox(width: 6),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    border: Border.all(color: Colors.grey.shade500,width: 4),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: HomeButton(onTap: () {
                    Navigator.pushNamed(context, "/promobanners",arguments: {"promo":false});
                  }, name: "Banners"),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    border: Border.all(color: Colors.grey.shade500,width: 4),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: HomeButton(
                    onTap: () {
                      Navigator.pushNamed(context, "/category");
                    },
                    name: "Categories",
                  ),
                ),
                SizedBox(width: 6),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    border: Border.all(color: Colors.grey.shade500,width: 4),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: HomeButton(onTap: () {
                    Navigator.pushNamed(context, "/coupons");
                  }, name: "Coupons"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
