import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Add your widgets here
        ],
      ),
      bottomSheet: GestureDetector(
        onTap: () {
          // Do something when the user taps on the bottom sheet
        },
        onVerticalDragUpdate: (dragDetails) {
          if (dragDetails.delta.dy < 0) {
            // Show the bottom sheet when the user swipes up
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  height: 200.0,
                  color: Colors.white,
                  child: Center(
                    child: Text('Bottom Sheet'),
                  ),
                );
              },
            );
          }
        },
        child: Container(
          height: 50.0,
          color: Colors.grey,
          child: Center(
            child: Text('Swipe up for more'),
          ),
        ),
      ),
    );
  }
}