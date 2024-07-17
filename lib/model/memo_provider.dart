import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:madcamp_week3/model/memo.dart';

import '../constants/urls.dart';

class MemoProvider with ChangeNotifier{
  late List<Memo> _my_memo_lst = [];
  List<Memo> get my_memo_lst => _my_memo_lst;

  late Memo _randomMemo ;
  Memo get randomMemo => _randomMemo;


  Future<bool> loadMyMemos(String token) async {
    var dio = Dio(
      BaseOptions(
        headers: {'Authorization': 'Bearer ${token}'}
      )
    );

    try {
      final response = await dio.get(API_GET_MY_MEMOS_URL);

      dynamic data = response.data;

      _my_memo_lst = (data as List)
          .map((memo) => Memo.fromJson(memo))
          .toList();

      // print(data['data']);

      notifyListeners();
      return true;
    } catch (exception) {
      print(exception);
    }
    return false;
  }

  Future<bool> createMemo(String token, String content, bool private, String date) async{
    var dio = Dio(
        BaseOptions(
            headers: {'Authorization': 'Bearer ${token}'}
        )
    );
    print(token);

    try {
      final response = await dio.post(
          API_POST_MY_MEMOS_URL,
          data: {
            "content": content,
            "date": date,
            "isPrivate": private
          });

      print(response.data);
      // _myuser = User.fromJson(response.data['user']);
      // _token = response.data['token'];


      notifyListeners();
      return true;
    } catch (exception) {
      print(exception);
    }
    return false;

    return true;

  }


  Future<bool> getRandomMemo() async {
    var dio = Dio();

    try {
      final response = await dio.get(API_GET_RANDOM_MEMOS_URL);

      dynamic data = response.data;

      _randomMemo = Memo.fromJson(data);
      // _my_memo_lst = (data as List)
      //     .map((memo) => Memo.fromJson(memo))
      //     .toList();

      // print(data['data']);

      notifyListeners();
      return true;
    } catch (exception) {
      print(exception);
    }
    return false;
  }


}