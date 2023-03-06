import 'package:ebook_app/view/login/login.dart';
import 'package:ebook_app/widget/theme_ebook.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(ChangeNotifierProvider<ThemeEbook>(
    create: (_) => ThemeEbook(isLight: true),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Login(),
      );
    });
  }
}
