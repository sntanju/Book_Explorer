import 'package:book_explorer/src/features/book/presentation/screens/screen_book.dart';
import 'package:flutter/material.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(

        child: ScreenBook(),

        // child: Center(
        //   child: Text("Welcome to Home"),
        // ),

      ),
    );
  }
}