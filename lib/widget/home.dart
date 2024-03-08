import 'dart:async';
import 'dart:math';
import 'package:english_quiz_4_all/controller/quiz_group_controller.dart';
import 'package:english_quiz_4_all/utils/user_singleton.dart';
import 'package:english_quiz_4_all/utils/common.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/group.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  // StatefulWidget 클래스를 상속받아 createState() 함수를 재정의하는 코드입니다.
  @override
  State<Home> createState() => _HomeState();
}

/*
* createState() 함수에서 return 하는 클래스이며 화면을 만드는 코드를 구현합니다.
* StatefulWidget 을 상속 받은 Home 클래스와 State<Home> 을 상속받은 _HomeState 클래스의 구조는
* State를 가지는 화면을 그리는 기본 구조로 앞으로 UI 변경이 필요한 화면을 만들 때 이 구조를 사용하면 됩니다.
*/
class _HomeState extends State<Home> {
  final _supabase = Supabase.instance.client;
  final UserSingleton _userSingleton = UserSingleton();
  late ImageProvider _provider;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // 셀에 표시할 텍스트의 리스트입니다.
  List<Group> _groups = [];

  // TextField 위젯에서 입력한 값을 가져오기 위해 Controller 를 만듭니다.
  // 이 Controller 를 통해 입력창의 값을 가져올수있습니다.
  final textEditingController = TextEditingController();

  // 추가 or 수정 확인을 위한 변수
  bool isModify = false;
  int modifyIndex = 0;

  // 리스트 추가 버튼을 눌렀을때 나타날 팝업을 보여주거나 숨기기 위한 상태값
  bool _visibility = false;

  // 이 함수를 호출해 팝업을 보여줍니다.
  void _show() {
    // UI 를 변경하기 위해 setState() 함수 내에서 데이터를 변경해야 합니다.
    setState(() {
      // 상태값을 true 로 바꿔주면 화면에 보여집니다.
      _visibility = true;
    });
  }

  // 이 함수를 호출해 팝업을 숨깁니다.
  void _hide() {
    setState(() {
      // 상태값을 false 로 바꿔주면 화면에서 숨겨집니다.
      _visibility = false;
    });
  }

  Future<void> _getGroups() async {
    var datas = await QuizGroupController.GetGroups(_userSingleton.uid);
    if(datas != null) {
      setState(() {
        _groups = datas;
      });
    }
  }

