import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_project/views/forgotpassword.dart';

class AuthServices {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _database = FirebaseFirestore.instance;

  // Registeration method

  Future<void> registeruser(
    String name,
    String email,
    String phone,
    String password,
    String address,
    String gender,
  ) async {
    try {
      // registeration process
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _database.collection('users').doc(_auth.currentUser!.uid).set({
        "id": _auth.currentUser!.uid,
        "user_name": name,
        "email": email,
        "address": address,
        "phone": phone,
        "password": password,
        "gender": gender,
      });
      //  save user data in the firestore
    } on FirebaseAuthException catch (e) {
      throw "${e.code}: ${e.message}";
    }
  }

  Future<void> loginuser(String email, String password) async {
    try {
      var  res = await _auth.signInWithEmailAndPassword(email: email, password: password);

    } on FirebaseAuthException catch (e) {
      throw e.message ?? "Something Went Wrong";
    }
  }

  Future<Map<String, dynamic>> profileuserdata() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _database.collection('users').doc(_auth.currentUser!.uid).get();
      if (snapshot.exists && snapshot.data() != null) {
        return snapshot.data()!;
      } else {
        throw "User data not found";
      }
    } catch (e) {
      throw e.toString();
    }
  }
  Future<Map<String, dynamic>> getuserdata(String id) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _database.collection('users').doc(id).get();
      if (snapshot.exists && snapshot.data() != null) {
        return snapshot.data()!;
      } else {
        throw "User data not found";
      }
    } catch (e) {
      throw e.toString();
    }
  }
  // Future<Map<String, dynamic>> getalldata() async {
  //   try {
  //      var data =  await _database.collection('products').get();
  //     if(data.){}
  //   } catch (e) {
  //     throw e.toString();
  //   }
  // }

  Future<void> forgotpassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "Something Wrong";
    }
  }

  Future<void> logout(String email) async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "Something Wrong";
    }
  }
}
