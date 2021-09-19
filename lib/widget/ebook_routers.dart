import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void pushPage(BuildContext context, Widget widget){
  Navigator.push(context, MaterialPageRoute(builder: (context)=>widget));
}

void pushPageReplacement(BuildContext context, Widget widget){
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>widget));
}

void backButton(BuildContext context){
  Navigator.pop(context, true);
}

pushPageAndRemove(BuildContext context, Widget widget){
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>widget),
          (Route<dynamic> route) => false);
}