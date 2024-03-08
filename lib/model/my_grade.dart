class MyGrade{

  late String id;
  late String eng_word;
  late String ko_word;
  late String group_id;
  late bool is_correct;
  late String grade_created_at;

  MyGrade({
    required this.id,
    required this.eng_word,
    required this.ko_word,
    required this.group_id,
    required this.is_correct,
    required this.grade_created_at,
  });

  factory MyGrade.fromJson(Map<String, dynamic> data){
    final id = data['quiz']['id'].toString();
    final eng = data['quiz']['eng_word'].toString();
    final ko = data['quiz']['ko_word'].toString();
    final group_id = data['quiz']['group_id'].toString();
    final is_correct = data['is_correct'];
    final created_at = data['created_at'].toString();

    return MyGrade(id: id, eng_word: eng, ko_word: ko, group_id: group_id, is_correct: is_correct, grade_created_at: created_at);
  }
}