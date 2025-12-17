import 'package:agoraofolymus/components/my_button.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Welcome to page
            Text(
              "Welcome page",
              style: TextStyle(
                fontSize: 30,
              ),
            ),

            //button to store
            MyButton(onTap: () =>Navigator.pushNamed(context, '/login_page'), 
            child: Icon(Icons.arrow_forward))
          ],
        ),
      ),
    );
  }
}