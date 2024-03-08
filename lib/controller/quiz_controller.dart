import 'package:english_quiz_4_all/model/quiz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class QuizController{

  // select
  static Future<List<Quiz>?> GetQuizes(group_id) async {
    var supabase = Supabase.instance.client;
    try {
      var data = await supabase.from('quiz').select("*").eq('group_id', group_id);
      return data.map((quizData) => Quiz.fromJson(quizData)).toList();
    } catch (e) {
      print(e);
    }

    return null;
  }

  static Future<void> GetQuizesAsync(group_id, u) async {
    var supabase = Supabase.instance.client;
    try {
      supabase.from('quiz').select("*").eq('group_id', group_id).then((value) => u(value));
    } catch (e) {
      print(e);
    }
  }

  static Future<List<Quiz>?> GetQuizKoWords() async {
    var supabase = Supabase.instance.client;
    try {
      var data = await supabase.from('random_quiz').select("*");
      return data.map((quizData) => Quiz.fromJson(quizData)).toList();
    } catch (e) {
      print(e);
    }

    return null;
  }

  // insert
  static Future<bool> InsertQuiz(engWord, koWord, groupId) async {
    var supabase = Supabase.instance.client;

    try {
      await supabase.from('quiz').insert(
          {
            'eng_word': engWord,
            'ko_word': koWord,
            'group_id': groupId
          }).select();

      return true;
    } catch (e) {
      print(e);
    }

    return false;
  }

  // update
  static Future<void> UpdateQuiz(engWord, koWord, id) async {
    var supabase = Supabase.instance.client;
    try {
      await supabase.from('quiz').update({
        'eng_word': engWord,
        'ko_word': koWord,
      }).match({'id': id});
    } catch (e) {
      print(e);
    }
  }

  // delete
  static Future<bool> DeleteQuiz(id) async {
    var supabase = Supabase.instance.client;
    try {
      await supabase.from('quiz').delete().match({'id': id});
      return true;
    } catch (e) {
      print(e);
    }

    return false;
  }
}