  @override
  void initState(){
    super.initState();
    _setThumbnail();
    _getGroups();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: scaffoldKey,
      // 앱바를 구현하기 위해 appBar 속성에 AppBar() 생성을 합니다.
      appBar: AppBar(
        // 앱바의 타이틀로 텍스트를 만듭니다.
        title: const Text("플러터 스터디"),
        // 앱바의 색을 지정합니다.
        backgroundColor: const Color(0xffdddd55),
        centerTitle: true,
        // 앱바의 제일 앞부분에 아이콘버튼을 만드는 코드입니다.
        leading: IconButton(
          // leading에 들어간 버튼의 이벤트를 만드는 곳으로 아직 비어있습니다.
          onPressed: () {
            if (scaffoldKey.currentState!.isDrawerOpen) {
              scaffoldKey.currentState!.closeDrawer();
            } else {
              scaffoldKey.currentState!.openDrawer();
            }
          },
          // leading에 들어간 버튼의 이미지를 설정하는 코드입니다.
          icon: const Icon(Icons.account_circle_outlined),
        ),
        // 앱바의 오른쪽 영역에 버튼을 추가하기 위한 속성입니다.
        actions: [
          // 오른쪽 영역에 들어갈 아이콘버튼을 생성하는 코드입니다.
          IconButton(
            // 오른쪽 영역 아이콘버튼의 이벤트를 만듭니다.
            onPressed: () {
              Navigator.pushNamed(context, '/find_master');
            },
            // 오른쪽 영역 아이콘버튼의 이미지를 설정하는 코드입니다.
            icon: const Icon(Icons.person_search_outlined),
          ),
          IconButton(
            // 오른쪽 영역 아이콘버튼의 이벤트를 만듭니다.
            onPressed: () {
              // 이벤트 발생시 UI를 변경하기위한 함수입니다.
              // 이 위치에 변경하고 싶은 데이터를 변경해야 UI 가 변경됩니다.
              setState(() {
                // 이 함수를 호출해 팝업을 보여줍니다.
                isModify = false;
                _show();
              });
            },
            // 오른쪽 영역 아이콘버튼의 이미지를 설정하는 코드입니다.
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          // 리스트뷰의 패딩을 0으로 줍니다.
          padding: EdgeInsets.zero,
          children: [
            // drawer 의 윗부분을 말하며 ui를 만들어줍니다.
            DrawerHeader(
              decoration: const BoxDecoration(
                // 배경색을 넣어줍니다.
                color: Color(0xffdd4444),
              ),
              child: Column(children: [
                //위젯을 아래쪽에 배치하기위해 윗부분에 공간을 주는 코드입니다.
                const Spacer(),
                Center(
                    // 테두리가 동그랗게 이미지를 보여주는 위젯입니다.
                    child: CircleAvatar(foregroundImage: _provider)),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Center(
                    // 사용자의 이름을 넣어주는 위젯입니다.
                    child: Text(
                      _userSingleton.name,
                      style: TextStyle(fontSize: 20, color: Colors.black87),
                    ),
                  ),
                )
              ]),
            ),
            // 이미지와 텍스트를 셀형식으로 만들어주는 위젯입니다.
            ListTile(
              // 시작위치에 나타날 아이콘 이미지입니다.
              leading: const Icon(
                Icons.home,
              ),
              // 셀의 텍스트 입니다.
              title: const Text('Home'),
              onTap: () {
                // 셀을 누르면 drawer를 닫습니다.
                Navigator.pushNamed(context, '/home');
              },
            ),
            ListTile(
              // 시작위치에 나타날 아이콘 이미지입니다.
              leading: const Icon(
                Icons.account_circle_outlined,
              ),
              // 셀의 텍스트 입니다.
              title: const Text('내정보'),
              onTap: () async {
                // 셀을 누르면 my_info 로 이동합니다.
                await Navigator.pushNamed(context, '/my_info');
                print('내정보 pop');
                setState(() {
                  _setThumbnail();
                });
              },
            ),
            ListTile(
              // 셀의 텍스트 입니다.
              title: const Text('로그아웃'),
              onTap: () async {
                // 로그아웃을 시킨후 로그인페이지로 이동
                await _supabase.auth.signOut();
                _userSingleton.signOut();

                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: Stack(
        // 리스트뷰를 만드는 함수와 그룹명을 입력받을 팝업을 만드는 함수를 호출합니다.
        children: [make_listview(), make_groupname_popup()],
      ),
    );
  }

  void _setThumbnail() {
    String userThumb = '';
    try {
      if (_userSingleton.thumb.isNotEmpty) {
        if (_userSingleton.thumb.contains('http')) {
          userThumb = _userSingleton.thumb;
        } else {
          userThumb = _supabase.storage.from('images').getPublicUrl(_userSingleton.thumb);
        }
      }
    } catch (e) {
      print(e);
    }

    _provider = (userThumb.isNotEmpty) ? NetworkImage(userThumb) : Image.asset('assets/images/gray.png').image;
  }

  // 그룹명을 입력받을 팝업을 만드는 합수를 구현합니다.
  // Visibility 위젯을 사용해 팝업을 show/hide 합니다.
  Widget make_groupname_popup() => Visibility(
      // visible 속성에 위에서 선언한 변수를 할당하여 show/hide 상태를 컨트롤 합니다.
      visible: _visibility,
      child: Center(
          // Card 위젯은 그림자가있는 사격형의 위젯입니다.
          child: Card(
            // 사각형의 라운딩을 설정합니다.
            shape: RoundedRectangleBorder(
              // 외각선의 라운딩을 16.0만큰 둥글게 만듭니다.
              borderRadius: BorderRadius.circular(16.0),
            ),
            // 카드뷰의 그림자 깊이를 설정합니다.
            elevation: 5.0,
            // card의 넓이를 화면 전체로 주었기 때문에 여백을 주기위해 마진을 설정합니다.
            // 왼쪽과 오른쪽의 마진을 50만큼 주었습니다.
            margin: const EdgeInsets.only(left: 50, right: 50),
            // 크기를 설정하기 위해 Column을 SizedBox로 감쌋습니다.
            child: SizedBox(
              // Card 의 넓이를 화면 전체로 정해줍니다.
              width: double.infinity,
              // Card 의 높이를 150dp 로 줍니다.
              height: 150,
              // 위에서 아래로 위젯을 쌓아가며 만들기 위해 Column 으로 감쌉니다.
              child: Column(children: [
                // 그룹명을 입력 받을 TextField가 들어갈 영역을 만듭니다.
                Container(
                  // 입력창 영역의 넓이는 자신을 감싸고 있는 영역 전체를 차지하게 합니다.
                  width: double.infinity,
                    // 입력창의 높이는 60을 줍니다.
                    height: 60,
                    // 입력 위젯의 주변에 공간을 줍니다.
                    margin: const EdgeInsets.only(left: 10, right: 10, top: 30, bottom: 5),
                    child: Center(
                        child: TextField(
                          // 입력창에서 텍스트 값을 가져오기 위한 controller 지정
                          controller: textEditingController,
                            style: const TextStyle(fontSize: 16, color: Colors.black87),
                            // TextField의 hint 값이나 외각선을 만들어 줍니다.
                            // hint 란 입력창 안에 사용자에게 무었을 입력하는지 가이드하는 걸 말합니다.
                            // border 를 설정안하면 default 입력창의 모양은 외곽선이 없는 형태입니다.
                          decoration: const InputDecoration(
                            hintText: '그룹명을 입력해주세요',
                            border: OutlineInputBorder(),
                          )))),
                // 확인, 취소 버튼이 들어갈 영역을 만듭니다.
                Container(
                    height: 30,
                    margin: EdgeInsets.only(top: 15),
                    width: double.infinity,
                    child: Row(children: [
                      Flexible(
                          fit: FlexFit.tight,
                          child: Container(
                              margin: const EdgeInsets.only(left: 10, right: 2),
                              child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                      child: const Text('확인'),
                                      onPressed: () {
                                        setState(() {
                                          String groupName = textEditingController.text;
                                          // 그룹명을 추가하는 함수를 호출한다.
                                          _set_listdata(groupName);
                                        });
                                      })))),
                      // 취소 버튼의 영역입니다.
                    Flexible(
                        fit: FlexFit.tight,
                        child: Container(
                            margin: const EdgeInsets.only(left: 2, right: 10),
                            child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                    child: const Text('취소'),
                                    onPressed: () {
                                      _hide();
                                    }))))
                ]))
          ]),
        ),
      )));

