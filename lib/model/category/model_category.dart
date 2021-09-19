import 'package:json_annotation/json_annotation.dart';
part 'model_category.g.dart';

@JsonSerializable()
class ModelCategory{
  int catId;
  String photoCat;
  String name;
  int status;

  ModelCategory({
    required this.catId,
    required this.photoCat,
    required this.name,
    required this.status});

  factory ModelCategory.fromJson(Map<String, dynamic> json) => _$ModelCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$ModelCategoryToJson(this);
}