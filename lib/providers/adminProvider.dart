import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_admin_app/controllers/db_service.dart';
import 'package:flutter/material.dart';

class Adminprovider extends ChangeNotifier {
  List<QueryDocumentSnapshot> categories = [];
  StreamSubscription<QuerySnapshot>? _categorysubscription;

  int totalCategories = 0;

  Adminprovider() {
    getCategories();
  }

  void getCategories() {
    _categorysubscription?.cancel();

    _categorysubscription = DbService().readCategories().listen((snapshot) {
      categories = snapshot.docs;
      totalCategories = categories.length;
      notifyListeners();
    });
  }
}
