import 'dart:typed_data';

import 'package:my_project/models/Products_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StorageService {
  SupabaseClient _supabase = Supabase.instance.client;

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _database = FirebaseFirestore.instance;

  // Upload Profile Image

  Future<void> uploadeProfileImage(Uint8List image, String imageName) async {
    try {
      // uploading image on the specified path

      await _supabase.storage
          .from('profile_images')
          .uploadBinary("images/$imageName", image);

      //  get the image url

      String imageUrl = _supabase.storage
          .from("profile_images")
          .getPublicUrl("images/$imageName");

      //  now save the image
     await  _database
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .update({"imageUrl": imageUrl});
    } catch (e) {
      throw e.toString();
    }
  }

  Future<dynamic> uploadProductData(
      String productTitle,
      double productPrice,
      int productStock,
      String productDescription,
      String? imageName,
      Uint8List? image) async {
    try {
      CollectionReference productsRef = _database.collection("products");

      String autoId = productsRef.doc().id;

      Product product = Product(
        id: autoId,
        productTitle: productTitle,
        productPrice: productPrice,
        productStock: productStock,
        productDescription: productDescription,
      );

      await _database.collection("products").doc(autoId).set(product.toMap());

      if (imageName != null || image != null) {
        await uploadProductImage(autoId, image!, imageName!);
      }

      return true;
    } catch (e) {
      throw e.toString();
    }
  }
  Future<String> updateProductData(  
      String id,
      String productTitle,
      double productPrice,
      int productStock,
      String productDescription,
      String? imageName,
      Uint8List? image) async {
    try {

      Product product = Product(
        id: id,
        productTitle: productTitle,
        productPrice: productPrice,
        productStock: productStock,
        productDescription: productDescription,
      );
      await _database.collection("products").doc(id).update(product.toMap());

      if (imageName != null && image != null) {
        await uploadProductImage(id, image!, imageName!);
      }

      return "true";
    } catch (e) {
     return e.toString();
    }
  }
  // issy pehle hamary pas product upload honay ka banega phr image ka

  Future<void> uploadProductImage(
      String id, Uint8List image, String imagename) async {
    try {
      await _supabase.storage
          .from("product_images")
          .uploadBinary("productimage/$imagename", image);

      String imageurl =  _supabase.storage
          .from("product_images")
          .getPublicUrl("productimage/$imagename");

      await _database
          .collection("products")
          .doc(id)
          .update({"imageUrl": imageurl});
    } catch (e) {
     throw e.toString();
    }
  }

  Future<Map<String,dynamic>> getproductdata()async{
    try {
     var data = await _database.collection("products").get();

     Map<String,dynamic> alldata = {};

      for(var doc in data.docs){
        alldata[doc.id] = doc.data();
      }

      return alldata;

    } catch (e) {
      e.toString();
      return {};
    }

  }
}
