
import 'package:english_quiz_4_all/model/user_group.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SubscriptionController{

  // select
  static Future<List<UserGroup>?> GetMySubscriptions(studentId) async {
    var supabase = Supabase.instance.client;
    try {
      var data = await supabase.from('subscription').select("*").eq('student_id', studentId);
      print(data);
      return data.map((quizData) => UserGroup.fromJson(quizData)).toList();
    } catch (e) {
      print(e);
    }

    return null;
  }

  // insert
  static Future<bool> InsertSubscription(studentId, masterId) async {
    var supabase = Supabase.instance.client;

    try {
      await supabase.from('subscription').insert(
          {
            'student_id': studentId,
            'master_id': masterId
          }).select();

      return true;
    } catch (e) {
      print(e);
    }

    return false;
  }

  // delete
  static Future<bool> DeleteSubscription(id) async {
    var supabase = Supabase.instance.client;
    try {
      await supabase.from('subscription').delete().match({'id': id});
      return true;
    } catch (e) {
      print(e);
    }

    return false;
  }
}