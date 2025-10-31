// home_page.dart

import 'package:flutter/material.dart';
import 'quiz_page.dart'; // エラー出ますが、一旦気にしないでください！

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('クイズアプリ'),
        backgroundColor: Colors.blueAccent, // アプリバーの色を設定
      ),
      body: Center(
        child: Column(
          // 画面中央に要素を配置
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Flutter クイズへようこそ！',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 50), // スペース調整
            // クイズ開始ボタン
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // 遷移先を指定
                    builder: (context) => const QuizPage(),
                  ),
                );
              },
              icon: const Icon(Icons.play_arrow),
              label: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text('クイズを始める', style: TextStyle(fontSize: 20)),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, // ボタンの背景色
                foregroundColor: Colors.white, // テキストとアイコンの色
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // 角丸
                ),
                elevation: 5, // 影の濃さ
              ),
            ),
          ],
        ),
      ),
    );
  }
}
