// class DataModel {
//   String? postId;
//   String? id;
//   String? name;
//   String? email;
//   String? body;


//   DataModel({
//     this.body,
//     this.email,
//     this.id,
//     this.name,
//     this.postId
//   });


//   factory DataModel.fromJson(Map<String, dynamic> data){
//     return DataModel(
//       body: data["body"] ?? "N/A",
//       email: data["email"] ?? "N/A",
//       id: data["id"] ?? "N/A",
//       name: data["name"] ?? "N/A",

//     )
//   }
// }


import 'package:hive_flutter/adapters.dart';
part 'data_model.g.dart';

@HiveType(typeId: 0)
class DataModel extends HiveObject{

  @HiveField(0)
  final String? postId;

  @HiveField(1)
  final String? id;

  @HiveField(2)
  final String? name;

  @HiveField(3)
  final String? email;

  @HiveField(4)
  final String? body;

  DataModel({
    this.body,
    this.email,
    this.id,
    this.name,
    this.postId
  });


  factory DataModel.fromJson(Map<String, dynamic> data){
    return DataModel(
      body: data["body"] ?? "N/A",
      email: data["email"] ?? "N/A",
      id: data["id"].toString(),
      name: data["name"].toString(),

    );
  }

}