import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'user_singleton.dart';
import 'macro.dart';

class GoogleApi{
  static Future<Map> SignInWithGoogle(context) async {
    var datas = <String,String>{};

    try{
      GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();
      // print(googleSignInAccount);

      String? name = googleSignInAccount?.displayName;
      String? email = googleSignInAccount?.email;
      String? id = googleSignInAccount?.id;

      datas["type"] = "google";
      datas["name"] = (name == null)? '':name;
      datas["email"] = (email == null)? '':email;
      datas["id"] = (id == null)?'':id;
    }catch(e){
      print(e);
    }

    return datas;
  }

  static Future<void> SignInWithGoogleToSupabase(context) async {

    const webClientId = '876283917758-k8c8leckfc8spd8sijjj1cpt83fgfuta.apps.googleusercontent.com';
    const iosClientId = '876283917758-37v3muo95smac6pj9m0egcvfanfmgsik.apps.googleusercontent.com';

    try{
      // GoogleSignInAccount? googleSignInAccount;
      // if(foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS)
      // {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['openid', 'email', 'profile'],
        clientId: iosClientId,
        serverClientId: webClientId,
      );

      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      // }
      // else{
      //   googleSignInAccount = await GoogleSignIn(
      //       scopes: ['openid','email','profile']
      //   ).signIn();
      //   // _signIn.disconnect();
      // }

      final googleAuth = await googleSignInAccount!.authentication;
      final idToken = googleAuth.idToken!;
      final accessToken = googleAuth.accessToken;

      if (accessToken == null) {
        print('No Access Token found.');
        return;
      }

      // 구글인증을 통해 supabase 인증 로그인을 합니다.
      // 이때 회원가입이 안되있으면 자동으로 사용자가 추가됩니다. (provider 값이 'google' 로 저장됩니다.)
      final supabase = Supabase.instance.client;
      AuthResponse res = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      // 로그인된 사용자의 정보를 가져옵니다.
      User? user = res.user;
      if(user != null){

        if(!user.userMetadata!.containsKey(Macro.user_data_mode_key)){
          var name = user.userMetadata![Macro.google_name_key];
          var picture = user.userMetadata![Macro.google_picture_key];

          var datas = <String,String>{
            Macro.user_data_mode_key:'학생',
            Macro.user_data_thumb_key:(picture == null)?'':picture,
            Macro.user_data_name_key:(name == null)?'':name
          };

          final UserResponse res = await supabase.auth.updateUser(
            UserAttributes(
                data: datas
            ),
          );

          user = res.user;
        }

        UserSingleton us = UserSingleton();
        us.signInWithSupabase(user);
        // us.signIn(user.email!, name, mode, thumb, user.id, user.appMetadata[Macro.user_data_provider_key]);

        Navigator.pushReplacementNamed(context, '/home');
      }

      return;
    }catch(e){
      print(e);
    }
  }
}