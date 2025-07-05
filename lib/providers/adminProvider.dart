import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_admin_app/controllers/db_service.dart';
import 'package:flutter/material.dart';

class Adminprovider extends ChangeNotifier {
  List<QueryDocumentSnapshot> categories = [];
  StreamSubscription<QuerySnapshot>? _categorysubscription;

  List<QueryDocumentSnapshot> products = [];
  StreamSubscription<QuerySnapshot>? _productsubscription;

  List<QueryDocumentSnapshot> orders = [];
  StreamSubscription<QuerySnapshot>? _ordersubscription;

  int totalCategories = 0;
  int totalProducts = 0;
  int totalOrders = 0;
  int orderCancelled = 0;
  int orderDelivered = 0;
  int orderOnWay = 0;
  int orderPaid = 0;


  Adminprovider() {
    getCategories();
    getProducts();
    readOrders();
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
      print("Hello");
      for (var doc in snapshot.docs) {
        print("Product ID: ${doc.id}, Data: ${doc.data()}");
      }
      products = snapshot.docs;
      totalProducts = products.length;
      notifyListeners();
    });
  }

  //read all the orderes
  void readOrders (){
     _ordersubscription?.cancel();
     _ordersubscription = DbService().readOrders().listen((snapshot) {
       orders = snapshot.docs;
       totalOrders = orders.length;
       countOrderStatus();
       notifyListeners();
     });
  }

  //count various order status
  void countOrderStatus(){
    orderCancelled = 0;
    orderDelivered = 0;
    orderOnWay = 0;
    orderPaid = 0;
    for(var order in orders){
      if(order["status"] == "CANCELLED"){
        orderCancelled++;
      }else if(order["status"] == "DELIVERED"){
        orderDelivered++;
      }else if(order["status"] == "ON_THE_WAY"){
        orderOnWay++;
      }else{
        orderPaid++;
      }
    }
    notifyListeners();
  }

  void cancelProvider(){
    _categorysubscription?.cancel();
    _ordersubscription?.cancel();
    _productsubscription?.cancel();
  }

  @override
  void dispose() {
    cancelProvider();
    super.dispose();
  }

}
