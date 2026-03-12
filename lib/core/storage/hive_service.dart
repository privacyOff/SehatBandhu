import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const appointmentsBox = 'appointments_cache';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<Map>(appointmentsBox);
  }

  static Box<Map> get appointmentCache => Hive.box<Map>(appointmentsBox);
}
