// import 'package:english_quiz_4_all/utils/macro.dart';

class User{
  late String id;
  late String email;
  late String mode;
  late String name;

  User({required this.id, required this.email, required this.mode, required this.name});

  factory User.fromJson(Map<String, dynamic> data) {
    final id = data['id'].toString();
    final email = data['email'].toString();
    final mode = data['raw_user_meta_data']['mode'].toString();
    final name = data['raw_user_meta_data']['username'].toString();

    return User(id: id, email: email, mode: mode, name: name);
  }
}