import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:machine_test/controller/home_screen_controller.dart';
import 'package:machine_test/model/data_model.dart';

class DataListService {
  static Future<List<DataModel>> fetchDataLists() async {
    try {
      final url = Uri.parse("https://jsonplaceholder.typicode.com/comments");
      final response = await http.get(url);

      print("reposne of data fetch : ${response.statusCode}, ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);

        List<DataModel> dataLists =
            responseData.map((item) => DataModel.fromJson(item)).toList();
        HomeScreenController.saveDatas(dataLists);
        return dataLists;
      } else {
        return [];
      }
    } catch (e) {
      print("Catch error $e");
      return [];
    }
  }
}
