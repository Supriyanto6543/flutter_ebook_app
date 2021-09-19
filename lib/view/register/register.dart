import 'dart:io';
import 'package:ebook_app/contoller/api.dart';
import 'package:ebook_app/view/login/login.dart';
import 'package:ebook_app/widget/ebook_routers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  late File _file = File('');
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool visibleLoading = false;
  final picker = ImagePicker();

  Future register({required TextEditingController name,
    required TextEditingController email,
    required TextEditingController password, required BuildContext context, required Widget widget}) async{
    setState(() {
      visibleLoading = true;
    });

    String getName = name.text;
    String getEmail = email.text;
    String getPassword = password.text;

    var request = http.MultipartRequest('POST', Uri.parse(ApiConstant().baseUrl+ApiConstant().register));
    var photo = await http.MultipartFile.fromPath('photo', _file.path);
    request.fields['name'] = getName;
    request.fields['email'] = getEmail;
    request.fields['password'] = getPassword;
    request.files.add(photo);

    var response = await request.send();

    if(response.statusCode == 200){
      setState(() {
        visibleLoading = false;
      });
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
    }else{
      setState(() {
        visibleLoading = false;
      });
      showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              title: Text('Name or Email already on Database', style: TextStyle(
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 80),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('Create Your Account Right Now', style: TextStyle(
                  color: Colors.black, fontSize: 20
              ),),
              GestureDetector(
                onTap: (){
                  imagePicker(context);
                },
                child: Container(
                  margin: EdgeInsets.only(right: 20, left: 20, bottom: 5, top: 20),
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: _file.path == '' ? Image.asset('assets/image/register.png', width: 30, height: 30, fit: BoxFit.cover,) :
                      Image.file(_file, width: 30, height: 30, fit: BoxFit.cover,)
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 5),
                child: TextField(
                  controller: nameController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      hintText: 'Enter your name',
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
                  controller: emailController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      hintText: 'Enter your email',
                      prefixIcon: Icon(Icons.email_outlined, color: Colors.black,),
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
                  autocorrect: true,
                  obscureText: true,
                  autofocus: false,
                  style: TextStyle(color: Colors.black),
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
                    if(_file.path != ""){
                      if(nameController.text != ""){
                        if(emailController.text != ""){
                          if(passwordController.text != ""){
                            register(
                                name: nameController,
                                email: emailController,
                                password: passwordController,
                                context: context,
                                widget: widget);
                          }else{
                            msgError('Password Empty', 'Please given your password');
                          }
                        }else{
                          msgError('Email Empty', 'Please given your email to Register');
                        }
                      }else{
                        msgError('Name Empty', 'Please given your name to Register');
                      }
                    }else{
                      msgError('Choose Image', 'Please choose image first before Register');
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
                        child: Text('Create Account', style: TextStyle(
                            color: Colors.white, fontSize: 17
                        ), textAlign: TextAlign.center,),
                      ) : Visibility(visible: visibleLoading,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: Container(
                              width: 19,
                              height: 19,
                              child: CircularProgressIndicator(strokeWidth: 1.6, color: Colors.white,),
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
                      Text('Have an Account?', style: TextStyle(fontSize: 17),),
                      SizedBox(width: 10,),
                      GestureDetector(
                        onTap: (){
                          pushPage(context, Login());
                        },
                        child: Text('Login', style: TextStyle(color: Colors.blueAccent, fontSize: 17),),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 1.h,),
              Container(
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
              )
            ],
          ),
        ),
      ),
    );
  }

  imageFromGallery()async{
    var imageFromGall = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if(imageFromGall != null){
        _file = File(imageFromGall.path);
        print("this is form gallery");
      }else{
        print("image form gallery dont have any data");
      }
    });
  }

  imageFromCamera() async{
    //var imageFromGall = await picker.getImage(source: ImageSource.camera, imageQuality: 100, maxWidth: 100.0, maxHeight: 100.0);
    var imageFromGall = await picker.pickImage(source: ImageSource.camera, imageQuality: 100, maxHeight: 100, maxWidth: 100);
    setState(() {
      if(imageFromGall != null){
        _file = File(imageFromGall.path);
        print("this is form camera");
      }else{
        print("image form camera dont have any data");
      }
    });
  }

  Future msgError(String title, String description){
    return Alert(
        context: context,
        type: AlertType.success,
        onWillPopActive: true,
        title: '$title',
        desc: '$description',
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
                child: Center(child: Text('Okay', style: TextStyle(fontSize: 16, color: Colors.black54),))),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            width: 100,
          )
        ]
    ).show();
  }

  void imagePicker(BuildContext context){
    showModalBottomSheet(
        context: context,
        builder: (context){
          return SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: Icon(Icons.library_add, color: Colors.blueAccent,),
                  title: Text('Photo form Gallery', style: TextStyle(color: Colors.blueAccent),),
                  onTap: (){
                    imageFromGallery();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt, color: Colors.blueAccent,),
                  title: Text('Photo form Camera', style: TextStyle(color: Colors.blueAccent),),
                  onTap: (){
                    imageFromCamera();
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          );
        }
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
