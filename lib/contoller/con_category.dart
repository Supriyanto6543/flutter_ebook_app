import 'package:dio/dio.dart';
import 'package:ebook_app/contoller/api.dart';
import 'package:ebook_app/model/category/model_category.dart';
import 'package:ebook_app/model/ebook/model_ebook.dart';

Future<List<ModelCategory>> fetchCategory(List<ModelCategory> slider) async{
  var response = await Dio().get(ApiConstant().baseUrl+ApiConstant().api+ApiConstant().category);
  for(Map<String, dynamic> sliderData in response.data){
    slider.add(ModelCategory(
        catId: sliderData['cat_id'],
        photoCat: sliderData['photo_cat'],
        name: sliderData['name'],
        status: sliderData['status']));

  }
  return slider;
}