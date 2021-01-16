import 'package:flutter/material.dart';
import 'package:flutter_internet_radio_using_provider/pages/home_page.dart';
import 'package:flutter_internet_radio_using_provider/pages/radio_page.dart';
import 'package:flutter_internet_radio_using_provider/services/player_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => PlayerProvider(),
          child: RadioPage(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: true,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SafeArea(
          bottom: false,
          child: Scaffold(
            primary: false,
            body: HomePage(),
          ),
        ),
      ),
    );
  }
}
