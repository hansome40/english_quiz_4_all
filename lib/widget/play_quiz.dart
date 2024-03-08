import 'dart:math';

import 'package:english_quiz_4_all/controller/user_grade_controller.dart';
import 'package:english_quiz_4_all/utils/common.dart';
import 'package:english_quiz_4_all/utils/user_singleton.dart';
import 'package:flutter/material.dart';

import '../controller/quiz_controller.dart';
import '../model/quiz.dart';

enum Char {A, B, C}

class PlayQuiz extends StatefulWidget {
  const PlayQuiz({super.key});

  @override
  State<PlayQuiz> createState() => _PlayQuizState();
}

class _PlayQuizState extends State<PlayQuiz> {
  Char _char = Char.A;

  // 퀴즈 목록
  List<Quiz> _quizes = [];
  // 퀴즈의 그룹 id
  String? _groupId;

  // 퀴즈 목록중 현재 진행중인 퀴즈의 위치
  int _playPosition = 0;
  // 퀴즈 목록중 현재 진행중이 퀴즈의 영어 단어 상태 변경을 위한 변수
  String _quizEng = '';

  // 다음 문제로 이동시 정답/오답 을 기록하기 위한 리스트
  List<Map<String, dynamic>> _gradeQuizes = [];
  // 3개의 한글 객관식 문항을 저장하는 리스트
  List<String> _koQuestions = ['','',''];
  bool _isAlready = false;

  Future<void> _checkAlready() async {
    var data = await UserGradeController.GetQuizCountByGroupId(UserSingleton().uid, _groupId);
    if(data != '0'){
      _isAlready=true;
    }
  }

  // 다음 버튼이 눌렸을때 정답인지 오답인지 체크해 _gradeQuizes 리스트에 'id', 'iscorrect' 키 값으로 어떤퀴즈를 맞췄는지 기록한다.
  void _setGrade(){
    int idx = 0;
    if(Char.A == _char){
      idx = 0;
    }else if(Char.B == _char){
      idx = 1;
    }else{
      idx = 2;
    }
    if(_quizes[_playPosition].ko_word == _koQuestions[idx]) {
      _gradeQuizes.add({'id': _quizes[_playPosition].id, 'is_correct':true});
    }else{
      _gradeQuizes.add({'id': _quizes[_playPosition].id, 'is_correct':false});
    }
  }

  // 페이지 전달 값을 가져온다.
  void _getArguments(){
    if(ModalRoute.of(context)!.settings.arguments != null) {
      _groupId = ModalRoute.of(context)!.settings.arguments as String;
    }
  }

  // 퀴즈의 목록을 비동기로 가져온다.
  Future<void> _getQuizes() async {
    QuizController.GetQuizesAsync(_groupId, (value)=>{
      setState(() {
        if(value != null) {
          _quizes = List<Quiz>.from(value.map((quizData) => Quiz.fromJson(quizData)).toList());

          _quizEng = _quizes[_playPosition].eng_word;
          print(_quizes);
        }
      })
    });
  }

  // 객관식 문제를 가져와 답안을 랜덤으로 배치한다.
  Future<void> _getQuizKoWords() async {
    var datas = await QuizController.GetQuizKoWords();
    print(datas);
    if(datas != null){
      setState(() {
        _koQuestions[0] = (datas.isNotEmpty)?datas[0].ko_word:'';
        _koQuestions[1] = (datas.length > 1)?datas[1].ko_word:'';
        _koQuestions[2] = (datas.length > 2)?datas[2].ko_word:'';

        if(_koQuestions[0] != _quizes[_playPosition].ko_word &&
            _koQuestions[1] != _quizes[_playPosition].ko_word &&
            _koQuestions[2] != _quizes[_playPosition].ko_word) {
          // 3문항중 랜덤위치에 정답을 위치시키다.
          int number = Random().nextInt(2);
          _koQuestions[number] = _quizes[_playPosition].ko_word;
        }
      });
    }
  }

