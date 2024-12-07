import 'package:flutter/material.dart';
import 'package:machine_test/controller/auth_provider.dart';
import 'package:machine_test/view/login.dart';
import 'package:machine_test/view/navbar/navbar.dart';
import 'package:machine_test/utils/animated_navigation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 2), () {
        isLogged();
      });
    });
  }

  void isLogged() async {
    final prefs = await SharedPreferences.getInstance();
    
    if (prefs.getString("token") != null) {
      Navigator.pushAndRemoveUntil(
          context,
          AnimatedNavigation().fadeAnimation(Navbar()),
          (Route<dynamic> route) => false);
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          AnimatedNavigation().fadeAnimation(Login()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Text("Hello...!",
        style: Theme.of(context).textTheme.headlineLarge!.copyWith(
          fontWeight: FontWeight.bold
        ),),
      ),
    );
  }
}
