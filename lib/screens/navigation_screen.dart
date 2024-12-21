import 'package:flutter/material.dart';
import 'divisions_screen.dart';
import 'participants_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _activeIndex = 0;

  final List<Widget> _views = [
    const DivisionsScreen(),
    const ParticipantsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _views[_activeIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _activeIndex,
        onTap: (index) => setState(() => _activeIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.business_center),
            label: 'Департаменти',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.diversity_1),
            label: 'Учасники',
          ),
        ],
      ),
    );
  }
}
