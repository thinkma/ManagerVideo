import 'package:flutter/services.dart';

class Tools {
  static const MethodChannel _channel = MethodChannel('yzp.cn/tools');

  Future<String> get lastShareFilePath async {
    String path = await _channel.invokeMethod('getLastShareFilePath');
    return path;
  }

  Future<bool> get clearLastShareFilePath async {
    bool status = await _channel.invokeMethod('clearLastShareFilePath');
    return status;
  }

   Future<String> get lastMessageFilePath async {
    String path = await _channel.invokeMethod('getLastMessageFilePath');
    return path;
  }

  Future<bool> get clearMessageFilePath async {
    bool status = await _channel.invokeMethod('clearLastMessageFilePath');
    return status;
  }
}