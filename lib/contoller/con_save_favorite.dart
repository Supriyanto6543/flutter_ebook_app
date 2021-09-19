import 'package:dio/dio.dart';
import 'package:ebook_app/contoller/api.dart';
import 'package:ebook_app/widget/shared_common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

saveFavorite({
  required BuildContext context,
  required String idCourse,
  required String idUser}) async{

  var data = {'id_course': idCourse, 'id_user': idUser};
  var response = await Dio().post(ApiConstant().baseUrl+ApiConstant().saveFavorite, data: data);

  //check favorites on db
  var checkFav = await Dio().post(ApiConstant().baseUrl+ApiConstant().checkFavorite, data: data);

  if(response.data == "success"){
    await Alert(
        context: context,
        type: AlertType.success,
        onWillPopActive: true,
        title: 'Added to Favorite',
        desc: 'This Manga was Added to your favorite',
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
              saveFavoritesCourse(checkFav.data);
            },
            width: 100,
          )
        ]
    ).show();
  }else{
    await Alert(
        context: context,
        type: AlertType.warning,
        onWillPopActive: true,
        title: 'Delete from Favorite',
        desc: 'This Manga was deleted from your favorite',
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
                    border: Border.all(color: Colors.blue, width: 0.9),
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
              Navigator.of(context).pop(false);
              saveFavoritesCourse(checkFav.data);
            },
            width: 100,
          )
        ]
    ).show();
  }
}