import 'package:ecommerce_admin_app/Views/admin_home.dart';
import 'package:ecommerce_admin_app/Views/categoriesPage.dart';
import 'package:ecommerce_admin_app/Views/login.dart';
import 'package:ecommerce_admin_app/Views/modify_Product.dart';
import 'package:ecommerce_admin_app/Views/orders_page.dart';
import 'package:ecommerce_admin_app/Views/products_page.dart';
import 'package:ecommerce_admin_app/Views/signup_page.dart';
import 'package:ecommerce_admin_app/controllers/auth_service.dart';
import 'package:ecommerce_admin_app/firebase_options.dart';
import 'package:ecommerce_admin_app/providers/adminProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Views/Coupons.dart';
import 'Views/ModifyPromoBanner.dart';
import 'Views/PromoBanners.dart';
import 'Views/view_Order.dart';
import 'Views/view_product.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Adminprovider(),
      builder:
          (context, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Ecommerce Admin App',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),
            routes: {
              '/': (context) => const CheckUser(),
              '/login': (context) => const LoginPage(),
              '/adminhome': (context) => const AdminHome(),
              '/signup': (context) => const SignUpPage(),
              '/category': (context) => const Categoriespage(),
              '/products': (context) => const ProductsPage(),
              '/modifyproduct': (context) => const ModifyProduct(),
              '/viewproduct': (context) => const ViewProduct(),
              '/promobanners': (context) => const Promobanners(),
              '/modifypromo': (context) => const ModifyPromo(),
              '/coupons': (context) => const Coupons(),
              '/orders' : (context) => const OrdersPage(),
              '/view_order' : (context) => const ViewOrder(),
            },
          ),
    );
  }
}

class CheckUser extends StatefulWidget {
  const CheckUser({super.key});

  @override
  State<CheckUser> createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {
  @override
  void initState() {
    AuthService().isLoggedIn().then((value) {
      if (value) {
        Navigator.pushReplacementNamed(context, '/adminhome');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
