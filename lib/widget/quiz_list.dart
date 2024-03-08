import 'package:flutter/material.dart';

import '../controller/quiz_controller.dart';
import '../model/group.dart';
import '../model/quiz.dart';
import '../utils/macro.dart';

class QuizListPage extends StatefulWidget {
  const QuizListPage({super.key});

  @override
  State<QuizListPage> createState() => _QuizListPageState();
}

class _QuizListPageState extends State<QuizListPage> {

  List<Quiz> _quizes = [];
  late String _groupId;

  Future<void> _getQuizes() async {
    QuizController.GetQuizesAsync(_groupId, (value)=>{
      setState(() {
        if(value != null) {
          var data = List<Quiz>.from(value.map((quizData) => Quiz.fromJson(quizData)).toList());
          _quizes = data;
        }
      })
    });
  }

  void _getArguments(){
    if(ModalRoute.of(context)!.settings.arguments != null) {
      var group = ModalRoute.of(context)!.settings.arguments as Group;
      _groupId = group.id;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getArguments();
      _getQuizes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('퀴즈 목록'),
        backgroundColor: const Color(0xffdddd55),
        centerTitle: true,
        actions: [
          IconButton(
            // 오른쪽 영역 아이콘버튼의 이벤트를 만듭니다.
            onPressed: () {
              Navigator.pushNamed(context, '/play_quiz', arguments: _groupId);
            },
            // 오른쪽 영역 아이콘버튼의 이미지를 설정하는 코드입니다.
            icon: const Icon(Icons.play_circle),
          ),
          // 오른쪽 영역에 들어갈 아이콘버튼을 생성하는 코드입니다.
          IconButton(
            // 오른쪽 영역 아이콘버튼의 이벤트를 만듭니다.
            onPressed: () async {
              await Navigator.pushNamed(
                  context, '/add_quiz',
                  arguments: {'quiz': Quiz(id: '', eng_word: '', ko_word: '', created_at: '', group_id: _groupId), 'mode':QUIZ_MACRO.MODE_ADD}
              );
              _getQuizes();
            },
            // 오른쪽 영역 아이콘버튼의 이미지를 설정하는 코드입니다.
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: make_listview()
    );
  }

  Widget make_listview() {
    // 화면에보이는 부분의 셀만 만드는 리스트뷰를 생성합니다.
    return ListView.separated(
        itemCount: _quizes.length,
        itemBuilder: (BuildContext context, int index) {
          // 플러터에서 제공하는 Dismissible 위젯입니다.
          // 이 위젯은 리스트뷰의 셀을 스와이프 하게되면 onDismissed 이벤트가 들어오고 이곳에서 데이터 변경을 처리하면 됩니다.
          return Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) async {
              bool res = await QuizController.DeleteQuiz(_quizes[index].id);
              setState(() {
                if(res) {
                  _quizes.removeAt(index);
                }
              });
            },
            // 스와이프시 배경색 지정
            background: Container(color: Colors.red),
            child: ListTile(
              title: Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  _quizes[index].eng_word,
                  style:
                  const TextStyle(fontSize: 22, color: Colors.black87, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
              ),
              subtitle: Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  _quizes[index].ko_word,
                  style:
                  const TextStyle(fontSize: 18, color: Colors.black87),
                  textAlign: TextAlign.left,
                ),
              ),
              // trailing 속성에 이미지를 넣으면 셀의 오른쪽 끝에 만들어집니다.
              trailing: const Icon(Icons.navigate_next),
              // 셀을 눌렀을때 발생하는 이벤트를 처리하는곳 입니다.
              onTap: () async {
                await Navigator.pushNamed(
                    context, '/add_quiz',
                    arguments: {'quiz':_quizes[index], 'mode':QUIZ_MACRO.MODE_MODIFY}
                );
                _getQuizes();
              },
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider();
        });
  }
}
