class Group{
  String created_at='';
  String id='';
  String g_name='';
  bool available;

  Group({required this.created_at, required this.id, required this.g_name, required this.available});

  factory Group.fromJson(Map<String, dynamic> data) {
    final created_at = data['created_at'].toString();
    final id = data['id'].toString();
    final g_name = data['g_name'].toString();
    final available = data['available'];

    return Group(created_at: created_at, id: id, g_name: g_name, available: available);
  }
}