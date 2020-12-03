import 'package:shared_preferences/shared_preferences.dart';
class HelperFunctions{
  static String sharedPrefenceUserLoggedInKey = 'ISLOGGEDIN';
  static String sharedPreferenceUserNameKey = "USERNAMEKEY";
  static String sharedPreferenceUserEmailKey = "USEREMAILKEY";

  // SAVING DATA

static Future<bool> saveUserLoggedInSharedPreference(bool isUserLoggedIn) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.setBool(sharedPrefenceUserLoggedInKey, isUserLoggedIn);
}


static Future<bool> saveUserNameSharedPreference(String UserName) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserNameKey, UserName);
  }

static Future<bool> saveUserEmailSharedPreference(String Email) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserEmailKey, Email);
  }
//getting data
static Future<bool> getUserLoggedInSharedPreference() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getBool(sharedPrefenceUserLoggedInKey);
  }
static Future<String> getUserNameSharedPreference() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(sharedPreferenceUserNameKey);
  }
static Future<String> getUserEmailSharedPreference() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(sharedPreferenceUserEmailKey);
  }


}