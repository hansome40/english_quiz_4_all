import 'package:english_quiz_4_all/controller/user_controller.dart';
import 'package:english_quiz_4_all/controller/user_grade_controller.dart';
import 'package:english_quiz_4_all/controller/subscription_controller.dart';
import 'package:english_quiz_4_all/model/user.dart';
import 'package:flutter/material.dart';

import '../controller/quiz_group_controller.dart';
import '../model/group.dart';
import '../model/user_group.dart';
import '../utils/user_singleton.dart';

class MyGradeGroup extends StatefulWidget {
  const MyGradeGroup({super.key});

  @override
  State<MyGradeGroup> createState() => _MyGradeGroupState();
}

class _MyGradeGroupState extends State<MyGradeGroup> {

  // 구독중인 퀴즈 그룹 리스트
  List<Group> _groups = [];
  // 구독중인 퀴즈 그룹 리스트의 퀴즈 문제풀이 점수를 저장하는 리스트
  List<String> _grades = [];

  final UserSingleton _userSingleton = UserSingleton();

  Future<void> _getGroups() async {
    // 기존에 저장된 데이터 삭제
    _grades = [];
    _groups = [];

    // 구독중인 그룹의 마스터 user id 를 가져 온다.
    List<UserGroup>? groups = await SubscriptionController.GetMySubscriptions(_userSingleton.uid);
    if(groups != null){
      for (var element in groups) {
        // 가져온 마스터의 user id 의 퀴즈 목록을 가져온다.
        var datas = await QuizGroupController.GetGroups(element.master_id);
        if(datas != null) {
          setState(() {
            _groups.addAll(datas);
          });
        }
      }
    }

    //퀴즈 그룹의 목록에서 각 퀴즈 그룹의 문제 풀이 정보를 가져온다.
    for(var group in _groups){
      // 문제 풀이를 수행한 총 갯수를 가져온다.
      var totalCount = await UserGradeController.GetQuizCountByGroupId(_userSingleton.uid, group.id);
      // 정답을 맞춘 갯수를 가져온다.
      var correctCount = await UserGradeController.GetCorrectCount(_userSingleton.uid, group.id);

      print(totalCount);

      _grades.add('$correctCount / $totalCount');
    }

    setState(() {
      _grades = _grades;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getGroups();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text('내 퀴즈 그룹'),
          backgroundColor: const Color(0xffdddd55),
          centerTitle: true,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
        body: make_listview());
  }

  Widget make_listview() {
    return ListView.separated(
        itemCount: _groups.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            // 높이는 100을 가지는 셀을 만듭니다.
            height: 100,
            // 셀의 배경색을 지정합니다.
            color: Colors.white70,
            // 가운데 정렬하는 위젯을 만듭니다.
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: ListTile(
                  // 텍스트를 만듭니다.
                  title: Text(_groups[index].g_name, style: const TextStyle(fontSize: 25, color: Colors.black87)),
                  subtitle: Text((_grades.length > index)?_grades[index]:'', style: const TextStyle(fontSize: 20, color: Colors.black87)),
                  // trailing 속성에 이미지를 넣으면 셀의 오른쪽 끝에 만들어집니다.
                  trailing: const Icon(Icons.navigate_next),
                  // 셀을 눌렀을때 발생하는 이벤트를 처리하는곳 입니다.
                  onTap: () {
                    Navigator.pushNamed(context, '/my_grade_list', arguments: _groups[index]);
                  },
                ),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider();
        });
  }
}
