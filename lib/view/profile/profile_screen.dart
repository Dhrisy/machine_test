import 'package:flutter/material.dart';
import 'package:machine_test/controller/auth_provider.dart';
import 'package:machine_test/controller/navbar_provider.dart';
import 'package:machine_test/utils/constants.dart';
import 'package:machine_test/view/login.dart';
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
          title: Text("Your Profile", style: TextStyle(
                color: Colors.white
              ),),
           centerTitle: true,
              elevation: 1,
              backgroundColor: primaryColor,
        ),
        body: Consumer<AuthProvider>(builder: (context, provider, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                   const SizedBox(height: 20,),
                  Row(
                    children: [
                      Text("Email: ",
                        style: Theme.of(context).textTheme.titleMedium),
                      Text(provider.email,   style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                children: [
                  Text("Token: ",   style: Theme.of(context).textTheme.titleMedium),
                  Text(provider.token,   style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  primaryColor,
                              elevation: 2),
                    onPressed: () async {
                      provider.setToken("");
                      provider.setEmail("");
                      Provider.of<NavbarProvider>(context, listen: false).changeIndex(0);
                      final prefs = await SharedPreferences.getInstance();
                      prefs.clear();
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => 
                      Login()), (Route<dynamic> route) => false);
                    },
                    child: Text("LOGOUT",   style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.white
                    ))),
              ),

                  
            ],
          );
        }),
      )),
    );
  }
}
