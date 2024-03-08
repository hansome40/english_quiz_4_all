import 'dart:io';
import 'package:english_quiz_4_all/utils/user_singleton.dart';
import 'package:english_quiz_4_all/utils/common.dart';
import 'package:english_quiz_4_all/utils/macro.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as Path;


class MyInfo extends StatefulWidget {
  const MyInfo({super.key});

  @override
  State<MyInfo> createState() => _MyInfoState();
}

class _MyInfoState extends State<MyInfo> {

  final _supabase = Supabase.instance.client;
  UserSingleton _userSingleton = UserSingleton();
  late ImageProvider _provider;
  // 학생인지 마스터인지
  bool _isMaster = false;
  String _swithchValue = '학생';

  // 갤러리에서 파일을 받아오기 위해
  XFile? _file;

  @override
  void initState() {
    super.initState();
    _setUserMode();
    _setThumbnail();
  }

  void _setUserMode(){
    _swithchValue = _userSingleton.mode;
    if(_swithchValue == '학생'){
      _isMaster=false;
    }else{
      _isMaster=true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text('내 정보'),
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
          body: Container(
            color: const Color(0xffeeee44),
            width: double.infinity,
            height: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                  color: const Color(0xffffffff),
                  //모서리 둥글게
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white, width: 1)),
              margin: const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 30),
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          // width: double.infinity,
                          // height: 80,
                          child: CircleAvatar(
                            // 온라인상의 이미지를 보여주기 위해 NetworkImage를 사용합니다.
                            foregroundImage: _provider,
                            minRadius: 60,
                            maxRadius: 60,
                          ),
                        ),
                        Container(
                          height: 130,
                          child: Align(
                            alignment: Alignment(0.0,1.0),
                            child: TextButton(
                              child: Text(
                                "변경",
                                style: TextStyle(fontSize: 20, color: Colors.black87, backgroundColor: Colors.white),
                              ),
                              onPressed: (){
                                _pickImage();
                              },
                              // style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.white)),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: Row(
                      children: [
                        Container(
                            width:120,
                            child: Text('아이디', style: TextStyle(fontSize: 20, color: Colors.black87))
                        ),
                        Text('test', style: TextStyle(fontSize: 25, color: Colors.black87)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        Container(
                            width:120,
                            child: Text('모드', style: TextStyle(fontSize: 20, color: Colors.black87))
                        ),
                        Container(width:70,child: Text(_swithchValue, style: TextStyle(fontSize: 25, color: Colors.black87))),
                        Switch(
                            value: _isMaster,
                            onChanged: (value) {
                              setState(() {
                                _isMaster = value;
                                if(_isMaster){
                                  _swithchValue = MODE_MACRO.MODE_MASTER;
                                }else{
                                  _swithchValue = MODE_MACRO.MODE_STUDENT;
                                }
                              });
                            })
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        Container(
                            width:120,
                            child: Text('점수', style: TextStyle(fontSize: 20, color: Colors.black87))
                        ),
                        Container(
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/my_grade_group');
                              },
                              // style: ElevatedButton.styleFrom(elevation: 0, backgroundColor: Color(0xffeeee44)),
                              child: const Text('점수 보러가기', style: const TextStyle(fontSize: 18, color: Color(0xff3333ee))),
                            )
                        ),
                      ],
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 100),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 취소
                          Flexible(
                            fit: FlexFit.tight,
                            child: Container(
                                margin: const EdgeInsets.only(right: 10),
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(elevation: 0, backgroundColor: Color(0xffeeee44)),
                                  child: const Text('취소', style: const TextStyle(fontSize: 18, color: Colors.black87)),
                                )),
                          ),
                          // 저장 버튼
                          Flexible(
                            fit: FlexFit.tight,
                            child: Container(
                                margin: const EdgeInsets.only(left: 10),
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {

                                    String thumbPath = '';
                                    if(_file != null){

                                      String currentThumb = _userSingleton.thumb;
                                      if(currentThumb.isNotEmpty){
                                        final List<FileObject> objects = await _supabase
                                            .storage
                                            .from('images')
                                            .remove([currentThumb]);
                                      }

                                      DateTime time = DateTime.now();

                                      String filePath = _file!.path;
                                      String fileName = time.millisecondsSinceEpoch.toString() + _file!.name;

                                      try{

                                        final avatarFile = File(filePath);
                                        thumbPath = await _supabase.storage.from('images').upload(
                                          fileName,
                                          avatarFile,
                                          fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
                                        );

                                        thumbPath = Path.basename(thumbPath);
                                        // print('path : $path');

                                      }catch(e){
                                        print(e);
                                        await Common.showMyDialog(context, '확인', '업로드에 실패했습니다.');
                                        return;
                                      }
                                    }

                                    var datas = <String,String>{};
                                    if(thumbPath.isNotEmpty){
                                      datas[Macro.user_data_thumb_key] = thumbPath;
                                      _userSingleton.thumb = thumbPath;
                                    }
                                    if(_userSingleton.mode != _swithchValue){
                                      datas[Macro.user_data_mode_key] = _swithchValue;
                                      _userSingleton.mode = _swithchValue;
                                    }

                                    try{
                                      final UserResponse res = await _supabase.auth.updateUser(
                                        UserAttributes(
                                            data: datas
                                        ),
                                      );

                                      await Common.showMyDialog(context, "확인", "저장이 완료됐습니다.");

                                    }catch(e){
                                      print(e);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(elevation: 0, backgroundColor: const Color(0xffeeee44)),
                                  child: const Text(
                                    '저장',
                                    style: TextStyle(fontSize: 18, color: Colors.black87),
                                  ),
                                )),
                          ),
                        ],
                      ))
              ]),
            ),
          ),
        )
    );
  }

  void _setThumbnail(){

    if(_file != null){
      _provider = Image.file(
        File(_file!.path.toString()),
          fit: BoxFit.cover,
      ).image;
    }else{
      String userThumb = '';
      if(_userSingleton.thumb.isNotEmpty){
        if(_userSingleton.thumb.contains('http')){
          userThumb = _userSingleton.thumb;
        }else{
          // String t = _userSingleton.thumb;
          // print('user thumb : $t');
          try{
            userThumb = _supabase
                .storage
                .from('images')
                .getPublicUrl(_userSingleton.thumb);
          }catch(e){
            print(e);
          }
        }
      }

      // print('supa path : $userThumb');
      _provider = (userThumb.isNotEmpty)?NetworkImage(userThumb):Image.asset('assets/images/gray.png').image;
    }
  }

  Future<void> _pickImage() async {
    ImagePicker().pickImage(source: ImageSource.gallery).then((image) {
      if (image != null) {
        setState(() {
          _file = image;
          _setThumbnail();
        });
      }
    });
  }

}
