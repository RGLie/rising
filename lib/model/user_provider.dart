import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_session_jwt/flutter_session_jwt.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:madcamp_week3/constants/urls.dart';
import 'package:madcamp_week3/model/user.dart';


class UserProvider with ChangeNotifier{
  String _token = "";
  String get token => _token;

  User? _myuser = null;
  User? get myuser => _myuser;

  bool _isValid = false;
  bool get isValid => _isValid;

  final storage = FlutterSecureStorage();


  Future<bool> register(String userName , String password, String email) async{
    var dio = Dio();

    try {
      final response = await dio.post(
          API_REGISTER_URL,
          data: {
            "username": userName,
            "password": password,
            "email": email
          });

      _myuser = User.fromJson(response.data['user']);
      _token = response.data['token'];


      notifyListeners();
      return true;
    } catch (exception) {
      print(exception);
    }
    return false;

    return true;

  }




  Future<bool> login(String userName , String password) async{
    var dio = Dio();
    try {
      final response = await dio.post(
          API_LOGIN_URL,
          data: {
            "username": userName,
            "password": password,
          });

      _myuser = User.fromJson(response.data['user']);
      _token = response.data['token'];


      notifyListeners();
      return true;
    } catch (exception) {
      print(exception);
    }
    return false;
  }

  Future<void> storeToken() async {
    await storage.write(key: 'jwt_token', value: _token);
    notifyListeners();
  }

  Future<String?> getToken() async {
    notifyListeners();
    return await storage.read(key: 'jwt_token');

  }

  bool isTokenExpired() {
    _isValid = JwtDecoder.isExpired(_token);
    notifyListeners();
    return _isValid;
  }


  Future<void> logout() async {
    _token = "";
    _isValid = false;
    _myuser = null;


    await Future.wait([
      storage.delete(key: 'jwt_token'),
    ]);

    notifyListeners();
  }
}