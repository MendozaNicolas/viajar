import 'package:flutter/material.dart';
import 'package:forui/assets.dart';
import 'package:forui/widgets/bottom_navigation_bar.dart';
import 'package:viajar/pages/home.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:viajar/pages/routes.dart';
import 'dart:developer' as developer;

import 'package:viajar/pages/stops.dart';

void main() {
  runApp(const ViajarApp());
}

class ViajarApp extends StatelessWidget {
  const ViajarApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => const HomePage(),
        '/routes': (context) => const RoutesPage(),
        '/favorites': (context) => const HomePage(),
      },
      title: 'Viajar',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 35, 45, 79)),
        useMaterial3: true,
      ),
      home: const MainScaffold(),
    );
  }
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int selectedIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      developer.log('Selected index: $selectedIndex');
    });
  }

  final List<Widget> pages = const <Widget>[
    RoutesPage(),
    HomePage(),
    StopsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 35, 45, 79),
          title: MaterialButton(
            onPressed: () => {},
            child: const Text.rich(
              TextSpan(
                text: 'viaj',
                style: TextStyle(
                    color: Color.fromARGB(255, 112, 167, 216),
                    fontSize: 24.0), // Change the color as needed
                children: <TextSpan>[
                  TextSpan(
                    text: 'ar',
                    style: TextStyle(
                      color: Color.fromARGB(255, 252, 191, 73),
                    ), // Change the color as needed
                  ),
                ],
              ),
            ),
          ),
          actions: [
            IconButton(
              color: Colors.white,
              icon: const Icon(Icons.settings),
              onPressed: () => {},
            ),
          ],
        ),
        body: pages.elementAt(selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: onItemTapped,
          items: const <BottomNavigationBarItem>[
            // BottomNavigationBarItem(
            //   icon: Icon(FontAwesomeIcons.heart),
            //   label: 'Favoritos',
            // ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.route),
              label: 'Recorridos',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.bus),
              label: 'Lineas',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.hand),
              label: 'Paradas',
            ),

            // BottomNavigationBarItem(
            //   icon: Icon(FontAwesomeIcons.map),
            //   label: 'Mapa',
            // ),
          ],
        ));
  }
}