  // 화면을 다음문제로 변경한다.
  Future<void> _setNextQuiz() async {
    _setGrade();

    _playPosition++;
    if(_playPosition < _quizes.length) {
      _quizEng = _quizes[_playPosition].eng_word;
      await _getQuizKoWords();
    }else{
      // 퀴즈 종료
      // 이미 수행했던 퀴즈일경우 삭제 후 다시 저장한다.
      if(_isAlready){
        await UserGradeController.DeleteMyGrade(UserSingleton().uid, _groupId);
      }

      int count = 0;
      _gradeQuizes.forEach((element) async {
        if(element['is_correct']){
          count++;
        }

        await UserGradeController.InsertMyGrade(UserSingleton().uid, element['id'], element['is_correct'], _groupId);
      });

      await Common.showMyDialog(context, '확인', '문제풀이가 끝났습니다.\n점수는 ${_gradeQuizes.length} / $count 입니다.');
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAlready();
      _getArguments();
      _getQuizes();
      _getQuizKoWords();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('퀴즈'),
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
        // body 최상위 위젯이며 배경색을 지정해 줍니다.
        body: Container(
            color: Color(0xffeeee44),
            // 넓이, 높이 모두 화면을 꽉채우게 만듭니다.
            height: double.infinity,
            width: double.infinity,
            // 문제를 출력할 영역이며 흰바탕을 줍니다.
            child: Container(
              decoration: BoxDecoration(
                  color: const Color(0xffffffff),
                  //모서리 둥글게
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white, width: 1)),
              // 넓이, 높이를 상위 위젯에 꽉채우게 만들며 마진을 주어서 살짝 공간을 줍니다.
              // 패딩은 흰바탕의 영역에 채워질 위젯들의 왼쪽 오른쪽에 공간을 줍니다.
              width: double.infinity,
              height: double.infinity,
              margin: const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 30),
              padding: const EdgeInsets.only(left: 30, right: 30),
              // 위에서 아래로 배치하기 위해 Column 위젯으로 감쌉니다.
              child: Column(
                // 화면의 가운데 정렬을해줍니다.
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 문제가 출력될 위젯입니다.
                  Container(
                      margin: const EdgeInsets.only(top: 100),
                      child: Text(
                        _quizEng,
                        style: TextStyle(fontSize: 25, color: Colors.black87, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      )),
                  // 위젯사이에 공간을 주기위해 Spacer()를 사용합니다.
                  Spacer(),
                  // 1번째 문항 RadioListTile 위젯을 사용합니다.
                  RadioListTile<Char>(
                    fillColor: MaterialStateColor.resolveWith((states) => Color(0xffdd4444)),
                    title: Text(_koQuestions[0], style: const TextStyle(fontSize: 20, color: Colors.black87)),
                    value: Char.A,
                    groupValue: _char,
                    onChanged: (Char? value) {
                      setState(() {
                        _char = value!;
                      });
                    },
                  ),
                  // 2번째 문항 RadioListTile 위젯을 사용합니다.
                  RadioListTile<Char>(
                    fillColor: MaterialStateColor.resolveWith((states) => Color(0xffdd4444)),
                    title: Text(_koQuestions[1], style: const TextStyle(fontSize: 20, color: Colors.black87)),
                    value: Char.B,
                    groupValue: _char,
                    onChanged: (Char? value) {
                      setState(() {
                        _char = value!;
                      });
                    },
                  ),
                  // 3번째 문항 RadioListTile 위젯을 사용합니다.
                  RadioListTile<Char>(
                    fillColor: MaterialStateColor.resolveWith((states) => Color(0xffdd4444)),
                    title: Text(_koQuestions[2], style: const TextStyle(fontSize: 20, color: Colors.black87)),
                    value: Char.C,
                    groupValue: _char,
                    onChanged: (Char? value) {
                      setState(() {
                        _char = value!;
                      });
                    },
                  ),
                  Spacer(),
                  // 취소, 다음 버튼을 만드는 영역입니다.
                  Container(
                      margin: const EdgeInsets.only(bottom: 100),
                      // 가로로 위젯을 배치하기 위해 Row로 감쌉니다.
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 취소
                          Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(elevation: 0, backgroundColor: Color(0xffeeee44)),
                                child: const Text('취소', style: const TextStyle(fontSize: 18, color: Colors.black87)),
                              )),
                          // 다음 버튼
                          Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: ElevatedButton(
                                onPressed: () {
                                  _setNextQuiz();
                                },
                                style: ElevatedButton.styleFrom(elevation: 0, backgroundColor: const Color(0xffeeee44)),
                                child: const Text(
                                  '다음',
                                  style: TextStyle(fontSize: 18, color: Colors.black87),
                                ),
                              )),
                        ],
                      ))
                ],
              ),
            )),
      ),
    );
  }
}
