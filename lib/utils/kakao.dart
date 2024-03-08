
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'user_singleton.dart';
import 'macro.dart';

class KakaoAPI{
  static Future<Map> SignInWithKakao(context) async {
    var datas;

    if (await isKakaoTalkInstalled()) {
      try {

        await UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인 성공');

        datas = await _getUserByKakao();

      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          // datas = null;
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          await UserApi.instance.loginWithKakaoAccount();
          print('카카오계정으로 로그인 성공');

          datas = await _getUserByKakao();
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
          // datas = null;
        }
      }
    } else {

      try {
        var data = await UserApi.instance.loginWithKakaoAccount();
        print(data);

        String? idToken = data.idToken;
        String accessToken = data.accessToken;

        if(idToken != null){
          final supabase = Supabase.instance.client;
          await supabase.auth.signInWithOAuth(OAuthProvider.kakao);

          // print(res.user);
        }


        print('카카오계정으로 로그인 성공');

        datas = await _getUserByKakao();
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
        // datas = null;
      }
    }

    return datas;
  }

  static Future<Map> _getUserByKakao() async {
    var datas = <String,String>{};
    datas["type"] = 'kakao';
    try {
      var user = await UserApi.instance.me();

      String? name = user.kakaoAccount?.profile?.nickname;

      datas['name'] = (name == null)?'':name;
      datas['id'] = user.id.toString();

    } catch (error) {
      print('사용자 정보 요청 실패 $error');
    }

    return datas;
  }

  static Future<void> SignInWithKaKaoBySupabase(context) async {

    try{
      final supabase = Supabase.instance.client;

      await supabase.auth.signInWithOAuth(OAuthProvider.kakao);

      // Listen to auth state changes in order to detect when ther OAuth login is complete.
      supabase.auth.onAuthStateChange.listen((data) async {
        final AuthChangeEvent event = data.event;

        //📲 event가 로그인 상태를 확인하면 로그인 후 페이지로 이동하는 코드
        if (event == AuthChangeEvent.signedIn) {
          // print('데이터 : $data');

          var user = data.session!.user;
          if (!user.userMetadata!.containsKey(Macro.user_data_mode_key)) {
            var name = user.userMetadata![Macro.kakao_name_key];
            var picture = user.userMetadata![Macro.kakao_avatar_url_key];

            var datas = <String, String>{
              Macro.user_data_mode_key: '학생',
              Macro.user_data_thumb_key: (picture == null) ? '' : picture,
              Macro.user_data_name_key: (name == null) ? '' : name
            };

            final UserResponse res = await supabase.auth.updateUser(
              UserAttributes(
                  data: datas
              )
            );

            user = res.user!;
          }

          UserSingleton us = UserSingleton();
          us.signInWithSupabase(user);

          Navigator.pushReplacementNamed(context, '/home');
        }
      });

    }catch(e){
      print(e);
    }
  }
}