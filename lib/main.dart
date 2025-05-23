import 'package:ecommerce_admin_app/Views/admin_home.dart';
import 'package:ecommerce_admin_app/Views/categoriesPage.dart';
import 'package:ecommerce_admin_app/Views/login.dart';
import 'package:ecommerce_admin_app/Views/modify_Product.dart';
import 'package:ecommerce_admin_app/Views/products_page.dart';
import 'package:ecommerce_admin_app/Views/signup_page.dart';
import 'package:ecommerce_admin_app/controllers/auth_service.dart';
import 'package:ecommerce_admin_app/firebase_options.dart';
import 'package:ecommerce_admin_app/providers/adminProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
