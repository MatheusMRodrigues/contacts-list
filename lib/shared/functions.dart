import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:technical/utils/viacep.dart';

ImageProvider decodeAvatar(String? encodedAvatar) {
  if (encodedAvatar == null) {
    return const AssetImage(
        'assets/avatar.png');
  }
  var decodedImage = const Base64Decoder().convert(encodedAvatar);
  return MemoryImage(decodedImage);
}

getAddressFromZipCode(String zipCode) async {
  try {
    var response = await Dio().get('https://viacep.com.br/ws/$zipCode/json/');
    Logger().i(response);
    if(jsonDecode(jsonEncode(response.data))['erro'] == 'true') {
      throw Exception(['Erro']);
    }
    return ViaCep.fromJson(response.data);
  } catch (e) {
    Logger().e(e);
    rethrow;
  }
}

getAccessContactPermission() async {
  PermissionStatus status = await Permission.contacts.status;
  if (status != PermissionStatus.granted) {
    status = await Permission.contacts.request();
  }
  return status;
}


getDeviceContacts() {

}
