import 'package:flutter/material.dart';
import 'package:my_project/views/cart.dart';
import 'package:my_project/views/currency_screen.dart';
import 'package:my_project/views/home_page.dart';
import 'package:my_project/views/profile.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int currentindex = 0;

  // Updated screens list with currency converter
  final List<Widget> _mainScreens = [
    HomePage(),
    CurrencyConverter(), // Add currency converter as a main tab
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentindex,
        children: _mainScreens,
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (value) {
          setState(() {
            currentindex = value;
          });
        },
        indicatorColor: Colors.indigo,
        selectedIndex: currentindex,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home, color: currentindex == 0 ? Colors.white : Colors.black),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(Icons.currency_exchange, color: currentindex == 2 ? Colors.white : Colors.black),
            label: "Currency",
          ),
          NavigationDestination(
            icon: Icon(Icons.person, color: currentindex == 3 ? Colors.white : Colors.black),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}