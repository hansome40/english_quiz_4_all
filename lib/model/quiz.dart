class Quiz{
  late String id;
  late String eng_word;
  late String ko_word;
  late String created_at;
  late String group_id;

  Quiz({required this.id, required this.eng_word, required this.ko_word, required this.created_at, required this.group_id});

  factory Quiz.fromJson(Map<String, dynamic> data) {
    final id = data['id'].toString();
    final eng = data['eng_word'].toString();
    final ko = data['ko_word'].toString();
    final created_at = data['created_at'].toString();
    final group_id = data['group_id'].toString();

    return Quiz(id: id, eng_word: eng, ko_word: ko, created_at: created_at, group_id: group_id);
  }
}