import 'package:english_quiz_4_all/controller/quiz_controller.dart';
import 'package:english_quiz_4_all/utils/common.dart';
import 'package:flutter/material.dart';

import '../model/quiz.dart';
import '../utils/macro.dart';

class AddQuiz extends StatelessWidget {
  AddQuiz({super.key});

  // 영어 단어를 받아오기 위한 컨트롤러 변수
  final _engEditingController = TextEditingController();
  // 한글 뜻을 받아오기 위한 컨트롤러 변수
  final _koEditingController = TextEditingController();

  Quiz? _quiz;
  String mode = QUIZ_MACRO.MODE_ADD;

  void _getArguments(context){
    if(ModalRoute.of(context)!.settings.arguments != null) {
      var val = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

      _quiz = val['quiz'] as Quiz;

      _engEditingController.text = _quiz!.eng_word;
      _koEditingController.text = _quiz!.ko_word;

      mode = val['mode'] as String;
    }
  }

  @override
  Widget build(BuildContext context) {
    _getArguments(context);

    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text((mode == QUIZ_MACRO.MODE_ADD)?'퀴즈 추가':'퀴즈 수정'),
          backgroundColor: const Color(0xffdddd55),
          centerTitle: true,
        ),
        body: GestureDetector(
          onTap: () {
            // 키보드 닫기 이벤트
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Container(
            height: double.infinity,
            width: double.infinity,
            color: Color(0xffeeee44),
            child: Container(
              decoration: BoxDecoration(
                  color: const Color(0xffffffff),
                  //모서리 둥글게
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white, width: 1)),
              width: double.infinity,
              height: double.infinity,
              margin: const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 30),
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Column(
                // 가운데 정렬을 위해
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(left: 5, top: 100),
                      child: const Text(
                        '영어단어',
                        style: TextStyle(fontSize: 25, color: Colors.black87, fontWeight: FontWeight.bold),
                        // textAlign: TextAlign.center,
                      )),
                  // 영어 단어 입력창
                  Container(
                      height: 60,
                      margin: const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 5),
                      child: TextField(
                          controller: _engEditingController,
                          style: const TextStyle(fontSize: 16, color: Colors.black87),
                          decoration: const InputDecoration(
                            hintText: '영어 단어를 입력해 주세요',
                            border: OutlineInputBorder(),
                          ))),
                  // 한글 뜻 입력창
                  Container(
                    width: double.infinity,
                      margin: const EdgeInsets.only(left: 5, top: 30),
                      child: const Text(
                        '한글 뜻',
                        style: TextStyle(fontSize: 25, color: Colors.black87, fontWeight: FontWeight.bold),
                        // textAlign: TextAlign.center,
                      )),
                  Container(
                      height: 60,
                      margin: const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 5),
                      child: TextField(
                          controller: _koEditingController,
                          style: const TextStyle(fontSize: 16, color: Colors.black87),
                          decoration: const InputDecoration(
                            hintText: '한글 뜻을 입력해 주세요',
                            border: OutlineInputBorder(),
                          ))),
                  // 등록, 취소 버튼
                  Container(
                      margin: const EdgeInsets.only(top: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 등록 버튼
                          Container(
                            width: 100,
                              margin: const EdgeInsets.only(right: 10),
                              child: ElevatedButton(
                                onPressed: () async {
                                  if(mode == QUIZ_MACRO.MODE_ADD){
                                    bool b = await QuizController.InsertQuiz(
                                        _engEditingController.text,
                                        _koEditingController.text,
                                        _quiz!.group_id);

                                    if(b) {
                                      Navigator.pop(context);
                                    } else{
                                      await Common.showMyDialog(context, '오류', '등록 실패');
                                    }
                                  }else{
                                    await QuizController.UpdateQuiz(
                                        _engEditingController.text,
                                        _koEditingController.text,
                                        _quiz!.id
                                    );
                                    Navigator.pop(context);
                                  }
                                },
                                style: ElevatedButton.styleFrom(elevation: 0, backgroundColor: Color(0xffeeee44)),
                                child: const Text('등록', style: const TextStyle(fontSize: 18, color: Colors.black87)),
                              )),
                          // 취소 버튼
                          Container(
                              width: 100,
                              margin: const EdgeInsets.only(left: 10),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(elevation: 0, backgroundColor: const Color(0xffeeee44)),
                                child: const Text(
                                  '취소',
                                  style: TextStyle(fontSize: 18, color: Colors.black87),
                                ),
                              )),
                        ],
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}