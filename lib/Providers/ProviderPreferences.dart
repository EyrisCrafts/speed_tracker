import 'package:background_locator_example/Global.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderPreferences {
  static resetCount() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt('number', 1);
    });
  }

  static init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Global.isAdmin = prefs.getBool('isAdmin') ?? false;
  }

  static Future<int> countUp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int newNumber = prefs.getInt('number');
    prefs.setInt('number', newNumber + 1);
    return newNumber;
  }

  static Future<int> getCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('number');
  }

  static adminToggle(bool val) {
    SharedPreferences.getInstance()
        .then((value) => value.setBool('isAdmin', val));
  }
}
