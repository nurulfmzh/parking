import 'package:flutter/material.dart';
import 'package:parking_app/screen/dashboard.dart';
import 'package:parking_app/screen/parking_home.dart';
import 'package:parking_app/screen/user_profile.dart';

class NavBarCategorySelectionScreen extends StatefulWidget {
  final int initialIndex;
  final Widget? overridePage;

  const NavBarCategorySelectionScreen({
    super.key,
    this.initialIndex = 0,
    this.overridePage,
  });

  @override
  State<NavBarCategorySelectionScreen> createState() =>
      _NavBarCategorySelectionScreenState();
}

class _NavBarCategorySelectionScreenState
    extends State<NavBarCategorySelectionScreen> {
  final PageStorageBucket bucket = PageStorageBucket();

  late int selectedIndex;
  Widget? _overridePage;

  final List<Widget> pages = [
    const HomeDashboard(),
    const ParkingHome(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
    _overridePage = widget.overridePage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        bucket: bucket,
        child: widget.overridePage ?? pages[selectedIndex],
      ),

      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
            _overridePage = null; // clear override once a tab is tapped
          });
        },
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_parking),
            label: "Parking",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
