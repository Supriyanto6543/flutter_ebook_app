import 'package:json_annotation/json_annotation.dart';
part 'model_ebook.g.dart';

@JsonSerializable()
class ModelEbook{
  int id;
  String title;
  String photo;
  String description;
  int catId;
  int statusNews;
  String pdf;
  String date;
  String authorName;
  String publisherName;
  int pages;
  String language;
  int rating;
  int free;

  ModelEbook({
    required this.id,
    required this.title,
    required this.photo,
    required this.description,
    required this.catId,
    required this.statusNews,
    required this.pdf,
    required this.date,
    required this.authorName,
    required this.publisherName,
    required this.pages,
    required this.language,
    required this.rating,
    required this.free});

  factory ModelEbook.fromJson(Map<String, dynamic> json) => _$ModelEbookFromJson(json);

  Map<String, dynamic> toJson() => _$ModelEbookToJson(this);
}