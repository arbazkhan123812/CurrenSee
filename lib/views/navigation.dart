import 'package:flutter/material.dart';
import 'package:my_project/views/cart.dart';
import 'package:my_project/views/home_page.dart';
import 'package:my_project/views/profile.dart';

class NavigationPage extends StatefulWidget {
   NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int currentindex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentindex,
        children: [
          
          HomePage(),
          CartPage(),
          Profile(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (value) {
          currentindex = value;
          setState(() {
            
          });
        },
        indicatorColor: Colors.indigo,
        selectedIndex: currentindex,
        
        destinations: [
          
          NavigationDestination(icon: Icon(Icons.home,color: currentindex == 0 ? Colors.white : Colors.black ), label: "Home",),
          NavigationDestination(icon: Icon(Icons.shopping_cart, color:  currentindex == 1 ? Colors.white : Colors.black ,), label: "My Cart"),
          NavigationDestination(icon: Icon(Icons.person,color:  currentindex == 2 ? Colors.white : Colors.black ,), label: "Profile"),
          
        ]
      ),
    );
  }
}