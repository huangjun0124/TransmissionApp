import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:transmission_app/model/async_ret.dart';
import 'package:transmission_app/model/user.dart';

class SharedPreferenceUtil {
  static const String Account_Key = "TransmissionAccount";

  ///保存账号
  static Future<AsyncReturn> saveUser(TrUser user) async {
    AsyncReturn ret = AsyncReturn();
    SharedPreferences sp = await SharedPreferences.getInstance();
    try {
      ret.isSuccess = await sp.setString(Account_Key, jsonEncode(user));
    } catch (error) {
      ret.message = error.toString();
      ret.isSuccess = false;
    }
    ret.isSuccess = false;
    return ret;
  }

  static Future<TrUser> getUser() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var str = sp.getString(Account_Key);
    if (str == null) return null;
    return TrUser.fromJson(jsonDecode(str));
  }
}
