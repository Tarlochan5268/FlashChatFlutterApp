import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';

import 'screens/welcome_screen.dart';

void main() => runApp(FlashChat());

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          body1: TextStyle(color: Colors.black54),
        ),
      ),
      initialRoute: WelcomeScreen.ID,
      routes: {
        WelcomeScreen.ID: (context) => WelcomeScreen(),
        LoginScreen.ID: (context) => LoginScreen(),
        ChatScreen.ID: (context) => ChatScreen(),
        RegistrationScreen.ID: (context) => RegistrationScreen()
      },
      //home: WelcomeScreen(),
    );
  }
}
