import 'package:english_quiz_4_all/utils/user_singleton.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../utils/common.dart';
import '../utils/macro.dart';

class JoinUser extends StatefulWidget {
  const JoinUser({super.key});

  @override
  State<JoinUser> createState() => _JoinUserState();
}

class _JoinUserState extends State<JoinUser> {
  // supabase 를 사용 하기위한 supabse 인스턴스를 받아옵니다.
  final _supabase = Supabase.instance.client;

  // 이름을 받아오기 위한 컨트롤러 변수
  final _nameEditingController = TextEditingController();

  // 아이디를 받아오기 위한 컨트롤러 변수
  final _emailEditingController = TextEditingController();

  // 비밀번호를 받아오기 위한 컨트롤러 변수
  final _pwEditingController = TextEditingController();

  // 비밀번호를 받아오기 위한 컨트롤러 변수
  final _pwConfirmEditingController = TextEditingController();

  // 학생인지 마스터인지
  bool _isMaster = false;
  String _swithchValue = '학생';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        home: Scaffold(
      // 이 속성을 설정하면 키보드가 올라올때 위젯을 위로 밀어올리지 않습니다.
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('회원 가입'),
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
        child: Container(
            color: Color(0xffeeee44),
            // 넓이, 높이 모두 화면을 꽉채우게 만듭니다.
            height: double.infinity,
            width: double.infinity,
            // 문제를 출력할 영역이며 흰바탕을 줍니다.
            child: Container(
              decoration: BoxDecoration(
                  color: const Color(0xffffffff),
                  //모서리 둥글게
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white, width: 1)),
              // 넓이, 높이를 상위 위젯에 꽉채우게 만들며 마진을 주어서 살짝 공간을 줍니다.
              // 패딩은 흰바탕의 영역에 채워질 위젯들의 왼쪽 오른쪽에 공간을 줍니다.
              width: double.infinity,
              height: double.infinity,
              margin: const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 30),
              padding: const EdgeInsets.only(left: 30, right: 30),
              // 위에서 아래로 배치하기 위해 Column 위젯으로 감쌉니다.
              child: Column(
                // 화면의 가운데 정렬을해줍니다.
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(left: 5, right: 5),
                      child: Text(
                        '이름',
                        style: const TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.bold),
                      )),
                  Container(
                      height: 60,
                      margin: const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 5),
                      child: TextField(
                          controller: _nameEditingController,
                          style: const TextStyle(fontSize: 16, color: Colors.black87),
                          decoration: const InputDecoration(
                            hintText: '이름을 입력해주세요',
                            border: OutlineInputBorder(),
                          ))),

                  Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(left: 5, right: 5, top: 20),
                      child: Text(
                        '이메일',
                        style: const TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.bold),
                      )),
                  Container(
                      height: 60,
                      margin: const EdgeInsets.only(left: 5, right: 5, top: 10),
                      child: TextField(
                          controller: _emailEditingController,
                          style: const TextStyle(fontSize: 16, color: Colors.black87),
                          decoration: const InputDecoration(
                            hintText: 'example@email.com',
                            border: OutlineInputBorder(),
                          ))),
                  Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(left: 5, right: 5, top: 20),
                      child: Text(
                        '비밀번호',
                        style: const TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.bold),
                      )),
                  // 비밀번호 입력창
                  Container(
                      height: 60,
                      margin: const EdgeInsets.only(left: 5, right: 5, top: 10),
                      child: TextField(
                          // 입력된 텍스트를 * 형식으로 보여줍니다.
                          obscureText: true,
                          controller: _pwEditingController,
                          style: const TextStyle(fontSize: 16, color: Colors.black87),
                          decoration: const InputDecoration(
                            hintText: '6자리 이상',
                            border: OutlineInputBorder(),
                          ))),
                  // 비밀번호 확인 입력창
                  Container(
                      height: 60,
                      margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
                      child: TextField(
                          // 입력된 텍스트를 * 형식으로 보여줍니다.
                          obscureText: true,
                          controller: _pwConfirmEditingController,
                          style: const TextStyle(fontSize: 16, color: Colors.black87),
                          decoration: const InputDecoration(
                            hintText: '비밀번호를 한번더 입력해 주세요',
                            border: OutlineInputBorder(),
                          ))),
                  Container(
                    margin: EdgeInsets.only(left: 5, top: 10),
                    child: Row(
                      children: [
                        Switch(
                            value: _isMaster,
                            onChanged: (value) {
                              setState(() {
                                _isMaster = value;
                                if (_isMaster) {
                                  _swithchValue = MODE_MACRO.MODE_MASTER;
                                } else {
                                  _swithchValue = MODE_MACRO.MODE_STUDENT;
                                }
                              });
                            }),
                        Padding(padding: EdgeInsets.only(left: 10), child: Text(_swithchValue, style: const TextStyle(fontSize: 20, color: Colors.black87))),
                      ],
                    ),
                  ),
                  // 취소, 다음 버튼을 만드는 영역입니다.
                  Container(
                      margin: const EdgeInsets.only(top: 100),
                      // 가로로 위젯을 배치하기 위해 Row로 감쌉니다.
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 취소
                          Flexible(
                            fit: FlexFit.tight,
                            child: Container(
                                margin: const EdgeInsets.only(right: 10),
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(elevation: 0, backgroundColor: Color(0xffeeee44)),
                                  child: const Text('취소', style: const TextStyle(fontSize: 18, color: Colors.black87)),
                                )),
                          ),
                          // 가입하기 버튼
                          Flexible(
                            fit: FlexFit.tight,
                            child: Container(
                                margin: const EdgeInsets.only(left: 10),
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_emailEditingController.text.isEmpty) {
                                      await Common.showMyDialog(context, '확인', '아이디를 입력해주세요');
                                      return;
                                    }

                                    if (_pwEditingController.text.isEmpty) {
                                      await Common.showMyDialog(context, '확인', '비밀번호를 입력해주세요');
                                      return;
                                    }

                                    if (_pwEditingController.text.length < 6) {
                                      await Common.showMyDialog(context, '확인', '비밀번호는 6자리 이상 입력해주세요');
                                      return;
                                    }

                                    if (_pwConfirmEditingController.text.isEmpty) {
                                      await Common.showMyDialog(context, '확인', '비밀번호 확인을 입력해주세요');
                                      return;
                                    }

                                    if (_pwEditingController.text != _pwEditingController.text) {
                                      await Common.showMyDialog(context, '확인', '비밀번호가 서로 다릅니다.\n확인해주세요');
                                      return;
                                    }

                                    try {
                                      final AuthResponse res = await _supabase.auth.signUp(
                                          email: _emailEditingController.text,
                                          password: _pwEditingController.text,
                                          data: {
                                            Macro.user_data_name_key: _nameEditingController.text,
                                            Macro.user_data_mode_key: _swithchValue,
                                            Macro.user_data_thumb_key: ''
                                          });

                                      // final Session? session = res.session;
                                      // final User? user = res.user;
                                      UserSingleton userSingleton = UserSingleton();
                                      userSingleton.signInWithSupabase(res.user);

                                      if (res.user != null) {
                                        Navigator.pushNamed(context, '/home');
                                      }

                                    } catch (e) {
                                      if (e is AuthException) {
                                        String msg = e.message;
                                        if (msg == 'User already registered') {
                                          await Common.showMyDialog(context, '확인', '이메일이 이미 가입되어있습니다.');
                                        }
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(elevation: 0, backgroundColor: const Color(0xffeeee44)),
                                  child: const Text(
                                    '가입하기',
                                    style: TextStyle(fontSize: 18, color: Colors.black87),
                                  ),
                                )),
                          ),
                        ],
                      ))
                ],
              ),
            )),
      ),
    ));
  }
}
