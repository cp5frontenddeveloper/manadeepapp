import 'package:flutter/material.dart';

class Authheroimage extends StatelessWidget {
  final String image;
  Authheroimage({super.key, required this.image});
  @override
  Widget build(BuildContext context) {
    return Center(
      child:Container(
        width: 300,
        height: 300,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Image.asset(
  "assets/images/auth/login.png",
  fit: BoxFit.cover,
))
        ),
      ) ,
    );
  }
}
