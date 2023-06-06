import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:shakyab/Screens/auth/login_screen.dart';
import 'package:shakyab/Screens/components/add_stock_screen.dart';
import 'package:shakyab/Screens/components/map_screen.dart';
import 'package:shakyab/Screens/components/view_stock_screen.dart';
import 'package:shakyab/constants/colors.dart';
import 'package:shakyab/constants/navIcons.dart';
import 'package:shakyab/route/authRoute.dart' as auth_route;
import 'package:shakyab/services/sharedPreference.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  SharedPreferenceHelper prefHelper = SharedPreferenceHelper();
  int index = 0;
  String _username = '';

  final _screens = [
    const ViewStockScreen(),
    const AddStockScreen(),
    // const EmptyScreen()
    const MapScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _checkIfLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: colorSeven,
        extendBody: true,
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [Text(_username)],
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: colorThree,
        ),
        drawer: getDrawer(),
        body: _screens[index],
        bottomNavigationBar: Theme(
          data: Theme.of(context)
              .copyWith(iconTheme: const IconThemeData(color: Colors.white)),
          child: size.width > 768
              ? const SizedBox(
                  height: 0,
                )
              : CurvedNavigationBar(
                  items: const <Widget>[
                    Icon(iconHome, size: 30),
                    Icon(iconAdd, size: 30),
                    Icon(iconMap, size: 30),
                  ],
                  index: index,
                  height: 60,
                  color: colorThree,
                  backgroundColor: Colors.transparent,
                  buttonBackgroundColor: colorThree,
                  animationDuration: const Duration(milliseconds: 450),
                  onTap: (index) => setState(() {
                    this.index = index;
                  }),
                ),
        ),
      ),
    );
  }

  Widget getDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: colorThree,
            ),
            child: Padding(
              padding: EdgeInsets.all(30.0),
              child: SizedBox(
                child: Image(
                  image: AssetImage("assets/images/logo.png"),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(iconHome),
            title: const Text('Go to Home'),
            onTap: () {
              setState(() {
                index = 0;
              });
            },
          ),
          ListTile(
            leading: const Icon(iconAdd),
            title: const Text('Add Items'),
            onTap: () {
              setState(() {
                index = 1;
              });
            },
          ),
          ListTile(
            leading: const Icon(iconMap),
            title: const Text('View Map'),
            onTap: () {
              setState(() {
                index = 2;
              });
            },
          ),
          ListTile(
            leading: const Icon(iconLogout),
            title: const Text('Logout'),
            onTap: () {
              prefHelper.removeLoginDetails();
              Navigator.pop(context);

              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
              // Navigator.pushNamed(context, 'login');
            },
          ),
        ],
      ),
    );
  }

  void _checkIfLoggedIn() async {
    var loginStatus = await prefHelper.fetchLoginDetails();
    if (loginStatus['username'] == null) {
      Navigator.pop(context);
      Navigator.pushNamed(context, auth_route.loginPage);
    } else {
      setState(() {
        _username = loginStatus['username'];
      });
    }
  }
}
