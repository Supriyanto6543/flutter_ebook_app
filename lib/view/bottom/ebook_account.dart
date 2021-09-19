import 'dart:io';
import 'package:dio/dio.dart';
import 'package:ebook_app/contoller/api.dart';
import 'package:ebook_app/view/login/login.dart';
import 'package:ebook_app/widget/ebook_routers.dart';
import 'package:ebook_app/widget/shared_common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class EbookAccount extends StatefulWidget {
  @override
  _EbookAccountState createState() => _EbookAccountState();
}

class _EbookAccountState extends State<EbookAccount> {

  String photoBase64 = "";
  String id = "";
  String name = "";
  String email = "";
  late bool isTheme = true;
  late SharedPreferences preferences;
  PackageInfo info = PackageInfo(
      appName: 'ss',
      packageName: '',
      version: '',
      buildNumber: '');
  late File _file = File('');
  final picker = ImagePicker();

  Future<void> packageInfoApp() async{
    PackageInfo infos = await PackageInfo.fromPlatform();
    setState(() {
      info = infos;
    });
  }

  @override
  void initState() {
    super.initState();
    prefLoad().then((value) {
      setState(() {
        id = value[0];
        name = value[1];
        email = value[2];
        getPhoto(id);
      });
    });

    packageInfoApp();
  }

  imageFromGallery() async{
    var imageFromGallery = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if(imageFromGallery != null){
        _file = File(imageFromGallery.path);
        print("path Image of $_file");
      }else{
        print("No image selected");
      }
    });
  }

  imageFromCamera() async{
    var imageFromGallery = await picker.getImage(source: ImageSource.camera, imageQuality: 100, maxHeight: 100.0, maxWidth: 100.0);
    setState(() {
      if(imageFromGallery != null){
        _file = File(imageFromGallery.path);
        print("path Image of Camera $_file");
      }else{
        print("No image selected");
      }
    });
  }

  Future updatePhotoProfile() async{
    var req = http.MultipartRequest('POST', Uri.parse(ApiConstant().baseUrl+ApiConstant().updatePhoto));
    req.fields['iduser'] = id;
    var photo = await http.MultipartFile.fromPath("photo", _file.path);
    req.files.add(photo);
    var response = await req.send();
    if(response.statusCode == 200){
      setState(() {
        _file = File('');
      });
      getPhoto(id);
    }
  }

  Future getPhoto(String idUser) async{
    var response = await Dio().post(ApiConstant().baseUrl+ApiConstant().viewPhoto, data: {'id': idUser});
    var decode = response.data;
    if(decode != "no_img"){
      setState(() {
        photoBase64 = decode;
      });
    }else{
      setState(() {
        photoBase64 = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar:PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: AppBar(
              title: Text('Account', style: TextStyle(
                  fontFamily: "Macklin",
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 19
              ),),
              backgroundColor: Colors.white,
              elevation: 0,
              actions: [
                GestureDetector(
                  onTap: (){
                    updatePhotoProfile();
                  },
                  child: _file.path != '' ? Center(
                    child: Text('Save', style: TextStyle(
                        fontFamily: "Macklin",
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 19
                    ), textAlign: TextAlign.center,),
                  ) : Text(''),
                ),
                SizedBox(width: 10,)
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 25, left: 9, right: 9),
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        imagePicker(context);
                      },
                      child: Container(
                          height: 15.h,
                          width: MediaQuery.of(context).size.width,
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              photoBase64 != '' ? ClipRRect(borderRadius: BorderRadius.circular(100.0),
                                  child: Image.network('$photoBase64',
                                    fit: BoxFit.cover,
                                    width: 30.0.w,
                                    height: 30.0.h,)) :
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100.0),
                                child: Image.asset('assets/image/register.png',
                                  width: 30.0.w,
                                  height: 30.0.h,
                                  fit: BoxFit.cover,),
                              ),
                              _file.path == '' ? Text('') : Text(' Change To -> ', style: TextStyle(color: Colors.black),),
                              _file.path == '' ? Text('') : ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: _file.path == '' ? Image.asset('assets/image/register.png',
                                  width: 30.0.w,
                                  height: 30.0.h,
                                  fit: BoxFit.cover,) : Image.file(_file,
                                  width: 30.0.w,
                                  height: 30.0.h,
                                  fit: BoxFit.cover,),
                              ),
                            ],
                          )
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15.sp),
                      child: Text(name, style: TextStyle(
                          fontFamily: "Macklin",
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 19
                      ),),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(Icons.email_outlined, color: Colors.red,),
                        SizedBox(width: 10,),
                        Container(
                          margin: EdgeInsets.only(top: 10.sp),
                          child: Text(email, style: TextStyle(
                              fontFamily: "Macklin",
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              fontSize: 18
                          ),),
                        ),
                      ],
                    ),
                    //support Edumy
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        margin: EdgeInsets.only(top: 25.sp),
                        child: Text('Ebook App Support', style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            fontSize: 14
                        ),),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                        onTap: (){
                          _openAbout();
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 15.sp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Text('About MangaBook', style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w700,
                                ),),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                        onTap: (){
                          _giveRating();
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 15.sp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Text('Give a rating', style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w700,
                                ),),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                        onTap: (){
                          _share();
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 15.sp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Text('Share App', style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w700,
                                ),),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                        onTap: (){
                          _giveRating();
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 15.sp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Text('More Apps', style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w700,
                                ),),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async{
                        preferences = await SharedPreferences.getInstance();
                        preferences.remove("login");
                        pushPageAndRemove(context, Login());
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 10.sp, bottom: 10.sp),
                        child: Text('Logout', style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),),
                      ),
                    ),

                    GestureDetector(
                      onTap: ()=>pushPageAndRemove(context, Login()),
                      child: Container(
                        margin: EdgeInsets.only(top: 10.sp, bottom: 10.sp),
                        // ignore: unnecessary_statements
                        child: Text('${info.appName} ${info.version}', style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
      ),
    );
  }

  void imagePicker(BuildContext context){
    showModalBottomSheet(context: context,
        builder: (BuildContext buildContext){
          return SafeArea(
            child: Container(
              child: Wrap(
                children: [
                  ListTile(
                      leading: Icon(Icons.library_add_outlined),
                      title: Text('Photo from Library'),
                      onTap: (){
                        imageFromGallery();
                        Navigator.pop(context);
                      }
                  ),
                  ListTile(
                      leading: Icon(Icons.camera_alt),
                      title: Text('Photo from Camera'),
                      onTap: (){
                        imageFromCamera();
                        Navigator.pop(context);
                      }
                  )
                ],
              ),
            ),
          );
        });
  }

  _giveRating() async{
    PackageInfo pi = await PackageInfo.fromPlatform();
    await canLaunch("https://play.google.com/store/apps/details?id=${pi.packageName}") ?
    await launch("https://play.google.com/store/apps/details?id=${pi.packageName}") : throw 'Could not launch url';
  }

  _share() async{
    PackageInfo pi = await PackageInfo.fromPlatform();
    Share.share("Learning free Online Course on ${pi.appName}" '\n'"Download now: https://play.google.com/store/apps/details?id=${pi.packageName}");
  }

  _openAbout() async{
    await canLaunch("http://edumy.go-cow.com/about.html") ?
    await launch("http://edumy.go-cow.com/about.html") : throw 'Could not launch url';
  }

}
