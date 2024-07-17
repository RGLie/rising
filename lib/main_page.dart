import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:madcamp_week3/home_page.dart';
import 'package:madcamp_week3/model/memo_provider.dart';
import 'package:madcamp_week3/model/user_provider.dart';
import 'package:madcamp_week3/my_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'ball_simulation_2.dart';
import 'model/screen_provider.dart';
import 'object/moon.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}


class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin  {
  final _idController = TextEditingController();
  final _contentController = TextEditingController();
  final _pwController = TextEditingController();
  bool _isChecked = true;

  DateTime? newdate = DateTime.now();


  late AnimationController _fadecontroller;
  late Animation<double> _fadeanimation;
  bool _isFadeClicked = false;

  @override
  void initState() {
    super.initState();


    _fadecontroller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )
      ..addListener(() {
        setState(() {});
      });
    _fadeanimation =
        Tween<double>(begin: 0.0, end: 15.0).animate(CurvedAnimation(
          parent: _fadecontroller,
          curve: Curves.easeOut,
        ));

    final sp = Provider.of<ScreenProvider>(context, listen: false);
    final mm = Provider.of<MemoProvider>(context, listen: false);
    mm.getRandomMemo();
    sp.addListener(() {
      if(sp.isClicked){
        _fadecontroller.forward(from: 0.0);
      }
      else{
        _fadecontroller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _fadecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final screenProvider = Provider.of<ScreenProvider>(context);
    final memoProvider = Provider.of<MemoProvider>(context);


    return Scaffold(

      body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color(0xffD58BD6),
                Color(0xff805EC5),
                Color(0xff313181),


              ],
            ),
          ),
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              Container(
                padding: EdgeInsets.only(top: 15, left: 30),
                child: Text('떠오르다',
                  style: TextStyle(color: Colors.white, fontSize: 36, fontFamily: 'GowunBatang',)
                ),
              ),
              Container(
                  padding: EdgeInsets.all(50),
                  child: Moon()
              ),
              PhysicsDemo(),

              if (_fadecontroller.value > 0)
                GestureDetector(
                  onTap: (){
                    screenProvider.setNoClicked();
                    memoProvider.getRandomMemo();
                  },
                  child: Stack(
                    children: [
                      Container(
                        width: double.maxFinite,
                        height: double.maxFinite,
                        color: Colors.black.withOpacity(_fadeanimation.value/45),
                      ),

                      Center(
                        child: ClipRect(
                          child: OverflowBox(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: _fadeanimation.value,
                                sigmaY: _fadeanimation.value,
                              ),
                              child: Container(
                                width: double.maxFinite,
                                height: double.maxFinite,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  // color: Colors.black.withOpacity(0.1),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Center(
                          child: Center(
                              child: Container(
                                  width: MediaQuery.of(context).size.width*0.85,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(memoProvider.randomMemo.content,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(_fadeanimation.value/15), fontSize: 55, fontFamily: 'GowunBatang',
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Text(
                                        '${memoProvider.randomMemo.date.split('-')[0]}년 ${memoProvider.randomMemo.date.split('-')[1]}월 ${memoProvider.randomMemo.date.split('-')[2]}일',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(_fadeanimation.value/15), fontSize: 40, fontFamily: 'GowunBatang',
                                        ),
                                      ),
                                    ],
                                  )
                              )
                          )
                      )
                    ]
                  ),
                ),

            ],
          )
      ),
      floatingActionButton: Container(
        width: 150,
        height: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            width: 0.5,
            color: Colors.white,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30,
              child: FloatingActionButton(
                heroTag: 'home',
                onPressed: () {
                  // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomePage()));
                  Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: HomePage()));

                },
                child: Icon(Icons.home_outlined, color: Colors.white, size: 20,),
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.transparent,
                tooltip: 'HOME',
                elevation: 0,
                focusElevation: 0.1,
                hoverElevation: 0.1,
                focusColor: Colors.white.withOpacity(0.6),
                hoverColor: Colors.white.withOpacity(0.2),
                splashColor: Colors.transparent,
              ),
            ),
            SizedBox(width: 15,),
            Container(
              width: 30,
              child: FloatingActionButton(
                heroTag: 'add',
                onPressed: () {
                  if(userProvider.token == ""){
                    showGeneralDialog(
                        context: context,
                        barrierDismissible: true,
                        barrierLabel: '',
                        transitionDuration: const Duration(milliseconds: 300),
                        pageBuilder: (context, animation1, animation2){
                          return Container();
                        },
                        transitionBuilder: (context, a1, a2, widget){
                          return ScaleTransition(
                            scale: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
                            child: FadeTransition(
                                opacity: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
                                child: AlertDialog(
                                  backgroundColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.white,
                                        width: 0.5
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),

                                  //Dialog Main Title
                                  title: Column(
                                    children: <Widget>[
                                      new Text(
                                        "로그인",
                                        style:
                                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  content: Container(
                                    height: 150,
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          controller: _idController,
                                          minLines: 1,
                                          maxLines: 1,
                                          keyboardType: TextInputType.multiline,
                                          cursorColor: Colors.white,
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14),
                                          decoration: InputDecoration(
                                            // icon: Icon(Icons.note_add_outlined),
                                              suffixIcon: Icon(Icons.account_circle_outlined, color: Colors.white,),
                                              fillColor: Colors.transparent,
                                              isDense: true,
                                              contentPadding: EdgeInsets.all(15),
                                              filled: true,
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(15),
                                                ),
                                                borderSide: BorderSide(color:Colors.white, width: 0),
                                              ),
                                              // helperText: '',
                                              hintText: '아이디를 입력하세요',
                                              floatingLabelStyle: TextStyle(color:Colors.white),
                                              hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                                              labelText: '아이디',
                                              labelStyle: TextStyle(fontSize: 12,  color: Colors.grey),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                                borderSide: BorderSide(
                                                    color: Colors.white, width: 1.5),
                                              )
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "내용을 입력해주세요";
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        TextFormField(
                                          controller: _pwController,
                                          minLines: 1,
                                          maxLines: 1,
                                          keyboardType: TextInputType.multiline,
                                          obscureText: true,
                                          enableSuggestions: false,
                                          autocorrect: false,
                                          cursorColor: Colors.white,
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14),
                                          decoration: InputDecoration(
                                            // icon: Icon(Icons.note_add_outlined),
                                              suffixIcon: Icon(Icons.lock_outline, color: Colors.white,),
                                              fillColor: Colors.transparent,
                                              isDense: true,
                                              contentPadding: EdgeInsets.all(15),
                                              filled: true,
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(15),
                                                ),
                                                borderSide: BorderSide(color:Colors.white, width: 0),
                                              ),
                                              // helperText: '',
                                              hintText: '패스워드를 입력하세요',
                                              floatingLabelStyle: TextStyle(color:Colors.white),
                                              hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                                              labelText: '패스워드',
                                              labelStyle: TextStyle(fontSize: 12,  color: Colors.grey),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                                borderSide: BorderSide(
                                                    color: Colors.white, width: 1.5),
                                              )
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "패스워드를 입력해주세요";
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(height: 8,),

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text('계정이 없다면',
                                              style: TextStyle(
                                                  color: Colors.white60,
                                                  fontSize: 12
                                              ),
                                            ),
                                            SizedBox(width: 5,),
                                            InkWell(
                                              onTap: (){
                                                Navigator.pop(context);
                                                _openAnimateDialog(context);
                                              },
                                              child: Text('회원가입',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 5,),
                                            Text('하세요.',
                                              style: TextStyle(
                                                  color: Colors.white60,
                                                  fontSize: 12
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  actionsAlignment: MainAxisAlignment.center,
                                  actions: <Widget>[
                                    new ElevatedButton(
                                      child: new Text("로그인", style: TextStyle(color: Colors.white),),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent),
                                      onPressed: () async{
                                        // try {
                                        print('login cliicked');
                                        bool isToken = await userProvider.login(_idController.text, _pwController.text);
                                        // print(userProvider.token);

                                        if(isToken){
                                          Fluttertoast.showToast(
                                              msg: "로그인에 성공하였습니다",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              webPosition: "center",
                                              // backgroundColor: Colors.white,
                                              webBgColor: "linear-gradient(to right, #4299f5, #4299f5, #4299f5)",
                                              textColor: Colors.white,
                                              fontSize: 16.0
                                          );

                                          Navigator.pop(context);
                                          // Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: MyPage()));
                                        }
                                        else{
                                          Fluttertoast.showToast(
                                              msg: "로그인에 실패하였습니다",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              webPosition: "center",
                                              // backgroundColor: Colors.white,
                                              webBgColor: "linear-gradient(to right, #f54242, #f54242, #f54242)",
                                              textColor: Colors.white,
                                              fontSize: 16.0
                                          );
                                        }
                                        //   await userProvider.storeToken();
                                        //
                                        //   if (userProvider.isTokenExpired()) {
                                        //     print('Token is expired');
                                        //   } else {
                                        //     Navigator.pop(context);
                                        //     print('Token is valid');
                                        //   }
                                        // } catch (e) {
                                        //   print('Error: $e');
                                        // }
                                      },
                                    ),
                                    new ElevatedButton(
                                      child: new Text("닫기", style: TextStyle(color: Colors.white),),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                )
                            ),
                          );
                        }
                    );
                  }
                  else{

                    showGeneralDialog(
                        context: context,
                        barrierDismissible: true,
                        barrierLabel: '',
                        transitionDuration: const Duration(milliseconds: 300),
                        pageBuilder: (context, animation1, animation2){
                          return Container();
                        },
                        transitionBuilder: (context, a1, a2, widget){
                          return ScaleTransition(
                            scale: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
                            child: FadeTransition(
                                opacity: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
                                child: AlertDialog(
                                  backgroundColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.white,
                                        width: 0.5
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),

                                  //Dialog Main Title
                                  title: Column(
                                    children: <Widget>[
                                      new Text(
                                        "작성하기",
                                        style:
                                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  content: StatefulBuilder(
                                      builder: (BuildContext context, StateSetter setState) {
                                        return Container(
                                          height: 180,
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Icon(Icons.calendar_month_outlined, color: Colors.white, size: 17,),
                                                  SizedBox(width: 8,),
                                                  InkWell(
                                                    onTap: () async{
                                                      newdate = await showDatePicker(
                                                        context: context,
                                                        initialDate: DateTime.now(),
                                                        firstDate: DateTime(1900),
                                                        lastDate: DateTime(2100),
                                                      );

                                                      if(newdate == null){
                                                        return;
                                                      }
                                                      else{

                                                      }

                                                    },
                                                    child: Text(DateFormat("yyyy년 MM월 dd일").format(newdate!),
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14
                                                      ),
                                                    ),
                                                  ),



                                                ],
                                              ),

                                              SizedBox(height: 15,),

                                              TextFormField(
                                                controller: _contentController,
                                                minLines: 3,
                                                maxLines: 3,
                                                keyboardType: TextInputType.multiline,
                                                cursorColor: Colors.white,
                                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14),
                                                decoration: InputDecoration(
                                                  // icon: Icon(Icons.note_add_outlined),
                                                  //   suffixIcon: Icon(Icons.account_circle_outlined, color: Colors.white,),
                                                    fillColor: Colors.transparent,
                                                    isDense: true,
                                                    contentPadding: EdgeInsets.all(15),
                                                    filled: true,
                                                    enabledBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(15),
                                                      ),
                                                      borderSide: BorderSide(color:Colors.white, width: 0),
                                                    ),
                                                    // helperText: '',
                                                    hintText: '내용을 입력하세요',
                                                    floatingLabelStyle: TextStyle(color:Colors.white),
                                                    hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                                                    labelText: '내용',
                                                    labelStyle: TextStyle(fontSize: 12,  color: Colors.grey),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                                      borderSide: BorderSide(
                                                          color: Colors.white, width: 1.5),
                                                    )
                                                ),
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return "내용을 입력해주세요";
                                                  }
                                                  return null;
                                                },
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),

                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [


                                                  SizedBox(
                                                    height:30,
                                                    child: FittedBox(
                                                      fit: BoxFit.fill,
                                                      child: Switch(
                                                        value: _isChecked,
                                                        activeTrackColor: Colors.transparent,
                                                        inactiveTrackColor: Colors.transparent,
                                                        trackOutlineColor: MaterialStateProperty.all<Color>(Colors.white),
                                                        trackOutlineWidth: MaterialStateProperty.all(0.5),
                                                        inactiveThumbColor: Colors.white.withOpacity(0.5),
                                                        onChanged: (value) {
                                                          setState(() {
                                                            _isChecked = value;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10,),
                                                  Text(_isChecked?'공개':'비공개',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14
                                                    ),
                                                  ),
                                                ],
                                              ),

                                            ],
                                          ),
                                        );
                                      }
                                  ),
                                  actionsAlignment: MainAxisAlignment.center,
                                  actions: <Widget>[
                                    new ElevatedButton(
                                      child: new Text("완료", style: TextStyle(color: Colors.white),),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent),
                                      onPressed: () async {

                                        bool isCreated = await memoProvider.createMemo(userProvider.token, _contentController.text, !_isChecked, DateFormat("yyyy-MM-dd").format(newdate!));





                                        Navigator.pop(context);
                                      },
                                    ),
                                    new ElevatedButton(
                                      child: new Text("닫기", style: TextStyle(color: Colors.white),),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                )
                            ),
                          );
                        }
                    );



                  }

                },
                child: Icon(Icons.edit_outlined, color: Colors.white, size: 20,),
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.transparent,
                tooltip: 'ADD',
                elevation: 0,
                focusElevation: 0.1,
                hoverElevation: 0.1,
                focusColor: Colors.white.withOpacity(0.6),
                hoverColor: Colors.white.withOpacity(0.2),
                splashColor: Colors.transparent,
              ),
            ),
            SizedBox(width: 15,),
            Container(
              width: 30,
              child: Builder(
                  builder: (context) {
                    return FloatingActionButton(
                      heroTag: 'login',
                      onPressed: () {
                        if(userProvider.token != ""){
                          Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: MyPage()));
                        }
                        else{
                          showGeneralDialog(
                              context: context,
                              barrierDismissible: true,
                              barrierLabel: '',
                              transitionDuration: const Duration(milliseconds: 300),
                              pageBuilder: (context, animation1, animation2){
                                return Container();
                              },
                              transitionBuilder: (context, a1, a2, widget){
                                return ScaleTransition(
                                  scale: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
                                  child: FadeTransition(
                                      opacity: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
                                      child: AlertDialog(
                                        backgroundColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Colors.white,
                                              width: 0.5
                                          ),
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),

                                        //Dialog Main Title
                                        title: Column(
                                          children: <Widget>[
                                            new Text(
                                              "로그인",
                                              style:
                                              TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        content: Container(
                                          height: 150,
                                          child: Column(
                                            children: [
                                              TextFormField(
                                                controller: _idController,
                                                minLines: 1,
                                                maxLines: 1,
                                                keyboardType: TextInputType.multiline,
                                                cursorColor: Colors.white,
                                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14),
                                                decoration: InputDecoration(
                                                  // icon: Icon(Icons.note_add_outlined),
                                                    suffixIcon: Icon(Icons.account_circle_outlined, color: Colors.white,),
                                                    fillColor: Colors.transparent,
                                                    isDense: true,
                                                    contentPadding: EdgeInsets.all(15),
                                                    filled: true,
                                                    enabledBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(15),
                                                      ),
                                                      borderSide: BorderSide(color:Colors.white, width: 0),
                                                    ),
                                                    // helperText: '',
                                                    hintText: '아이디를 입력하세요',
                                                    floatingLabelStyle: TextStyle(color:Colors.white),
                                                    hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                                                    labelText: '아이디',
                                                    labelStyle: TextStyle(fontSize: 12,  color: Colors.grey),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                                      borderSide: BorderSide(
                                                          color: Colors.white, width: 1.5),
                                                    )
                                                ),
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return "내용을 입력해주세요";
                                                  }
                                                  return null;
                                                },
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              TextFormField(
                                                controller: _pwController,
                                                minLines: 1,
                                                maxLines: 1,
                                                keyboardType: TextInputType.multiline,
                                                obscureText: true,
                                                enableSuggestions: false,
                                                autocorrect: false,
                                                cursorColor: Colors.white,
                                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14),
                                                decoration: InputDecoration(
                                                  // icon: Icon(Icons.note_add_outlined),
                                                    suffixIcon: Icon(Icons.lock_outline, color: Colors.white,),
                                                    fillColor: Colors.transparent,
                                                    isDense: true,
                                                    contentPadding: EdgeInsets.all(15),
                                                    filled: true,
                                                    enabledBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(15),
                                                      ),
                                                      borderSide: BorderSide(color:Colors.white, width: 0),
                                                    ),
                                                    // helperText: '',
                                                    hintText: '패스워드를 입력하세요',
                                                    floatingLabelStyle: TextStyle(color:Colors.white),
                                                    hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                                                    labelText: '패스워드',
                                                    labelStyle: TextStyle(fontSize: 12,  color: Colors.grey),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                                      borderSide: BorderSide(
                                                          color: Colors.white, width: 1.5),
                                                    )
                                                ),
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return "패스워드를 입력해주세요";
                                                  }
                                                  return null;
                                                },
                                              ),
                                              SizedBox(height: 8,),

                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text('계정이 없다면',
                                                    style: TextStyle(
                                                        color: Colors.white60,
                                                        fontSize: 12
                                                    ),
                                                  ),
                                                  SizedBox(width: 5,),
                                                  InkWell(
                                                    onTap: (){
                                                      Navigator.pop(context);
                                                      _openAnimateDialog(context);
                                                    },
                                                    child: Text('회원가입',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 5,),
                                                  Text('하세요.',
                                                    style: TextStyle(
                                                        color: Colors.white60,
                                                        fontSize: 12
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        actionsAlignment: MainAxisAlignment.center,
                                        actions: <Widget>[
                                          new ElevatedButton(
                                            child: new Text("로그인", style: TextStyle(color: Colors.white),),
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.transparent),
                                            onPressed: () async{
                                              // try {
                                                print('login cliicked');
                                                bool isToken = await userProvider.login(_idController.text, _pwController.text);
                                                // print(userProvider.token);

                                                if(isToken){
                                                  Fluttertoast.showToast(
                                                      msg: "로그인에 성공하였습니다",
                                                      toastLength: Toast.LENGTH_SHORT,
                                                      gravity: ToastGravity.CENTER,
                                                      timeInSecForIosWeb: 1,
                                                      webPosition: "center",
                                                      // backgroundColor: Colors.white,
                                                      webBgColor: "linear-gradient(to right, #4299f5, #4299f5, #4299f5)",
                                                      textColor: Colors.white,
                                                      fontSize: 16.0
                                                  );

                                                  Navigator.pop(context);
                                                  Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: MyPage()));
                                                }
                                                else{
                                                  Fluttertoast.showToast(
                                                      msg: "로그인에 실패하였습니다",
                                                      toastLength: Toast.LENGTH_SHORT,
                                                      gravity: ToastGravity.CENTER,
                                                      timeInSecForIosWeb: 1,
                                                      webPosition: "center",
                                                      // backgroundColor: Colors.white,
                                                      webBgColor: "linear-gradient(to right, #f54242, #f54242, #f54242)",
                                                      textColor: Colors.white,
                                                      fontSize: 16.0
                                                  );
                                                }
                                              //   await userProvider.storeToken();
                                              //
                                              //   if (userProvider.isTokenExpired()) {
                                              //     print('Token is expired');
                                              //   } else {
                                              //     Navigator.pop(context);
                                              //     print('Token is valid');
                                              //   }
                                              // } catch (e) {
                                              //   print('Error: $e');
                                              // }
                                            },
                                          ),
                                          new ElevatedButton(
                                            child: new Text("닫기", style: TextStyle(color: Colors.white),),
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.transparent),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      )
                                  ),
                                );
                              }
                          );
                        }

                      },
                      child: Icon(Icons.person_outlined, color: Colors.white, size: 20,),
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.transparent,
                      tooltip: 'MY',
                      elevation: 0,
                      focusElevation: 0.1,
                      hoverElevation: 0.1,
                      focusColor: Colors.white.withOpacity(0.6),
                      hoverColor: Colors.white.withOpacity(0.2),
                      splashColor: Colors.transparent,
                    );
                  }
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }




  void _openAnimateDialog(BuildContext context){
    final _regiIDController = TextEditingController();
    final _regiPWController = TextEditingController();
    final _regiPWPWController = TextEditingController();
    final _regiNAMEController = TextEditingController();
    final _regiEMAILController = TextEditingController();

    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: '',
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation1, animation2){
          return Container();
        },
        transitionBuilder: (context, a1, a2, widget){

          final userProvider = Provider.of<UserProvider>(context);
          final screenProvider = Provider.of<ScreenProvider>(context);
          final memoProvider = Provider.of<MemoProvider>(context);

          return ScaleTransition(
            scale: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
            child: FadeTransition(
                opacity: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
                child: AlertDialog(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: Colors.white,
                        width: 0.5
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),

                  //Dialog Main Title
                  title: Column(
                    children: <Widget>[
                      new Text(
                        "회원가입",
                        style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                  content: Container(
                    height: 300,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _regiIDController,
                          minLines: 1,
                          maxLines: 1,
                          keyboardType: TextInputType.multiline,
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14),
                          decoration: InputDecoration(
                            // icon: Icon(Icons.note_add_outlined),
                              suffixIcon: Icon(Icons.account_circle_outlined, color: Colors.white,),
                              fillColor: Colors.transparent,
                              isDense: true,
                              contentPadding: EdgeInsets.all(15),
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                                borderSide: BorderSide(color:Colors.white, width: 0),
                              ),
                              // helperText: '',
                              hintText: '아이디를 입력하세요',
                              floatingLabelStyle: TextStyle(color:Colors.white),
                              hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                              labelText: '아이디',
                              labelStyle: TextStyle(fontSize: 12,  color: Colors.grey),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                borderSide: BorderSide(
                                    color: Colors.white, width: 1.5),
                              )
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "내용을 입력해주세요";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: _regiPWController,
                          minLines: 1,
                          maxLines: 1,
                          keyboardType: TextInputType.multiline,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14),
                          decoration: InputDecoration(
                            // icon: Icon(Icons.note_add_outlined),
                              suffixIcon: Icon(Icons.lock_outline, color: Colors.white,),
                              fillColor: Colors.transparent,
                              isDense: true,
                              contentPadding: EdgeInsets.all(15),
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                                borderSide: BorderSide(color:Colors.white, width: 0),
                              ),
                              // helperText: '',
                              hintText: '패스워드를 입력하세요',
                              floatingLabelStyle: TextStyle(color:Colors.white),
                              hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                              labelText: '패스워드',
                              labelStyle: TextStyle(fontSize: 12,  color: Colors.grey),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                borderSide: BorderSide(
                                    color: Colors.white, width: 1.5),
                              )
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "패스워드를 입력해주세요";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: _regiPWPWController,
                          minLines: 1,
                          maxLines: 1,
                          keyboardType: TextInputType.multiline,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14),
                          decoration: InputDecoration(
                            // icon: Icon(Icons.note_add_outlined),
                              suffixIcon: Icon(Icons.lock_outline, color: Colors.white,),
                              fillColor: Colors.transparent,
                              isDense: true,
                              contentPadding: EdgeInsets.all(15),
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                                borderSide: BorderSide(color:Colors.white, width: 0),
                              ),
                              // helperText: '',
                              hintText: '패스워드를 한번 더 입력하세요',
                              floatingLabelStyle: TextStyle(color:Colors.white),
                              hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                              labelText: '패스워드 확인',
                              labelStyle: TextStyle(fontSize: 12,  color: Colors.grey),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                borderSide: BorderSide(
                                    color: Colors.white, width: 1.5),
                              )
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "패스워드를 입력해주세요";
                            }
                            return null;
                          },
                        ),

                        // SizedBox(height: 15,),
                        // TextFormField(
                        //   controller: _regiNAMEController,
                        //   minLines: 1,
                        //   maxLines: 1,
                        //   keyboardType: TextInputType.name,
                        //   cursorColor: Colors.white,
                        //   style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14),
                        //   decoration: InputDecoration(
                        //     // icon: Icon(Icons.note_add_outlined),
                        //       suffixIcon: Icon(Icons.person_outlined, color: Colors.white,),
                        //       fillColor: Colors.transparent,
                        //       isDense: true,
                        //       contentPadding: EdgeInsets.all(15),
                        //       filled: true,
                        //       enabledBorder: OutlineInputBorder(
                        //         borderRadius: BorderRadius.all(
                        //           Radius.circular(15),
                        //         ),
                        //         borderSide: BorderSide(color:Colors.white, width: 0),
                        //       ),
                        //       // helperText: '',
                        //       hintText: '이름을 입력하세요',
                        //       floatingLabelStyle: TextStyle(color:Colors.white),
                        //       hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                        //       labelText: '이름',
                        //       labelStyle: TextStyle(fontSize: 12,  color: Colors.grey),
                        //       focusedBorder: OutlineInputBorder(
                        //         borderRadius: BorderRadius.all(Radius.circular(15)),
                        //         borderSide: BorderSide(
                        //             color: Colors.white, width: 1.5),
                        //       )
                        //   ),
                        //   validator: (value) {
                        //     if (value!.isEmpty) {
                        //       return "이름을 입력해주세요";
                        //     }
                        //     return null;
                        //   },
                        // ),
                        SizedBox(height: 15,),
                        TextFormField(
                          controller: _regiEMAILController,
                          minLines: 1,
                          maxLines: 1,
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14),
                          decoration: InputDecoration(
                            // icon: Icon(Icons.note_add_outlined),
                              suffixIcon: Icon(Icons.email_outlined, color: Colors.white,),
                              fillColor: Colors.transparent,
                              isDense: true,
                              contentPadding: EdgeInsets.all(15),
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                                borderSide: BorderSide(color:Colors.white, width: 0),
                              ),
                              // helperText: '',
                              hintText: '이메일을 입력하세요',
                              floatingLabelStyle: TextStyle(color:Colors.white),
                              hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                              labelText: '이메일',
                              labelStyle: TextStyle(fontSize: 12,  color: Colors.grey),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                borderSide: BorderSide(
                                    color: Colors.white, width: 1.5),
                              )
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "내용을 입력해주세요";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  actionsAlignment: MainAxisAlignment.center,
                  actions: <Widget>[
                    new ElevatedButton(
                      child: new Text("회원가입", style: TextStyle(color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent),
                      onPressed: () async {

                        bool isRegistered = await userProvider.register(_regiIDController.text, _regiPWPWController.text, _regiEMAILController.text);
                        if(isRegistered){
                          Fluttertoast.showToast(
                              msg: "회원가입에 성공하였습니다. 다시 로그인 해주세요.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              webPosition: "center",
                              // backgroundColor: Colors.white,
                              webBgColor: "linear-gradient(to right, #4299f5, #4299f5, #4299f5)",
                              textColor: Colors.white,
                              fontSize: 16.0
                          );

                          Navigator.pop(context);
                        }
                        else{
                          Fluttertoast.showToast(
                              msg: "회원가입에 실패하였습니다",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              webPosition: "center",
                              // backgroundColor: Colors.white,
                              webBgColor: "linear-gradient(to right, #f54242, #f54242, #f54242)",
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                        }
                        Navigator.pop(context);
                      },
                    ),
                    new ElevatedButton(
                      child: new Text("닫기", style: TextStyle(color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                )
            ),
          );
        }
    );
  }

}



