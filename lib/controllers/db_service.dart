import 'package:cloud_firestore/cloud_firestore.dart';

class DbService {
  Stream<QuerySnapshot> readCategories() {
    return FirebaseFirestore.instance
        .collection('shop_categories')
        .orderBy("priority", descending: true)
        .snapshots();
  }

  // get categories
  Future createCategories({required Map<String, dynamic> data}) async {
    await FirebaseFirestore.instance.collection('shop_categories').add(data);
  }

  // update categories
  Future updateCategories({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    await FirebaseFirestore.instance
        .collection('shop_categories')
        .doc(id)
        .update(data);
  }

  // delete categories
  Future deleteCategories({required String id}) async {
    await FirebaseFirestore.instance
        .collection('shop_categories')
        .doc(id)
        .delete();
  }

  // Products
  Stream<QuerySnapshot> readProducts() {
    return FirebaseFirestore.instance
        .collection('shop_products')
        .snapshots();
  }

  // get products
  Future createProducts({required Map<String, dynamic> data}) async {
    await FirebaseFirestore.instance.collection('shop_products').add(data);
  }

  // update products
  Future updateProducts({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    await FirebaseFirestore.instance
        .collection('shop_products')
        .doc(id)
        .update(data);
  }

  // delete products
  Future deleteProducts({required String id}) async {
    await FirebaseFirestore.instance
        .collection('shop_products')
        .doc(id)
        .delete();
  }


  //Promos And Banners

  //readPromos
  Stream<QuerySnapshot> readPromos(bool isPromo) {
    return FirebaseFirestore.instance
        .collection(isPromo ? 'shop_promos' : 'shop_banners')
        .snapshots();
  }

  //create new Promos and Banners
  Future createPromos({required Map<String,dynamic> data ,required bool isPromo}) async {
     await FirebaseFirestore.instance.collection(isPromo ? 'shop_promos' : 'shop_banners').add(data);
  }

  //update Promos and Banners
  Future updatePromos({required String id,required Map<String,dynamic> data,required bool isPromo}) async {
     await FirebaseFirestore.instance.collection(isPromo ? 'shop_promos' : 'shop_banners').doc(id).update(data);
  }

  //delete Promos and Banners
  Future deletePromos({required String id,required bool isPromo}) async {
    await FirebaseFirestore.instance.collection(isPromo ? 'shop_promos' : 'shop_banners').doc(id).delete();
  }


  //Coupons

  //read Coupon Codes
  Stream<QuerySnapshot> readCouponCodes() {
    return FirebaseFirestore.instance
        .collection('shop_coupon')
        .snapshots();
  }

  //create Coupon Codes
  Future createCouponCodes({required Map<String,dynamic> data}) async {
    await FirebaseFirestore.instance.collection('shop_coupon').add(data);
  }

  //update Coupon Codes
  Future updateCouponCodes({required String id,required Map<String,dynamic> data}) async {
    await FirebaseFirestore.instance.collection('shop_coupon').doc(id).update(data);
  }

  //delete Coupon Codes
  Future deleteCouponCodes({required String id}) async {
    await FirebaseFirestore.instance.collection('shop_coupon').doc(id).delete();
  }
}
