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
}
