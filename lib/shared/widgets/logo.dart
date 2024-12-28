import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 50),
        width: 210,
        child: const Column(
          children: [
            Image(
              image: AssetImage('assets/logo-UTN.png'),
              width: 170,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Red Social UTN',
              style: TextStyle(fontSize: 25),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }
}
