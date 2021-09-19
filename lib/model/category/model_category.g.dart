// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModelCategory _$ModelCategoryFromJson(Map<String, dynamic> json) {
  return ModelCategory(
    catId: json['catId'] as int,
    photoCat: json['photoCat'] as String,
    name: json['name'] as String,
    status: json['status'] as int,
  );
}

Map<String, dynamic> _$ModelCategoryToJson(ModelCategory instance) =>
    <String, dynamic>{
      'catId': instance.catId,
      'photoCat': instance.photoCat,
      'name': instance.name,
      'status': instance.status,
    };
