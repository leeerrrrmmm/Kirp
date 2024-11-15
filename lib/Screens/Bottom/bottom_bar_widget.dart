import 'package:flutter/material.dart';
import 'package:kiru/Screens/Home/home_screen.dart';
import '../AllPosts/AllPosts.dart';
import '../Favorite/Favorite.dart';
import '../Profile/profile.dart';

class BottomBarWidget extends StatefulWidget {
  const BottomBarWidget({super.key});

  @override
  State<BottomBarWidget> createState() => _BottomBarWidgetState();
}
int currentIndex = 2;
class _BottomBarWidgetState extends State<BottomBarWidget> {


  final  pages = [
    HomeScreen(),
    Favorite(),
    AllOfUsersPosts(),
    Profile(),

  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          iconSize: 24.0, // Размер иконок
          selectedItemColor: Colors.black, // Цвет выбранного элемента
          unselectedItemColor: Colors.grey, // Цвет невыбранных элементов
          backgroundColor: Colors.white, // Фон навигационной панели
          elevation: 0.0, // Тень для BottomNavigationBar
          type: BottomNavigationBarType.fixed, // Фиксированный
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home),
              label: '',),
            BottomNavigationBarItem(icon: Icon(Icons.favorite),
                label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.all_inbox),
                label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.person),
                label: ''),


          ]),
      body: pages[currentIndex],
    );
  }
}
