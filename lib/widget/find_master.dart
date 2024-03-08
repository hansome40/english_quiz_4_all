
import 'package:english_quiz_4_all/controller/user_controller.dart';
import 'package:english_quiz_4_all/controller/subscription_controller.dart';
import 'package:english_quiz_4_all/model/user_group.dart';
import 'package:english_quiz_4_all/utils/common.dart';
import 'package:english_quiz_4_all/utils/user_singleton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../model/user.dart';
import '../utils/macro.dart';

class FindMaster extends StatefulWidget {
  const FindMaster({super.key});

  @override
  State<FindMaster> createState() => _FindMasterState();
}

class _FindMasterState extends State<FindMaster> {

  // 검색한 마스터의 사용자 데이터를 저장
  User? _findMaster;
  // 구독중인 마스터의 목록을 저장
  List<User?> _myMasters = [];

  // 마스터를 찾기위해 이메일주소를 넣을 입력창의 데이터를 가져오기 위한 controller
  final _findEditingController = TextEditingController();
  // 검색된 마스터의 정보를 보여주는 위젯의 화면에 show / hide 설정해주는 상태값
  bool _visibility = false;

  Future<void> _getMyMasters() async {
    List<UserGroup>? data = await SubscriptionController.GetMySubscriptions(UserSingleton().uid);
    if(data != null){
      for (var element in data) {
        var user = await UserController.GetMasters(element.master_id);
        _myMasters.add(user);
      }
      
      setState((){
        _myMasters=_myMasters;
      });
    }
  }

  Future<void> _getFindMaster() async {
    User? user = await UserController.GetMaster(_findEditingController.text);

    if(user != null){
      if(user.mode == MODE_MACRO.MODE_MASTER) {
        setState(() {
          _findMaster = user;
          _visibility = true;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getMyMasters();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('마스터 추가'),
          backgroundColor: const Color(0xffdddd55),
          centerTitle: true,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
        body: GestureDetector(
          onTap: () {
            // 키보드 닫기 이벤트
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Column(
              children: [
                Container(
                  color: Color(0xffbbbbbb),
                  width: double.infinity,
                  height: 80,
                  child: Row(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin:EdgeInsets.only(left: 20),
                          width: 260,
                          // height: 70,
                          child: TextField(
                              controller: _findEditingController,
                              style: const TextStyle(fontSize: 16, color: Colors.black87),
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: '이메일주소를 입력해 주세요',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(27.0),
                                  ),
                                ),
                              )
                          ),
                        ),
                        Spacer(),
                        Container(
                          margin: EdgeInsets.only(right: 20),
                          width: 80,
                          child: ElevatedButton(
                            onPressed: () {
                              _getFindMaster();
                            },
                            style: ElevatedButton.styleFrom(elevation: 0, backgroundColor: Color(0xffeeee44)),
                            child: const Text('찾기', style: const TextStyle(fontSize: 16, color: Colors.black87)),
                          ),
                        )
                      ]),
                ),
                Container(
                  padding: EdgeInsets.only(top: 5, left: 10, bottom: 10),
                  width: double.infinity,
                  color: Color(0xffbbbbbb),
                  child: const Text('검색 결과', style: TextStyle(fontSize: 20, color: Colors.black),textAlign: TextAlign.left,),
                ),
                Visibility(
                  visible: _visibility,
                  child: Container(
                    padding: EdgeInsets.only(top: 10),
                    width: double.infinity,
                    height: 120,
                    child: ListTile(
                      // 텍스트를 만듭니다.
                      title: Text(
                        (_findMaster == null)?'':_findMaster!.name,
                        style: const TextStyle(fontSize: 30, color: Colors.black87),
                        textAlign: TextAlign.left,
                      ),
                      subtitle: Text(
                        (_findMaster==null)?'':_findMaster!.email,
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      // trailing 속성에 이미지를 넣으면 셀의 오른쪽 끝에 만들어집니다.
                      trailing: const Icon(Icons.add_circle_outline),
                      // 셀을 눌렀을때 발생하는 이벤트를 처리하는곳 입니다.
                      onTap: () async {
                        if(_findMaster != null) {
                          final data = await Common.showYesNoDialog(context, '확인', '${_findMaster!.name}님을 마스터로 추가 하시겠습니까?');

                          if(data == 'confirm'){
                            var b = await SubscriptionController.InsertSubscription(UserSingleton().uid, _findMaster!.id);
                            if(b){

                              _findEditingController.text = '';

                              _findMaster = null;
                              _visibility = false;

                              _getMyMasters();
                            }
                          }
                        }
                      },
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10, left: 10, bottom: 10),
                  width: double.infinity,
                  color: Color(0xffbbbbbb),
                  child: const Text('나의 마스터 목록', style: TextStyle(fontSize: 20, color: Colors.black),textAlign: TextAlign.left,),
                ),
                Flexible(
                  child: ListView.separated(
                      itemCount: _myMasters.length,
                      itemBuilder: (BuildContext context, int index){
                        return ListTile(
                          // 텍스트를 만듭니다.
                          title: Text(
                            (_myMasters[index] == null)?'':_myMasters[index]!.name,
                            style: const TextStyle(fontSize: 30, color: Colors.black87),
                            textAlign: TextAlign.left,
                          ),
                          subtitle: Text(
                            (_myMasters[index]==null)?'':_myMasters[index]!.email,
                            style: const TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                          // trailing 속성에 이미지를 넣으면 셀의 오른쪽 끝에 만들어집니다.
                          trailing: const Icon(Icons.highlight_remove_rounded),
                          // 셀을 눌렀을때 발생하는 이벤트를 처리하는곳 입니다.
                          onTap: () async {
                            if(_myMasters[index] != null) {
                              final data = await Common.showYesNoDialog(context, '확인', '${_myMasters[index]!.name}님을 제거 하시겠습니까?');

                              if(data == 'confirm'){
                                var b = await SubscriptionController.DeleteSubscription(_myMasters[index]!.id);

                                if(b){
                                  Navigator.pop(context);
                                }
                              }
                            }
                          },
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider();
                      })
                )
              ]),
        )
      ),
    );
  }
}
