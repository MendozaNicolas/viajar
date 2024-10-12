import 'package:flutter/material.dart';

class StopCard extends StatelessWidget {
  const StopCard(
    int i, {
    super.key,
    required this.id,
    required this.title,
  });

  final String id;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color.fromARGB(255, 35, 45, 79),
      elevation: 5.0,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/first');
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
