import 'package:english_quiz_4_all/model/group.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class QuizGroupController {

  // select
  static Future<List<Group>?> GetGroups(uid) async {
    var supabase = Supabase.instance.client;
    try {
      var data = await supabase.from('quiz_group').select("*").eq('user_id', uid);
      print(data);
      return data.map((groupData) => Group.fromJson(groupData)).toList();
    } catch (e) {
      print(e);
    }

    return null;
  }

  // insert
  static Future<Group?> InsertGroup(groupName, uid) async {
    var supabase = Supabase.instance.client;

    try {
      var data = await supabase.from('quiz_group').insert({'g_name': groupName, 'available': false, 'user_id': uid}).select();
      print(data);
      if(data.isNotEmpty) {
        return Group.fromJson(data[0]);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
    }

    return null;
  }

  // update available
  static Future<void> UpdateGroupAvailable(id, available) async {
    var supabase = Supabase.instance.client;
    try {
      await supabase.from('quiz_group').update({'available': available}).match({'id': id});
    } catch (e) {
      print(e);
    }
  }

  // update name
  static Future<bool> UpdateGroupName(id, name) async {
    var supabase = Supabase.instance.client;
    try {
      var res = await supabase.from('quiz_group').update({'g_name': name}).match({'id': id}).select();
      print(res);
      if(res.isNotEmpty) {
        return true;
      } else{
        return false;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  // delete
  static Future<bool> DeleteGroup(id) async {
    var supabase = Supabase.instance.client;
    try {
      await supabase.from('quiz_group').delete().match({'id': id});
      return true;
    } catch (e) {
      print(e);
    }

    return false;
  }
}
