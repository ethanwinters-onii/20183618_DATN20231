import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveStorage {
  HiveStorage._internal();

  static final HiveStorage _storage = HiveStorage._internal();

  factory HiveStorage() => _storage;

  // this box stores miscellaneous value
  static Box box = Hive.box("DATN20231");

  // init hive, register adapters
  Future<void> init() async {
    await Hive.initFlutter();
    var openMiscBox = await Hive.openBox("DATN20231");
    // TODO: register adapters below here
    // e.x. await Hive.registerAdapter(ExampleAdapter());
  }
}
