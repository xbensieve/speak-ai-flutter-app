import 'package:english_app_with_ai/components/my_button.dart';
import 'package:english_app_with_ai/components/my_textfield.dart';
import 'package:english_app_with_ai/components/square_tile.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  //sign user in method
  void signUserIn() {}

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     backgroundColor: Colors.grey[300],
     body: SafeArea(
       child: Center(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             SizedBox(height: 50),
             Icon(
               Icons.lock,
               size: 100,
             ),
             SizedBox(height: 50),
             Text("Welcome back you've been missed!",
               style: TextStyle(
                 color: Colors.grey[700],
                 fontSize: 16),
             ),
             SizedBox(height: 50),
             //username textfield
             MyTextField(
               controller: usernameController,
               hintText: 'Username',
               obscureText: false,
             ),
             //password textfield
             SizedBox(height: 10),
             MyTextField(
               controller: passwordController,
               hintText: 'Password',
               obscureText: true,
             ),
             SizedBox(height: 10),
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 25.0),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.end,
                 children: [
                   Text("Forgot password?",
                   style: TextStyle(color: Colors.grey[600]),
                   ),
                 ],
               ),
             ),
             SizedBox(height: 25),
             MyButton(
               onTap: signUserIn,
             ),
             SizedBox(height: 50),
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 25.0),
               child: Row(
                 children: [
                   Expanded(child: Divider(
                     thickness: 0.5,
                     color: Colors.grey[400],
                   )),
                   Text("Or continue with",
                     style: TextStyle(color: Colors.grey[700]),
                   ),
                   Expanded(child: Divider(
                     thickness: 0.5,
                     color: Colors.grey[400],
                   )),
                 ],
               ),
             ),
             SizedBox(height: 50),
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 SquareTile(imagePath: 'lib/assets/images/google_logo.webp'),
               ],
             ),
             SizedBox(height: 50),
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Text("Not a member?",
                   style: TextStyle(color: Colors.grey[700]),
                 ),
                 SizedBox(width: 4),
                 Text("Register now",
                   style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
               ],
             )
           ],
         ),
       )
     )
   );
  }
}