import 'package:flutter/material.dart';
import '../models/english_question.dart';
import '../services/adaptive_test_service.dart';
import '../data/question_bank.dart';
import 'adaptive_result_page.dart';

class AdaptiveTestPage extends StatefulWidget {
  const AdaptiveTestPage({super.key});

  @override
  State<AdaptiveTestPage> createState() => _AdaptiveTestPageState();
}

class _AdaptiveTestPageState extends State<AdaptiveTestPage> {
  late final AdaptiveTestService _testService;
  EnglishQuestion? _currentQuestion;
  final int _totalQuestions = 15; // テスト全体の問題数
  List<String> _shuffledOptions = [];

  @override
  void initState() {
    super.initState();
    _testService = AdaptiveTestService();
    _loadNextQuestion();
  }

  void _loadNextQuestion() {
    setState(() {
      _currentQuestion = _testService.getNextQuestion();
      if (_currentQuestion != null) {
        _shuffledOptions = _currentQuestion!.shuffledOptions;
      }
    });
  }

  void _answerQuestion(String selectedAnswer) {
    if (_currentQuestion == null) return;

    final isCorrect = selectedAnswer == _currentQuestion!.correctAnswer;
    _testService.recordAnswer(_currentQuestion!, isCorrect);

    _showResultDialog(isCorrect, selectedAnswer);
  }

  void _showResultDialog(bool isCorrect, String selectedAnswer) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                color: isCorrect ? Colors.green : Colors.red,
                size: 28,
              ),
              const SizedBox(width: 8),
              Text(
                isCorrect ? '正解！' : '不正解',
                style: TextStyle(
                  color: isCorrect ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('あなたの答え: $selectedAnswer'),
                const SizedBox(height: 8),
                Text(
                  '正解: ${_currentQuestion!.correctAnswer}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Divider(height: 24),
                const Text(
                  '解説',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(_currentQuestion!.explanation),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _proceedToNext();
              },
              child: Text(
                _testService.questionsAnswered < _totalQuestions ? '次へ' : '結果を見る',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  void _proceedToNext() {
    if (_testService.questionsAnswered >= _totalQuestions) {
      // テスト終了、結果画面へ
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AdaptiveResultPage(testService: _testService),
        ),
      );
    } else {
      // 次の問題へ
      _loadNextQuestion();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentQuestion == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('英語レベルテスト'),
          backgroundColor: Colors.deepPurple,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final progress = _testService.questionsAnswered / _totalQuestions;
    final difficultyDescription = difficultyDescriptions[_testService.currentDifficultyLevel] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('問題 ${_testService.questionsAnswered + 1} / $_totalQuestions'),
        backgroundColor: Colors.deepPurple,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // 進捗バー
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.deepPurple),
            minHeight: 8,
          ),

          // 難易度インジケーター
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            color: Colors.deepPurple.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.trending_up, size: 20, color: Colors.deepPurple.shade700),
                const SizedBox(width: 8),
                Text(
                  '現在の難易度: $difficultyDescription',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.deepPurple.shade700,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // カテゴリ表示
                  Chip(
                    label: Text(_currentQuestion!.category),
                    backgroundColor: Colors.deepPurple.shade100,
                    labelStyle: TextStyle(
                      color: Colors.deepPurple.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 問題文
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        _currentQuestion!.question,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 選択肢
                  ..._shuffledOptions.map((option) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.grey.shade300, width: 1),
                          ),
                        ),
                        onPressed: () => _answerQuestion(option),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            option,
                            style: const TextStyle(fontSize: 16, height: 1.3),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
