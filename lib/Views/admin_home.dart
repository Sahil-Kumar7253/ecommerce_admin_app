import 'package:ecommerce_admin_app/Container/dashboard_text.dart';
import 'package:ecommerce_admin_app/Container/home_button.dart';
import 'package:ecommerce_admin_app/controllers/auth_service.dart';
import 'package:flutter/material.dart';

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
            onPressed: () {
              AuthService().signOut();
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
              height: 250,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const DashboardText(
                    keyText: "Total Orders",
                    valueText: "100",
                  ),
                  const DashboardText(
                    keyText: "Total Orders",
                    valueText: "100",
                  ),
                  const DashboardText(
                    keyText: "Total Orders",
                    valueText: "100",
                  ),
                  const DashboardText(
                    keyText: "Total Orders",
                    valueText: "100",
                  ),
                  const DashboardText(
                    keyText: "Total Orders",
                    valueText: "100",
                  ),
                ],
              ),
            ),
            Row(
              children: [
                HomeButton(
                  onTap: () {
                    Navigator.pushNamed(context, "/products");
                  },
                  name: "Products",
                ),
                HomeButton(onTap: () {}, name: "Orders"),
              ],
            ),
            Row(
              children: [
                HomeButton(onTap: () {}, name: "Promos"),
                HomeButton(onTap: () {}, name: "Banners"),
              ],
            ),
            Row(
              children: [
                HomeButton(
                  onTap: () {
                    Navigator.pushNamed(context, "/category");
                  },
                  name: "Categories",
                ),
                HomeButton(onTap: () {}, name: "Coupons"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
