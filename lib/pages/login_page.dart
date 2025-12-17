import 'package:agoraofolymus/components/my_button.dart';
import 'package:agoraofolymus/components/my_textfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  //text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [

              const SizedBox(height: 100),
          
              //logo/image
              Icon(
                Icons.lock,
                size: 100,
              ),

              const SizedBox(height: 25),
              //username textfield 
              MyTextfield(
                controller: usernameController, 
                hintText: 'Username', 
                obscureText: false),

              const SizedBox(height: 10),
          
              //password textfield
              MyTextfield(
                controller: passwordController, 
                hintText: 'Password', 
                obscureText: true),

              const SizedBox(height: 25),

              //sign in button
              MyButton(
                onTap: (){}, 
                child: Text(
                  "Sign in",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}