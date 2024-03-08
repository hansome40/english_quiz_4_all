class UserGroup{
  late String id;
  late String student_id;
  late String master_id;
  late String created_at;

  UserGroup({required this.id, required this.student_id, required this.master_id, required this.created_at});

  factory UserGroup.fromJson(Map<String, dynamic> data) {
    final id = data['id'].toString();
    final student_id = data['student_id'].toString();
    final master_id = data['master_id'].toString();
    final created_at = data['created_at'].toString();

    return UserGroup(id: id, student_id: student_id, master_id: master_id, created_at: created_at);
  }
}