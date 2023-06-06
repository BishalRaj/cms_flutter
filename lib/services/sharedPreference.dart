import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  saveLoginDetails(String userType, String username, String branch) async {
    var prefs = await getInstance();
    // await SharedPreferences.getInstance();
    await prefs.setString('userType', userType);
    await prefs.setString('username', username);
    await prefs.setString('branch', branch);
  }

  fetchLoginDetails() async {
    var prefs = await getInstance();

    try {
      final userType = await prefs.getString('userType');
      final username = await prefs.getString('username');
      final branch = await prefs.getString('branch');
      final userdata = {
        'userType': userType,
        'username': username,
        'branch': branch
      };
      return userdata;
    } catch (e) {
      print(e);
    }
  }

  removeLoginDetails() async {
    print('@remove data');
    var prefs = await getInstance();
    await prefs.remove('userType');
    await prefs.remove('username');
  }

  getInstance() async {
    return await SharedPreferences.getInstance();
  }
}
