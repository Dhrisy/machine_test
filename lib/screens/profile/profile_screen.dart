import 'package:flutter/material.dart';
import 'package:machine_test/controller/auth_provider.dart';
import 'package:machine_test/controller/navbar_provider.dart';
import 'package:machine_test/screens/login.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchData();
    });
  }

  Future<void> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    final provider = Provider.of<AuthProvider>(context, listen: false);

    provider.setEmail(prefs.getString("email").toString());
    provider.setToken(prefs.getString("token").toString());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      child: SafeArea(
          child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Your Profile"),
          centerTitle: true,
        ),
        body: Consumer<AuthProvider>(builder: (context, provider, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Text("Email: "),
                      Text(provider.email),
                    ],
                  ),
                  Row(
                children: [
                  Text("Token: "),
                  Text(provider.token),
                ],
              ),
                ],
              ),
              ElevatedButton(
                  onPressed: () async {
                    provider.setToken("");
                    provider.setEmail("");
                    Provider.of<NavbarProvider>(context, listen: false).changeIndex(0);
                    final prefs = await SharedPreferences.getInstance();
                    prefs.clear();
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => 
                    Login()), (Route<dynamic> route) => false);
                  },
                  child: Text("LOGOUT"))
            ],
          );
        }),
      )),
    );
  }
}
