import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:machine_test/controller/auth_provider.dart';
import 'package:machine_test/controller/navbar_provider.dart';
import 'package:machine_test/model/data_model.dart';
import 'package:machine_test/view/login.dart';
import 'package:machine_test/view/splash_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();


Directory directory = await getApplicationDocumentsDirectory();
  // initialize hive
   Hive.init(directory.path);

  // register the adaptor 
 if(!Hive.isAdapterRegistered(0)){
  Hive.registerAdapter(DataModelAdapter());
 }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => NavbarProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
