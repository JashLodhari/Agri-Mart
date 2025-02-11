import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserDetail(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .set(userInfoMap);
  }

  UpdateUserwallet(String id, String amount) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .update({"Wallet": amount});
  }

  Future addVeges(Map<String, dynamic> userInfoMap, String name) async {
    return await FirebaseFirestore.instance.collection(name).add(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> getVeges(String name) async {
    return await FirebaseFirestore.instance.collection(name).snapshots();
  }

  Future addVegesToCart(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('Cart')
        .add(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> getVegesCart(String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("Cart")
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> retriveVeges() async {
    return await FirebaseFirestore.instance
        .collection("Vegetables")
        .snapshots();
  }

  Future<void> updateVeges(String docId, Map<String, dynamic> updateInfo) async {
    try {
      await FirebaseFirestore.instance.collection('Vegetables').doc(docId).update(updateInfo);
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteVeges(String docId) async {
    try {
      await FirebaseFirestore.instance.collection('Vegetables').doc(docId).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> removeItemFromCart(String userId, String docId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('Cart')
        .doc(docId)
        .delete();
  }
}
