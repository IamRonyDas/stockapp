import 'package:flutter/material.dart';
import 'package:stocknews/screens/edit_profile.dart';
import 'package:stocknews/screens/profile_screen.dart';
import 'package:stocknews/screens/settingpage.dart';
import 'package:stocknews/view/home.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  int _currentIndex = 0; // This variable tracks the index of the selected tab

  final List<Widget> _pages = [
    const NewsPage(),
    // const EditProfile(),
    SettingPage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _currentIndex == 0
            ? Text('News')
            : _currentIndex == 1
                ? Text('Setting', style: TextStyle(color: Colors.black))
                : Text(
                    'Profile',
                  ),
      ),
      body: _pages[_currentIndex], // Displays the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Indicates the selected tab
        onTap: _onTabTapped, // Calls the function to update the tab
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.search),
          //   label: 'Search',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Sample HomeScreen widget
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Home Screen',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// Sample SearchScreen widget
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Search Screen',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// Sample ProfileScreen widget
