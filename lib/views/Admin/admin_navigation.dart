import 'package:flutter/material.dart';
import 'package:my_project/views/Admin/add_product.dart';
import 'package:my_project/views/Admin/admin_dashboard.dart';
import 'package:my_project/views/cart.dart';
import 'package:my_project/views/home_page.dart';
import 'package:my_project/views/profile.dart';

class AdminNavigation extends StatefulWidget {
   AdminNavigation({super.key});

  @override
  State<AdminNavigation> createState() => _AdminNavigationState();
}

class _AdminNavigationState extends State<AdminNavigation> {
  var currentindex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     

      body: IndexedStack(
        index: currentindex,
        children: [
          AdminDashboard(),

          AddProduct(),
          Profile()
        ],
      ), 

      
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (value) {
          currentindex = value;
          setState(() {
            
          });
        },
        selectedIndex: currentindex,
        destinations: [
          NavigationDestination(icon: Icon(Icons.home, color: currentindex == 0 ? Colors.white : Colors.black), label: "Home"),
          NavigationDestination(icon: Icon(Icons.store, color: currentindex == 1 ? Colors.white : Colors.black), label: "Add Product"),
          NavigationDestination(icon: Icon(Icons.person, color: currentindex == 2 ? Colors.white : Colors.black), label: "Profile"),
        ],
      ),
    );
  }
}