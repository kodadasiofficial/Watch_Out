import 'package:flutter/material.dart';
import 'package:watch_out/constants/fonts.dart';
import 'package:watch_out/constants/palette.dart';
import 'package:watch_out/backend/firebase/auth.dart';
import 'package:watch_out/ui/pages/main_pages/add_reports.dart';
import 'package:watch_out/ui/pages/main_pages/home_page.dart';
import 'package:watch_out/ui/pages/main_pages/profile.dart';
import 'package:watch_out/ui/pages/main_pages/reports.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final GlobalKey navigationBarKey = GlobalKey();
  late final List<Widget> _bottomBarItems;

  static final _titles = <String>[
    "Home",
    "Map",
    "Add",
    "Reports",
    "Profile",
  ];

  @override
  void initState() {
    _bottomBarItems = <Widget>[
      HomePage(
        navigationBarKey: navigationBarKey,
      ),
      Container(),
      const AddReport(),
      const ReportsPage(),
      const ProfilePage(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.mainPage,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            AuthService().signOut(context);
          },
          icon: Icon(
            Icons.notifications,
            color: Palette.darkGreen,
          ),
        ),
        title: Text(
          _titles[_selectedIndex],
          style: TextStyle(
            color: Palette.mainPageTitle,
            fontSize: Font.createAccountFontSize,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, "/settingsPage"),
            icon: Icon(
              Icons.settings,
              color: Palette.darkGreen,
            ),
          )
        ],
      ),
      body: _bottomBarItems.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        key: navigationBarKey,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Palette.bottomNavigationBar,
        selectedItemColor: Palette.buttonGreen,
        unselectedItemColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.file_copy_outlined),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "",
          ),
        ],
      ),
    );
  }
}
