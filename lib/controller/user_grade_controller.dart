import 'package:english_quiz_4_all/model/my_grade.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserGradeController{
  // select
  static Future<String> GetQuizCountByGroupId(userId, groupId) async {
    var supabase = Supabase.instance.client;
    try {
      var data = await supabase.from('user_grade').select("*").eq('user_id', userId).eq('group_id', groupId).count(CountOption.exact);

      return data.count.toString();
    } catch (e) {
      print(e);
    }

    return '0';
  }

  static Future<String> GetCorrectCount(userId, groupId) async {
    var supabase = Supabase.instance.client;
    try {
      var data = await supabase.from('user_grade').select("*").eq('user_id', userId).eq('group_id', groupId).eq('is_correct', true).count(CountOption.exact);
      print(data);
      return data.count.toString();
    } catch (e) {
      print(e);
    }

    return '0';
  }

  static Future<List<MyGrade>?> GetMygrades(userId, groupId) async {
    var supabase = Supabase.instance.client;
    try {
      var data = await supabase.from('user_grade').select("*, quiz(*)").eq('user_id', userId).eq('group_id', groupId);
      print(data);

      return data.map((grade) => MyGrade.fromJson(grade)).toList();
    } catch (e) {
      print(e);
    }

    return null;
  }

  // insert
  static Future<bool> InsertMyGrade(userId, quizId, isCorrect, groupId) async {
    var supabase = Supabase.instance.client;

    try {
      await supabase.from('user_grade').insert(
          {
            'quiz_id': quizId,
            'is_correct': isCorrect,
            'user_id': userId,
            'group_id': groupId
          }).select();
      return true;
    } catch (e) {
      print(e);
    }

    return false;
  }

  // delete
  static Future<bool> DeleteMyGrade(userId, groupId) async {
    var supabase = Supabase.instance.client;
    try {
      await supabase.from('user_grade').delete().match({'group_id': groupId, 'user_id':userId});
      return true;
    } catch (e) {
      print(e);
    }

    return false;
  }
}