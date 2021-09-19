// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_ebook.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModelEbook _$ModelEbookFromJson(Map<String, dynamic> json) {
  return ModelEbook(
    id: json['id'] as int,
    title: json['title'] as String,
    photo: json['photo'] as String,
    description: json['description'] as String,
    catId: json['catId'] as int,
    statusNews: json['statusNews'] as int,
    pdf: json['pdf'] as String,
    date: json['date'] as String,
    authorName: json['authorName'] as String,
    publisherName: json['publisherName'] as String,
    pages: json['pages'] as int,
    language: json['language'] as String,
    rating: json['rating'] as int,
    free: json['free'] as int,
  );
}

Map<String, dynamic> _$ModelEbookToJson(ModelEbook instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'photo': instance.photo,
      'description': instance.description,
      'catId': instance.catId,
      'statusNews': instance.statusNews,
      'pdf': instance.pdf,
      'date': instance.date,
      'authorName': instance.authorName,
      'publisherName': instance.publisherName,
      'pages': instance.pages,
      'language': instance.language,
      'rating': instance.rating,
      'free': instance.free,
    };
