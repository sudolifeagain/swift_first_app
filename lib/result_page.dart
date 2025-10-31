// result_page.dart

import 'package:flutter/material.dart';
import 'package:myapp/home_page.dart';
import 'quiz_page.dart';
import 'package:myapp/quiz_data.dart';

class ResultPage extends StatelessWidget {
  // QuizPage から受け取る正解数
  final int score;

  // コンストラクタでスコアを受け取る
  const ResultPage({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    // 問題の総数
    final int totalQuestions = quizData.length;

    // スコアに応じて表示するコメントを決定する
    String comment;
    Color commentColor;

    if (score == totalQuestions) {
      comment = '素晴らしい！全問正解です！🎉';
      commentColor = Colors.orange; // 素晴らしい！はオレンジ色
    } else if (score == 0) {
      comment = '残念！また挑戦してね！💪';
      commentColor = Colors.grey; // 残念！はグレー
    } else {
      comment = '惜しい！あともう一歩！';
      commentColor = Colors.blue; // 惜しい！は青色
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('クイズ結果'),
        backgroundColor: Colors.blueAccent,
        // 結果画面では「戻る」ボタンを非表示にする（クイズをやり直せないようにするため）
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '🎉 クイズ終了 🎉',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            // スコア表示
            Text(
              'あなたのスコア: $score / $totalQuestions 問正解',
              style: const TextStyle(fontSize: 24, color: Colors.indigo),
            ),

            // コメント表示
            Text(
              comment,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: commentColor, // スコアに応じた色
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 50),

            // ホームに戻るボタン
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  // 遷移先の画面 (新しい HomePage)
                  MaterialPageRoute(builder: (context) => const HomePage()),
                  // ルートを削除する条件: (route) => false
                  // この条件は常に偽を返すため、すべての過去のルート（HomePage, QuizPage, ResultPage）が削除されます。
                  (Route<dynamic> route) => false,
                );
              },
              icon: const Icon(Icons.home),
              label: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Text('ホームに戻る', style: TextStyle(fontSize: 18)),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
