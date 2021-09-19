import 'package:ebook_app/view/bottom/ebook_account.dart';
import 'package:ebook_app/view/bottom/home.dart';
import 'package:ebook_app/view/bottom/library.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ebook_favorite.dart';

class BottomView extends StatefulWidget {

  @override
  _BottomViewState createState() => _BottomViewState();
}

class _BottomViewState extends State<BottomView> {

  int currentIndex = 0;
  List<Widget> body = [
    Home(),
    Library(),
    EbookFavorite(),
    EbookAccount()
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTapPages,
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          // ignore: prefer_const_literals_to_create_immutables
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.my_library_books),
                label: 'Library'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.bookmark_border),
                label: 'Favorite'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_outlined),
                label: 'Profile'
            ),
          ],
        ),
        body: body[currentIndex],
      ),
    );
  }

  void onTapPages(int index){
    setState(() {
      currentIndex = index;
    });
  }
}
