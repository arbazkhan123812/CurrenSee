import 'dart:math';
import 'dart:typed_data';

import 'package:my_project/models/Currency_news.dart';
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
  Future<bool> updateProductData(  
      String id,
      String productTitle,
      double productPrice,
      int productStock,
      String productDescription,
      String? imageName,
      Uint8List? image) async {
    try {
       var olddata =  await getproductdata(id);

      
      Product product = Product(
        id: id,
        productTitle: productTitle,
        productPrice: productPrice,
        productStock: productStock,
        productDescription: productDescription,
        imageUrl: olddata['imageUrl']
      );
      await _database.collection("products").doc(id).update(product.toMap());

      if (imageName != null && image != null) {
        await uploadProductImage(id, image!, imageName!);
      }
      return true;
    } catch (e) {
     throw e.toString();
    }
  }
  Future<bool> deleteproductData( String id,) async {
    try {
      await _database.collection("products").doc(id).delete();
      return true;
    } catch (e) {
     throw e.toString();
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

  Future<Map<String,dynamic>> getproductdata(String? id)async{
    try {
      if(id!=null){
        try {
          var single = await _database.collection("products").doc(id).get();
        return single.data()!;
        } catch (e) {
          e.toString();
        }
      }
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
  // StorageService class mein ye functions add karen:

Future<List<CurrencyNews>> getCurrencyNews() async {
  try {
    var response = await _database.collection("currency_news")
      .orderBy('date', descending: true)
      .limit(10)
      .get();

    List<CurrencyNews> newsList = [];
    
    for (var doc in response.docs) {
      Map<String, dynamic> data = doc.data();
      data['id'] = doc.id;
      newsList.add(CurrencyNews.fromMap(data));
    }
    
    return newsList;
  } catch (e) {
    throw e.toString();
  }
}

Future<Map<String, dynamic>> getMarketTrends() async {
  try {
    // Ye demo data hai, aap apne API se real data fetch kar sakte hain
    return {
      'usd_to_pkr': {'rate': 278.5, 'change': 0.5, 'change_percent': 0.18},
      'eur_to_pkr': {'rate': 302.3, 'change': -0.8, 'change_percent': -0.26},
      'gbp_to_pkr': {'rate': 354.7, 'change': 1.2, 'change_percent': 0.34},
      'updated_at': DateTime.now().toIso8601String(),
    };
  } catch (e) {
    throw e.toString();
  }
}
  
}
