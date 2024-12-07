import 'package:flutter/material.dart';
import 'package:machine_test/controller/navbar_provider.dart';
import 'package:machine_test/screens/home_screen/home_screen.dart';
import 'package:machine_test/screens/profile/profile_screen.dart';
import 'package:machine_test/utils/constants.dart';
import 'package:provider/provider.dart';

class Navbar extends StatelessWidget {
  Navbar({Key? key}) : super(key: key);

  List<Widget> screens = [HomeScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Consumer<NavbarProvider>(builder: (context, navProvider, child) {
        return Scaffold(
          body: screens[navProvider.currentIndex],
          bottomNavigationBar: navBarWidget(),
        );
      }),
    );
  }

  Widget navBarWidget() {
    return Consumer<NavbarProvider>(builder: (context, provider, child) {
      return Container(
        height: 60,
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 236, 236, 236),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
                onTap: () {
                  provider.changeIndex(0);
                },
                child: Icon(
                  Icons.home,
                  size: 30,
                  color:
                      provider.currentIndex == 0 ? primaryColor : Colors.black,
                )),
            InkWell(
              onTap: () {
                provider.changeIndex(1);
              },
              child: Icon(
                Icons.person,
                size: 30,
                color: provider.currentIndex == 1 ? primaryColor : Colors.black,
              ),
            )
          ],
        ),
      );
    });
  }
}
