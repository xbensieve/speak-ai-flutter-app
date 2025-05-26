import 'package:english_app_with_ai/components/my_button.dart';
import 'package:english_app_with_ai/components/my_textfield.dart';
import 'package:english_app_with_ai/components/square_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/navigation_menu.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  //sign user in method
  void signUserIn(BuildContext context) {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();
    if (username.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in both username and password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    if (username == "user" && password == "pass") {
      // Simulate saving an access token (e.g., using get_storage in a real app)
      debugPrint('Sign-in successful! Navigating to NavigationMenu');
      Get.off(() => const NavigationMenu()); // Navigate to NavigationMenu
    } else {
      Get.snackbar(
        'Error',
        'Invalid username or password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

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
               onTap: () => signUserIn(context),
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