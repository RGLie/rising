import 'package:flutter/cupertino.dart';

class ScreenProvider with ChangeNotifier{
  bool _isClicked = false;
  bool get isClicked => _isClicked;

  bool _myCardClicked = false;
  bool get myCardClicked => _myCardClicked;

  String _myCardText = "";
  String get myCardText => _myCardText;

  void setClicked(){
    _isClicked = true;
    notifyListeners();
  }

  void setNoClicked(){
    _isClicked = false;
    notifyListeners();
  }


  void setMyCardClicked(){
    _myCardClicked = true;
    notifyListeners();
  }

  void setMyCardText(String text){
    _myCardText = text;
    notifyListeners();
  }

  void setMyCardNoClicked(){
    _myCardClicked = false;
    notifyListeners();
  }
}