import 'package:supabase_flutter/supabase_flutter.dart';

import 'macro.dart';

class UserSingleton {
  // Private한 생성자 생성
  UserSingleton._privateConstructor();

  String email = '';
  String name = '';
  String mode = '';
  String thumb = '';
  String uid = '';
  String provider = '';

  void signIn(String _email, String _name, String _mode, String _thumb, String _uid, String _provider) {
    email = _email;
    name = _name;
    mode = _mode;
    thumb = _thumb;
    uid = _uid;
    provider = _provider;
  }

  bool signInWithSupabase(user) {

    if(user != null){
      signIn(
          user.email!,
          user.userMetadata![Macro.user_data_name_key],
          user.userMetadata![Macro.user_data_mode_key],
          user.userMetadata![Macro.user_data_thumb_key],
          user.id,
          user.appMetadata[Macro.user_data_provider_key]);

      return true;
    }

    return false;
  }

  void signOut() {
    email = '';
    name = '';
    mode = '';
    thumb = '';
    uid = '';
    provider = '';
  }

  // 생성자를 호출하고 반환된 Singleton 인스턴스를 _instance 변수에 할당
  static final UserSingleton _instance = UserSingleton._privateConstructor();

  // Singleton() 호출시에 _instance 변수를 반환
  factory UserSingleton() {
    return _instance;
  }
}