  // 그룹명을 추가 or 수정 하는 함수입니다.
  // isModify = true 면 수정이므로 수정할 index 값을 통해 entries 의 값을 변경합니다.
  // isModify = false 면 추가 이므로 그룹명을 entries.add 로 추가합니다.
  Future<void> _set_listdata(String groupName) async {
    // 그룹명의 길이를 체크해 입력이 없으면 경고를 입력이 있으면 리스트뷰의 셀을 생성합니다.
    if (groupName.isNotEmpty) {
      // 수정인지 추가인지 체크합니다.
      if (!isModify) {
        var group = await QuizGroupController.InsertGroup(groupName, _userSingleton.uid);
        if(group != null){
          _groups.add(group);
        }
      } else {
        var isSucces = await QuizGroupController.UpdateGroupName(_groups[modifyIndex].id, groupName);
        if(isSucces) {
          _groups[modifyIndex].g_name = groupName;
        }
      }
      // 입력창의 내용을 지워줍니다.
      textEditingController.text = "";
      // 팝업을 화면에서 안보이게 합니다.
      _hide();
    } else {
      // 입력한 내용이 없으면 메세지창을 띄웁니다.
      await Common.showMyDialog(context, '확인', '그룹명이 비어있습니다.\n내용을 입력해주세요');
      // _showMyDialog();
    }
  }

