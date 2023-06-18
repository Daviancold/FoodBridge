import 'package:foodbridge_project/screens/log_in_&_auth/login_screen.dart';
import 'package:foodbridge_project/screens/log_in_&_auth/registration_screen.dart';
import 'package:flutter/material.dart';

/*
* To decide whether to show login page (login_screen) or 
* registration page (registration_screen)
*/

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin
      ? LoginWidget(onClickedSignUp: toggle)
      : SignUpWidget(onClickedSignIn: toggle);

  void toggle() => setState(() => isLogin = !isLogin);
}
