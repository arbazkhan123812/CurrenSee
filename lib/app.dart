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
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _controller.forward();

    // Navigate to AuthGate after splash duration
    Future.delayed(Duration(milliseconds: 2500), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AuthGate()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo with container for better presentation
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.shopping_bag,
                        size: 60,
                        color: Theme.of(context).primaryColor,
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 30),
              // App Name with Typing Animation Effect
              TweenAnimationBuilder(
                duration: Duration(milliseconds: 1000),
                tween: Tween<double>(begin: 0, end: 1),
                builder: (context, double value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, (1 - value) * 20),
                      child: child,
                    ),
                  );
                },
                child: Text(
                  'My Project',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              SizedBox(height: 10),
              // Subtitle with fade animation
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'Welcome to Currensee',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              SizedBox(height: 50),
              // Loading indicator
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

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