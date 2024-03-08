import 'package:english_quiz_4_all/widget/find_master.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'widget/my_grade_group.dart';
import 'widget/my_grade_list.dart';
import 'widget//my_info.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'widget/splash.dart';
import 'widget/home.dart';
import 'widget/login.dart';
import 'widget/quiz_list.dart';
import 'widget/add_quiz.dart';
import 'widget/play_quiz.dart';
import 'widget/join_user.dart';

// final supabase = Supabase.instance.client;

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  String supabaseUrl = dotenv.get('SUPABASE_URL', fallback: '');
  String supabaseKey = dotenv.get('SUPABASE_KEY', fallback: '');
  String nativeAppKey = dotenv.get('NATIVEAPPKEY', fallback: '');
  String javaScriptAppKey = dotenv.get('JAVA_SCRIPT_APP_KEY', fallback: '');

  // String supabaseUrl = 'https://awbameiezlmzrjxhbeet.supabase.co';
  // String supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF3YmFtZWllemxtenJqeGhiZWV0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDQ5NDc1MTMsImV4cCI6MjAyMDUyMzUxM30.GddLQJDXOhhDivdIi11Mk5GbLj5A_PGAqchar4IaOGE';

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseKey,
  );

  KakaoSdk.init(
      nativeAppKey: nativeAppKey,
      javaScriptAppKey: javaScriptAppKey,
  );

  runApp(MaterialApp(
    initialRoute: '/splash',
    routes: {
      '/splash': (context) => const SplashScreen(),
      '/home': (context) => const Home(),
      '/login': (context) => LoginPage(),
      '/quiz_list': (context) => const QuizListPage(),
      '/add_quiz': (context) => AddQuiz(),
      '/play_quiz': (context) => PlayQuiz(),
      '/join_user': (context) => JoinUser(),
      '/my_info': (context) => MyInfo(),
      '/my_grade_group': (context) => MyGradeGroup(),
      '/my_grade_list': (context) => MyGradeList(),
      '/find_master': (context) => FindMaster(),
    },
  ));
}