  // 리스트뷰를 만들어 리턴하는 함수 입니다.
  Widget make_listview() {
    // 화면에보이는 부분의 셀만 만드는 리스트뷰를 생성합니다.
    return ListView.separated(
        itemCount: _groups.length,
        itemBuilder: (BuildContext context, int index) {
          return Slidable(
              // 스와이프로 삭제를 하기 위한 키값 지정
              key: UniqueKey(),

              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  // 배포,중단 버튼
                  SlidableAction(
                    onPressed: (context) async {
                      await QuizGroupController.UpdateGroupAvailable(_groups[index].id, !_groups[index].available);
                      setState(() {
                        _groups[index].available = !_groups[index].available;
                      });
                    },
                    backgroundColor: const Color(0xFFCA77B7),
                    foregroundColor: Colors.white,
                    icon: Icons.stop_circle,
                    label: (_groups[index].available==true)?'중단하기':'배포하기',
                  ),
                ],
              ),
              // 왼쪽에서 오른쪽으로 스와이프 이벤트를 설정하는 코드입니다.
              startActionPane: ActionPane(
                // 스와이프 애니메이션을 ScrollMotion 형식으로 보여주도록 지정하는 코드입니다.
                motion: const ScrollMotion(),

                // 스와이프 삭제후 처리할 내용이 있을경우 이곳에 합니다.
                dismissible: DismissiblePane(onDismissed: () {}),

                // 스와이프 되었을때 나타날 버튼을 추가해줍니다. (삭제, 수정)
                children: [
                  // 삭제버튼
                  SlidableAction(
                    // 삭제버튼이 눌렸을때 처리할 코드입니다.
                    onPressed: (context) async {
                      await QuizGroupController.DeleteGroup(_groups[index].id);
                      setState(() {
                        if (_groups.isNotEmpty) {
                          _groups.removeAt(index);
                        }
                      });
                    },
                    backgroundColor: const Color(0xFFFE4A49),
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: '삭제',
                  ),
                  // 수정버튼
                  SlidableAction(
                    // 수정 버튼이 눌렸을때 처리할 코드입니다.
                    onPressed: (context) {
                      setState(() {
                        if (_groups.isNotEmpty) {
                          textEditingController.text = _groups[index].g_name;
                          isModify = true;
                          modifyIndex = index;
                          _show();
                        }
                      });
                    },
                    backgroundColor: const Color(0xFF21B7CA),
                    foregroundColor: Colors.white,
                    icon: Icons.change_circle,
                    label: '수정',
                  ),

                ],
              ),
              // 기존 리스트뷰의 셀을 만들었던 부분이 이곳으로 왔습니다.
              child: Container(
                // 높이는 100을 가지는 셀을 만듭니다.
                height: 100,
                // 셀의 배경색을 지정합니다.
                color: Colors.white70,
                // 가운데 정렬하는 위젯을 만듭니다.
                child: Center(
                  // ListTile() 을 사용해 셀을 그립니다.
                  child: ListTile(
                    // 텍스트를 만듭니다.
                    title: Text(
                      _groups[index].g_name,
                      style: const TextStyle(fontSize: 30, color: Colors.black87),
                      textAlign: TextAlign.center,
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Text(
                        (_groups[index].available==true)?'배포중':'중단중',
                        style: const TextStyle(fontSize: 16, color: Color(0xffdd4444)),
                      ),
                    ),
                    // trailing 속성에 이미지를 넣으면 셀의 오른쪽 끝에 만들어집니다.
                    trailing: const Icon(Icons.navigate_next),
                    // 셀을 눌렀을때 발생하는 이벤트를 처리하는곳 입니다.
                    onTap: () {
                      Navigator.pushNamed(context, '/quiz_list', arguments: _groups[index]);
                    },
                  ),
                ),
              )
              // const ListTile(title: Text('Slide me')),
              );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider();
        });
  }
}
