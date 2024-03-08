import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/user.dart' as myUser;

class UserController{
  // select
  static Future<myUser.User?> GetMaster(email) async {
    var supabase = Supabase.instance.client;
    try {
      var data = await supabase.from('users_view').select("*").eq('email', email).single();
      print(data);
      return myUser.User.fromJson(data);
    } catch (e) {
      print(e);
    }

    return null;
  }

  static Future<myUser.User?> GetMasters(masterId) async {
    var supabase = Supabase.instance.client;
    try {
      var data = await supabase.from('users_view').select("*").eq('id', masterId).single();
      print(data);
      return myUser.User.fromJson(data);
    } catch (e) {
      print(e);
    }

    return null;
  }
}