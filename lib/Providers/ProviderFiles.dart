import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:background_locator_example/Models/CarSpeed.dart';
import 'dart:developer' as dev;
import 'package:shared_preferences/shared_preferences.dart';

class ProviderFiles {
  static Future<List<String>> listFiles() async {
    final Directory directory = await getTemporaryDirectory();

    List<FileSystemEntity> lst = await directory.list().toList();
    List<String> toReturn = lst
        .map((e) => e.path.split('/').last)
        .toList()
        .where((element) => element.startsWith('data'))
        .toList();
    return toReturn;
  }

  static clearHistory() async {
    final Directory directory = await getTemporaryDirectory();

    List<FileSystemEntity> list = await directory.list().toList();
    list
        .where((element) => element.path.split('/').last.startsWith('data'))
        .forEach((element) {
      element.delete();
    });
  }

  static Future<List<CarSpeed>> getDocumentSpeeds(
      int number, String filename) async {
    //Return 6 speeds
    final file = await _getTempLogFile(filename);

    return ListCarSpeed.fromJson(await file.readAsString())
        .list
        .reversed
        .toList()
        .take(number)
        .toList();
  }

  static Future<String> getFileName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('name');
  }

  static Future<void> resetFileName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(
        'name', 'Data' + DateTime.now().millisecondsSinceEpoch.toString());
  }

  static Future<List<CarSpeed>> readLogFile(String fileName) async {
    final file = await _getTempLogFile(fileName);
    String text = await file.readAsString();

    if (text == null || text == "") return List();
    return ListCarSpeed.fromJson(await file.readAsString()).getList;
  }

  static writeToLogFile(CarSpeed log, String fileName) async {
    final file = await _getTempLogFile(fileName);
    //Read list
    List<CarSpeed> list = await readLogFile(fileName);
    //Add
    list.add(log);
    //Write list
    await file.writeAsString(ListCarSpeed(list: list).toJson(),
        mode: FileMode.write);
  }

  static Future<File> _getTempLogFile(String fileName) async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/$fileName');
    if (!await file.exists()) {
      await file.writeAsString('');
    }
    return file;
  }
}
