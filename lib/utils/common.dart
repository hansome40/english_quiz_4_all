import 'package:flutter/material.dart';

class Common{
  // 메세지창을 만드는 함수로 앞으로 메세지창이 필요한경우 이함수를 사용하면 됩니다.(버튼은 하나입니다.)
  static Future<void> showMyDialog(context, title, content) async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('확인', style: const TextStyle(fontSize: 16, color: Colors.black87)))
          ],
          title: Text(title, style: const TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.bold)),
          content: Text(content, style: const TextStyle(fontSize: 16, color: Colors.black87)),
        ));
  }

  static Future<String> showYesNoDialog(context, title, content) async {
    return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop('cancel');
                },
                child: Text('취소', style: const TextStyle(fontSize: 16, color: Colors.black87))),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop('confirm');
                },
                child: Text('확인', style: const TextStyle(fontSize: 16, color: Colors.black87)))
          ],
          title: Text(title, style: const TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.bold)),
          content: Text(content, style: const TextStyle(fontSize: 16, color: Colors.black87)),
        ));
  }
}