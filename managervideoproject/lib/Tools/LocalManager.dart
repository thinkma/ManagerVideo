import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class passwordManager {

/// 是否设置了密码
  static Future<String> isFristSetPassword() async {
    final prefs = await SharedPreferences.getInstance();
    final String paws = prefs.getString('password') as String;
    if(paws == null){
      return "0";
    }
    return "1";

  }

/// 获取加密密码
  static Future<String> getLocalPassword() async{
    final prefs = await SharedPreferences.getInstance();
    final String paws = prefs.getString('password') as String;
    return paws;
  }

 
/// 设置加密密码
  static setnewLocalPassword(String newPassword) async{
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('password', newPassword);
  }

/// 验证密码是否正确
  static Future<bool> isVialPassword(currentPassord) async {
    final prefs = await SharedPreferences.getInstance();
    final String paws = prefs.getString('password') as String;
    print("paws=${paws}");
    if(currentPassord == paws){
      return true;
    }else{
      return false;
    }
  }

  /// 是否对软件进行加密
  static Future<bool> isVialAddScript() async {
    final prefs = await SharedPreferences.getInstance();
    final String paws = prefs.getString('ispassword') as String;
    if(paws == null){
      return false;
    }
    if(paws == "0"){
      return false;
    }
    return true;
  }

  static setScriptStatue() async{
    final prefs = await SharedPreferences.getInstance();
    var isbool = passwordManager.isVialAddScript();
    isbool.then((value){
      if(value == false){
        prefs.setString('ispassword', "1");
      }else{
         prefs.setString('ispassword', "0");
      }
    });
  }

}