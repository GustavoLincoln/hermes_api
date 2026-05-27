import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveStorageService {
  const HiveStorageService();

  Future<void> initialize() async {
    final directory = await getApplicationSupportDirectory();
    Hive.init(directory.path);
  }

  Future<Box<dynamic>> openBox(String name) {
    return Hive.isBoxOpen(name) ? Future<Box<dynamic>>.value(Hive.box(name)) : Hive.openBox(name);
  }
}
