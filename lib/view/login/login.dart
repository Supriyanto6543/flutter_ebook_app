import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:ebook_app/contoller/api.dart';
import 'package:ebook_app/view/bottom/bottom_view.dart';
import 'package:ebook_app/view/register/register.dart';
import 'package:ebook_app/widget/ebook_routers.dart';
import 'package:ebook_app/widget/shared_common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool visibleLoading = false;

  Future login({required TextEditingController name,
    required TextEditingController password,
    required BuildContext context, required Widget widget}) async{

    String getName = name.text;
    String getPassword = password.text;

    setState(() {
      visibleLoading = true;
    });

    var data = {'email': getName, 'password': getPassword};
    var apiCall = await Dio().post(ApiConstant().baseUrl+ApiConstant().login, data: data);

    var decode = jsonDecode(apiCall.data); //this replace double quotes

    if(decode[4] == "Successfully login"){
      setState(() {
        visibleLoading = false;
      });
      prefLogin(id: decode[0], name: decode[1], email: decode[2], photo: "");
      pushPageAndRemove(context, widget);
    }else{
      setState(() {
        visibleLoading = false;
      });
      showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              title: Text('Please double check your name or password', style: TextStyle(
                  color: Colors.blueAccent, fontSize: 19
              ),),
              actions: [
                GestureDetector(
                  onTap: ()=>Navigator.pop(context),
                  child: Text('Okay'),
                )
              ],
            );
          });
    }

  }

  @override
  void initState() {
    super.initState();
    prefLoad().then((value) {
      setState(() {
        if(value != null){
          pushPageAndRemove(context, BottomView());
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Container(
          margin: EdgeInsets.only(top: 90),
          child: Stack(
            children: [
              Column(
                children: [
                  Image.asset('assets/image/noimg.png', width: 125, height: 125,),
                  Text('Hello, Welcome back !', style: TextStyle(
                      fontSize: 24, color: Colors.blueAccent
                  ),),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 6.h, bottom: 5),
                    child: TextField(
                      controller: nameController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          hintText: 'Enter your email',
                          prefixIcon: Icon(Icons.account_circle_outlined, color: Colors.black,),
                          filled: true,
                          isDense: true,
                          fillColor: Colors.white70,
                          hintStyle: TextStyle(color: Colors.black),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.blueAccent)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.blueAccent)
                          )
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 5),
                    child: TextField(
                      controller: passwordController,
                      style: TextStyle(color: Colors.black),
                      autocorrect: true,
                      obscureText: true,
                      autofocus: false,
                      decoration: InputDecoration(
                          hintText: 'Enter your password',
                          prefixIcon: Icon(Icons.lock_outline, color: Colors.black,),
                          filled: true,
                          isDense: true,
                          fillColor: Colors.white70,
                          hintStyle: TextStyle(color: Colors.black),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.blueAccent)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.blueAccent)
                          )
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 7, bottom: 7),
                    child: GestureDetector(
                      onTap: (){
                        if(nameController.text != "" && passwordController.text != ""){
                          login(name: nameController,
                              password: passwordController,
                              context: context, widget: BottomView());
                        }else{
                          Alert(
                              context: context,
                              type: AlertType.success,
                              onWillPopActive: true,
                              title: 'Email or Password Empty',
                              desc: 'Please given your correct Email and Password to Continue',
                              style: AlertStyle(
                                  animationType: AnimationType.shrink,
                                  overlayColor: Color(0x8A00000),
                                  backgroundColor: Colors.white,
                                  titleStyle: TextStyle(
                                      color: Colors.black87
                                  ),
                                  descStyle: TextStyle(
                                      color: Colors.black87, fontSize: 18, fontFamily: "Macklin"
                                  )
                              ),
                              buttons: [
                                DialogButton(
                                  padding: EdgeInsets.all(0),
                                  child: Container(
                                      height: 45,
                                      alignment: Alignment.bottomCenter,
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.blueAccent, width: 0.9),
                                          borderRadius: BorderRadius.circular(7),
                                          gradient: LinearGradient(
                                              colors: [
                                                Colors.blueAccent,
                                                Colors.blueAccent
                                              ],
                                              begin: FractionalOffset.topLeft,
                                              end: FractionalOffset.bottomRight
                                          )
                                      ),
                                      child: Center(child: Text('Okay', style: TextStyle(fontSize: 16, color: Colors.black),))),
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  width: 100,
                                )
                              ]
                          ).show();
                        }
                      },
                      child: Container(
                          margin: EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 7),
                          padding: EdgeInsets.only(top: 1.2.h, bottom: 1.2.h, right: 1.2.w, left: 1.2.w),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              color: Colors.blueAccent
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: !visibleLoading ? Container(
                            width: MediaQuery.of(context).size.width,
                            child: Text('Login', style: TextStyle(
                                color: Colors.white, fontSize: 17
                            ), textAlign: TextAlign.center,),
                          ) : Visibility(visible: visibleLoading,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                child: Container(
                                  width: 19,
                                  height: 19,
                                  child: CircularProgressIndicator(strokeWidth: 1.6, color: Colors.red,),
                                ),
                              ),
                            ),
                          )
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: EdgeInsets.only(right: 20, left: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Dont have an Account?', style: TextStyle(fontSize: 17),),
                          SizedBox(width: 10,),
                          GestureDetector(
                            onTap: (){
                              pushPage(context, Register());
                            },
                            child: Text('Sign up', style: TextStyle(color: Colors.blueAccent, fontSize: 17),),
                          )
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(right: 15, left: 15, bottom: 22),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: RichText(
                            text: TextSpan(
                                children: [
                                  TextSpan(text: 'By using this app I agree ', style: TextStyle(
                                      color: Colors.black, fontSize: 16
                                  ),),
                                  TextSpan(text: 'Term of Services ', style: TextStyle(
                                      color: Colors.blue, fontSize: 16
                                  ), recognizer: TapGestureRecognizer()..onTap=(){_openTos();}),
                                  TextSpan(text: 'and ', style: TextStyle(
                                      color: Colors.black, fontSize: 16
                                  ),),
                                  TextSpan(text: 'Privacy Policy', style: TextStyle(
                                      color: Colors.blue, fontSize: 16
                                  ),recognizer: TapGestureRecognizer()..onTap=(){_openPP();}),
                                ]
                            )
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
    );
  }

  _openTos() async{
    await canLaunch("http://edumy.go-cow.com/tos.html") ?
    await launch("http://edumy.go-cow.com/tos.html") : throw 'Could not launch url';
  }

  _openPP() async{
    await canLaunch("http://edumy.go-cow.com/privacy_policy.html") ?
    await launch("http://edumy.go-cow.com/privacy_policy.html") : throw 'Could not launch url';
  }
}
