import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'NayTodo',
          style: TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.pink,
      ),
      body: Container(
        child: Positioned.fill(
          child: Align(
            alignment: Alignment(0.75, 0.85), // x横向(-1~1) y纵向(-1~1)
            child: FloatingActionButton(
              shape: CircleBorder(),
              backgroundColor: Colors.pink,
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ),
        )
      ),
    );
  }
}