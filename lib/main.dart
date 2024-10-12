import 'package:flutter/material.dart';
import 'package:forui/assets.dart';
import 'package:forui/widgets/bottom_navigation_bar.dart';
import 'package:viajar/pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Viajar',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 35, 45, 79)),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: MaterialButton(
            color: Color.fromARGB(255, 35, 45, 79),
            onPressed: () => {},
            child: const Text.rich(
              TextSpan(
                text: 'viaj',
                style: TextStyle(
                    color: Colors.cyan,
                    fontSize: 24.0), // Change the color as needed
                children: <TextSpan>[
                  TextSpan(
                    text: 'ar',
                    style: TextStyle(
                        color: Colors.yellow), // Change the color as needed
                  ),
                ],
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => {},
            ),
          ],
        ),
        body: const Home(),
        bottomNavigationBar: FBottomNavigationBar(
          index: 0,
          onChange: (index) => {},
          children: [
            FBottomNavigationBarItem(
              icon: FAssets.icons.map,
              label: 'Mapa',
            ),
            FBottomNavigationBarItem(
              icon: FAssets.icons.mapPin,
              label: 'Recorridos',
            ),
            FBottomNavigationBarItem(
              icon: FAssets.icons.heart,
              label: 'Favoritos',
            ),
          ],
        ),
      ),
    );
  }
}
