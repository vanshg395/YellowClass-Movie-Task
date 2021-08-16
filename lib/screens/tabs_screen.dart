import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// TABS
import './tabs/home_tab.dart';
import './tabs/profile_tab.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({Key? key}) : super(key: key);

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int selectedPage = 0;
  List<Map<String, dynamic>> pages = [
    {
      'title': 'Home',
      'body': HomeTab(),
    },
    {
      'title': 'Profile',
      'body': ProfileTab(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedPage]['body'],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedPage,
        selectedItemColor: Color(0xFF16222A),
        unselectedItemColor: Color(0xFF16222A).withOpacity(0.7),
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
        ),
        unselectedLabelStyle: TextStyle(fontSize: 12),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        onTap: (value) {
          HapticFeedback.lightImpact();
          setState(() {
            selectedPage = value;
          });
        },
      ),
    );
  }
}
