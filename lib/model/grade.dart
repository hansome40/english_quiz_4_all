class Grade{

  late String id;
  late String user_id;
  late String quiz_id;
  late bool is_correct;
  late String created_at;

  Grade({required this.id, required this.user_id, required this.quiz_id, required this.is_correct, required this.created_at});

  factory Grade.fromJson(Map<String, dynamic> data) {

    final id = data['id'].toString();
    final user_id = data['user_id'].toString();
    final quiz_id = data['quiz_id'].toString();
    final is_correct = data['quiz_id'];
    final created_at = data['created_at'].toString();

    return Grade(id: id, user_id: user_id, quiz_id: quiz_id, is_correct: is_correct, created_at: created_at);
  }
}