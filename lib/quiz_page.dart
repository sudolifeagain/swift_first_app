// quiz_page.dart

import 'package:flutter/material.dart';
import 'result_page.dart'; // エラー出ますが、気にしないでください！
// データモデルと実際のクイズデータをインポート
import 'quiz.dart';
import 'quiz_data.dart';
// result_page.dart への遷移準備のため、仮でインポートしておきます
// import 'result_page.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  // 現在表示している問題のインデックスを保持
  int _currentQuestionIndex = 0;
  // 正解数を保持（結果画面への引き渡しに備えて）
  int _score = 0;

  // ----------------------------------------------------
  // 選択肢がタップされたときの処理
  // ----------------------------------------------------
  void _answerQuestion(String selectedAnswer) {
    // 現在の問題データを取得
    final currentQuiz = quizData[_currentQuestionIndex];
    // 正誤判定
    final isCorrect = selectedAnswer == currentQuiz.correctAnswer;

    // スコアの更新
    if (isCorrect) {
      _score++;
    }

    // 結果ダイアログを表示
    _showResultDialog(isCorrect, selectedAnswer, currentQuiz);
  }

  // ----------------------------------------------------
  // 結果ダイアログの表示
  // ----------------------------------------------------
  void _showResultDialog(bool isCorrect, String selectedAnswer, Quiz quiz) {
    showDialog(
      context: context,
      // ユーザーがダイアログ外をタップしても閉じないようにする
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            isCorrect ? '✅ 正解です！' : '❌ 不正解...',
            style: TextStyle(
              color: isCorrect ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                // 選択した答え
                Text('あなたの答え: $selectedAnswer'),
                // 正解の答え
                Text(
                  '正解: ${quiz.correctAnswer}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Divider(),
                // 解説
                const Text(
                  '【解説】',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(quiz.explanation),
              ],
            ),
          ),
          actions: <Widget>[
            // 「次へ」ボタン
            TextButton(
              child: Text(
                _currentQuestionIndex < quizData.length - 1 ? '次へ' : '結果を見る',
                style: const TextStyle(fontSize: 18),
              ),
              onPressed: () {
                // ダイアログを閉じる
                Navigator.of(context).pop();
                // 次の問題へ進む、または結果画面へ遷移する
                _goToNextQuestion();
              },
            ),
          ],
        );
      },
    );
  }

  // ----------------------------------------------------
  // 次の問題への遷移処理
  // ----------------------------------------------------
  void _goToNextQuestion() {
    // 最終問題かどうかを判定
    if (_currentQuestionIndex < quizData.length - 1) {
      // 最終問題ではない場合: 状態を更新して次の問題へ
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(score: _score), // スコアを渡す想定
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 現在の問題データを取得
    final currentQuiz = quizData[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('クイズ (${_currentQuestionIndex + 1} / ${quizData.length})'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // --- 問題文 ---
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  currentQuiz.question,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // --- 選択肢の表示 ---
            // quiz.dart で定義した allAnswers Getter を利用して、シャッフルされたリストを取得
            ...currentQuiz.allAnswers.map((answer) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => _answerQuestion(answer), // 選択肢タップでダイアログ表示
                  child: Text(
                    answer,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
