import 'package:hive_flutter/adapters.dart';
import 'package:machine_test/model/data_model.dart';

class HomeScreenController {
  static const String boxName = "dataBox";

  static Future<void> saveDatas(List<DataModel> data) async {
    final box = await Hive.openBox<DataModel>(boxName);

    await box.clear();
    await box.addAll(data);
  }

  static Future<List<DataModel>> fetchDatas() async {
    final box = await Hive.openBox<DataModel>(boxName);

    return box.values.toList();
  }
}
