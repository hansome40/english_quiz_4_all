
import 'package:english_quiz_4_all/utils/user_singleton.dart';
import 'package:english_quiz_4_all/utils/common.dart';
import 'package:english_quiz_4_all/utils/google.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/macro.dart';
import '../utils/kakao.dart';

class LoginPage extends StatelessWidget {
  // 아이디를 받아오기 위한 컨트롤러 변수
  final _emailEditingController = TextEditingController();
  // 비밀번호를 받아오기 위한 컨트롤러 변수
  final _pwEditingController = TextEditingController();

  final _supabase = Supabase.instance.client;
  // final GoogleSignIn _googleSignIn = GoogleSignIn();

  // 생성자 함수
  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          // 최상단을 GestureDetector로 감싸서 키보드가 올라와 있을때 배경을 터치시 숨기는 기능 추가
          body: GestureDetector(
            // 배경 터치시
            onTap: () {
              // 키보드 닫기 이벤트
              FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Container(
                color: Color(0xffeeee44),
                child: Column(
                  // Column을 가운데 정렬
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: const Color(0xffffffff),
                            //모서리 둥글게
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white, width: 1)),
                        width: double.infinity,
                        height: 380,
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        child: Column(
                          // 가운데 정렬을 위해
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // 로그인 제목
                            Container(
                                margin: const EdgeInsets.only(bottom: 30),
                                child: const Text(
                                  '로그인',
                                  style: TextStyle(fontSize: 25, color: Colors.black87, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                )),
                            // 아이디 입력창
                            Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(left: 5, right: 5),
                                child: Text(
                                  '이메일',
                                  style: const TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.bold),
                                )),
                            Container(
                                height: 60,
                                margin: const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 5),
                                child: TextField(
                                    controller: _emailEditingController,
                                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                                    decoration: const InputDecoration(
                                      hintText: 'example@email.com',
                                      border: OutlineInputBorder(),
                                    ))),
                            Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(left: 5, right: 5, top: 10),
                                child: Text(
                                  '비밀번호',
                                  style: const TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.bold),
                                )),
                            // 비밀번호 입력창
                            Container(
                                height: 60,
                                margin: const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 5),
                                child: TextField(
                                  // 입력된 텍스트를 * 형식으로 보여줍니다.
                                  obscureText: true,
                                  controller: _pwEditingController,
                                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                                  decoration: const InputDecoration(
                                    hintText: '6자 이상 입력해주세요',
                                    border: OutlineInputBorder(),
                                  ))),
                          // 로그인 버튼, 회원가입 버튼 영역
                          Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // 로그인 버튼
                                  Container(
                                      margin: const EdgeInsets.only(right: 5),
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          try{
                                            final AuthResponse res = await _supabase.auth.signInWithPassword(
                                              email: _emailEditingController.text,
                                              password: _pwEditingController.text,
                                            );

                                            UserSingleton us = UserSingleton();
                                            if(us.signInWithSupabase(res.user)){
                                              Navigator.pushReplacementNamed(context, '/home');
                                            }else{
                                              await Common.showMyDialog(context, '확인', '아이디 또는 비밀번호가 틀렸습니다.');
                                            }

                                          }catch(e){
                                            print(e);
                                            if(e is AuthException){
                                              if(e.message == 'Invalid login credentials'){
                                                await Common.showMyDialog(context, '확인', '아이디 또는 비밀번호가 틀렸습니다.');
                                              }
                                            }
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(elevation: 0, backgroundColor: Color(0xffeeee44)),
                                        child: const Text('로그인', style: const TextStyle(fontSize: 18, color: Colors.black87)),
                                      )),
                                  // 회원가입 버튼
                                  Container(
                                      margin: const EdgeInsets.only(left: 5),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pushNamed(context, '/join_user');
                                        },
                                        style: ElevatedButton.styleFrom(elevation: 0, backgroundColor: const Color(0xffeeee44)),
                                        child: const Text(
                                          '회원가입',
                                          style: TextStyle(fontSize: 18, color: Colors.black87),
                                        ),
                                      )),
                                ],
                              ))
                        ],
                      ),
                    ),
                    // 구글 로그인 버튼
                    Center(
                        child: Container(
                            // width: double.infinity / 2,
                            height: 50,
                            margin: const EdgeInsets.only(left: 20, right: 20, top: 50),
                            child: InkWell(
                              onTap: () async {
                                // var datas = await GoogleApi.SignInWithGoogle(context);
                                // Navigator.pushNamed(context, '/join_user', arguments: datas);

                                await GoogleApi.SignInWithGoogleToSupabase(context);
                            },
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(9.0),
                                  child: Image.asset('assets/images/google_sign_in.png', width: 250,fit: BoxFit.fitWidth,)),
                            )
                        )
                    ),
                    // 카카오 로그인 버튼
                    Center(
                        child: Container(
                            // width: double.infinity,
                          // width: 800,
                            height: 50,
                            margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                            child: InkWell(
                              customBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              onTap: () async {
                                await KakaoAPI.SignInWithKaKaoBySupabase(context);
                                // var datas = await KakaoAPI.SignInWithKakao(context);
                                // print(datas);
                                // Navigator.pushNamed(context, '/join_user');
                              },
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(9.0),
                                  child: Image.asset('assets/images/kakao_login_large_narrow.png', width: 250,fit: BoxFit.fitWidth,)),
                            )
                        )
                    )
                  ]),
          )),
    ));
  }
}
