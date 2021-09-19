import 'package:dio/dio.dart';
import 'package:ebook_app/contoller/api.dart';
import 'package:ebook_app/model/ebook/model_ebook.dart';

Future<List<ModelEbook>> fetchComing(List<ModelEbook> latest) async{
  var response = await Dio().get(ApiConstant().baseUrl+ApiConstant().api+ApiConstant().coming);
  for(Map<String, dynamic> sliderData in response.data){
    latest.add(ModelEbook(id: sliderData['id'],
        title: sliderData['title'],
        photo: sliderData['photo'],
        description: sliderData['description'],
        catId: sliderData['cat_id'],
        statusNews: sliderData['status_news'],
        pdf: sliderData['pdf'],
        date: sliderData['date'],
        authorName: sliderData['author_name'],
        publisherName: sliderData['publisher_name'],
        pages: sliderData['pages'],
        language: sliderData['language'],
        rating: sliderData['rating'],
        free: sliderData['free']));
  }
  return latest;
}