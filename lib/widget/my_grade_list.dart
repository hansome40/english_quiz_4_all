import 'package:english_quiz_4_all/controller/user_grade_controller.dart';
import 'package:english_quiz_4_all/utils/user_singleton.dart';
import 'package:flutter/material.dart';

import '../model/group.dart';
import '../model/my_grade.dart';

class MyGradeList extends StatefulWidget {
  const MyGradeList({super.key});

  @override
  State<MyGradeList> createState() => _MyGradeListState();
}

class _MyGradeListState extends State<MyGradeList> {

  late Group _group;
  List<MyGrade> _myGrades = [];
  List<MyGrade> _myAllGrades = [];
  bool isFilter = false;

  Future<void> _getMyGrades() async {
    _myAllGrades = [];
    _myGrades = [];
    var data = await UserGradeController.GetMygrades(UserSingleton().uid, _group.id);
    if(data != null){
      setState(() {
        _myAllGrades = data;
        _myGrades = _myAllGrades;
      });
    }
  }

  void _setFilterVal(){
    _myGrades = [];
    isFilter = !isFilter;

    if(isFilter){
      _myAllGrades.forEach((element) {
        if(!element.is_correct) {
          _myGrades.add(element);
        }
      });
    }else{
      _myGrades = _myAllGrades;
    }

    setState(() {
      _myGrades=_myGrades;
    });
  }

  void _getArgument(){
    if(ModalRoute.of(context)!.settings.arguments != null) {
      _group = ModalRoute.of(context)!.settings.arguments as Group;
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getArgument();
      _getMyGrades();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text(_group.g_name),
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
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: TextButton(
                child: Text('오답만 보기', style: const TextStyle(
                    fontSize: 16, color: Colors.black87),),
                onPressed: () {
                  _setFilterVal();
                },
              ),
            ),
          ],
        ),
        body: make_listview()
    );
  }

  Widget make_listview(){
    return ListView.separated(
        itemCount: _myGrades.length,
        itemBuilder: (BuildContext context, int index){
          return ListTile(
            title: Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                _myGrades[index].eng_word,
                style:
                const TextStyle(fontSize: 22, color: Colors.black87, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                _myGrades[index].ko_word,
                style:
                const TextStyle(fontSize: 18, color: Colors.black87),
                textAlign: TextAlign.left,
              ),
            ),
            // trailing 속성에 이미지를 넣으면 셀의 오른쪽 끝에 만들어집니다.
            trailing: (_myGrades[index].is_correct)?Image.asset('assets/images/green_check.png', width: 25, height: 25,):Image.asset('assets/images/red_x.png', width: 25, height: 25,),
            // 셀을 눌렀을때 발생하는 이벤트를 처리하는곳 입니다.
            onTap: () {

            },
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider();
        });
  }
}