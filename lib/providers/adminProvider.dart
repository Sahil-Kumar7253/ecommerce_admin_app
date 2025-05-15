import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_admin_app/controllers/db_service.dart';
import 'package:flutter/material.dart';

class Adminprovider extends ChangeNotifier {
  List<QueryDocumentSnapshot> categories = [];
  StreamSubscription<QuerySnapshot>? _categorysubscription;

  List<QueryDocumentSnapshot> products = [];
  StreamSubscription<QuerySnapshot>? _productsubscription;

  int totalCategories = 0;
  int totalProducts = 0;

  Adminprovider() {
    getCategories();
    getProducts();
  }

  void getCategories() {
    _categorysubscription?.cancel();

    _categorysubscription = DbService().readCategories().listen((snapshot) {
      categories = snapshot.docs;
      totalCategories = categories.length;
      notifyListeners();
    });
  }

  // get products List
  void getProducts() {
    _productsubscription?.cancel();

    _productsubscription = DbService().readProducts().listen((snapshot) {
      for (var doc in snapshot.docs) {
        print("Product ID: ${doc.id}, Data: ${doc.data()}");
      }

      products = snapshot.docs;
      totalProducts = products.length;
      notifyListeners();
    });
  }
}
