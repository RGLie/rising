import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:madcamp_week3/model/memo.dart';

import '../constants/urls.dart';

class MemoProvider with ChangeNotifier{
  late List<Memo> _my_memo_lst = [];
  List<Memo> get my_memo_lst => _my_memo_lst;

  late Memo _randomMemo;
  Memo get randomMemo => _randomMemo;


  Future<bool> loadMyMemos(String token) async {
    var dio = Dio(
      BaseOptions(
        headers: {'Authorization': token}
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


  Future<bool> getRandomMemo(String token) async {
    var dio = Dio(
      BaseOptions(
          headers: {'Authorization': token}
      )
    );

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