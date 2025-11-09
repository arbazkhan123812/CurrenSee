import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_project/core/theme.dart';
import 'package:my_project/services/auth_services.dart';
import 'package:my_project/views/Admin/add_product.dart';
import 'package:my_project/views/Admin/admin_dashboard.dart';
import 'package:my_project/views/Admin/admin_navigation.dart';
import 'package:my_project/views/Admin/view_products.dart';
import 'package:my_project/views/home_page.dart';
import 'package:my_project/views/login.dart';
import 'package:my_project/views/navigation.dart';
import 'package:my_project/views/profile.dart';
import 'package:my_project/views/register.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseAuth _auth = FirebaseAuth.instance;

    return MaterialApp(
      theme: apptheme,
      debugShowCheckedModeBanner: false,
      home: ViewProducts(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData) {
          // User not logged in
          return RegisterScreen();
        }

        // User is logged in
        final user = snapshot.data!;
        final uid = user.uid;
        final AuthServices _auth = AuthServices();

        // FutureBuilder to fetch Firestore data
        return FutureBuilder<Map<String, dynamic>>(
          future: _auth.getuserdata(uid),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (userSnapshot.hasError) {
              return Center(
                  child:
                      Text("Error fetching user data: ${userSnapshot.error}"));
            }

            if (!userSnapshot.hasData) {
              return const Center(child: Text("User data not found"));
            }

            final data = userSnapshot.data!;

            // 🔁 Print all fields (foreach)
            data.forEach((key, value) {
              print("$key : $value");
            });

            // ✅ Navigate based on admin field
            if (data['is_admin'] == 1) {
              return AdminNavigation();
            } else {
              return NavigationPage();
            }
          },
        );
      },
    );
  }
}
