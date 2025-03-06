import 'package:application_one/feature/Addpost/presentaion/views/post_page.dart';
import 'package:application_one/feature/home/presentation/pages/home_page.dart';
import 'package:application_one/feature/messages/presentation/views/message_screen.dart';
import 'package:application_one/feature/notification/presenation/views/notification_page.dart';
import 'package:application_one/feature/profile/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  
  final List<Widget> pages = [
    const HomePage(),
    MessageScreen(),
    const PostPage(),
    const  NotificationPage(),
    const ProfilePage(),
  ];

  void _onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500), 
        switchInCurve: Curves.ease,
        switchOutCurve: Curves.easeInOut,
        child: pages[_selectedIndex],
      ),
      bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (value) => _onTapped(value),
            destinations: const <Widget>[
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                label: 'home',
                selectedIcon: Icon(Icons.home),
              ),
              NavigationDestination(
                icon: Icon(Icons.message_outlined),
                label: 'message',
                selectedIcon: Icon(Icons.message),
              ),
              NavigationDestination(
                icon: Icon(Icons.add_outlined),
                label: 'post',
                selectedIcon: Icon(Icons.add),
              ),
              NavigationDestination(
                icon: Icon(Icons.favorite_outline),
                label: 'notifications',
                selectedIcon: Icon(Icons.favorite),
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outlined),
                label: 'profile',
                selectedIcon: Icon(Icons.person),
              ),
            ],
          ),
    );
  }
}
