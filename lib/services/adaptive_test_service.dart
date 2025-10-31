import 'dart:math';
import '../models/english_question.dart';
import '../data/question_bank.dart';

class AdaptiveTestService {
  int _currentDifficultyLevel = 2; // 初期難易度: 中級
  final List<EnglishQuestion> _askedQuestions = [];
  final List<bool> _answerHistory = [];
  final Map<int, int> _levelQuestionCount = {};

  int get currentDifficultyLevel => _currentDifficultyLevel;
  List<EnglishQuestion> get askedQuestions => List.unmodifiable(_askedQuestions);
  List<bool> get answerHistory => List.unmodifiable(_answerHistory);

  // 次の問題を取得
  EnglishQuestion? getNextQuestion() {
    final availableQuestions = questionBank[_currentDifficultyLevel];
    
    if (availableQuestions == null || availableQuestions.isEmpty) {
      return null;
    }

    // まだ出題していない問題をフィルタリング
    final unaskedQuestions = availableQuestions
        .where((q) => !_askedQuestions.contains(q))
        .toList();

    if (unaskedQuestions.isEmpty) {
      // すべての問題を出題済みの場合、レベル内でランダムに再出題
      final random = Random();
      return availableQuestions[random.nextInt(availableQuestions.length)];
    }

    // ランダムに問題を選択
    final random = Random();
    return unaskedQuestions[random.nextInt(unaskedQuestions.length)];
  }

  // 回答を記録し、難易度を調整
  void recordAnswer(EnglishQuestion question, bool isCorrect) {
    _askedQuestions.add(question);
    _answerHistory.add(isCorrect);
    _levelQuestionCount[_currentDifficultyLevel] = 
        (_levelQuestionCount[_currentDifficultyLevel] ?? 0) + 1;

    // 難易度の調整
    if (isCorrect) {
      // 正解の場合、難易度を上げる（最大5）
      if (_currentDifficultyLevel < 5) {
        _currentDifficultyLevel++;
      }
    } else {
      // 不正解の場合、難易度を下げる（最小1）
      if (_currentDifficultyLevel > 1) {
        _currentDifficultyLevel--;
      }
    }
  }

  // テストの進捗状況を取得
  int get questionsAnswered => _askedQuestions.length;

  // カテゴリ別の正答率を計算
  Map<String, double> getCategoryAccuracy() {
    final Map<String, int> correctByCategory = {};
    final Map<String, int> totalByCategory = {};

    for (int i = 0; i < _askedQuestions.length; i++) {
      final question = _askedQuestions[i];
      final isCorrect = _answerHistory[i];
      final category = question.category;

      totalByCategory[category] = (totalByCategory[category] ?? 0) + 1;
      if (isCorrect) {
        correctByCategory[category] = (correctByCategory[category] ?? 0) + 1;
      }
    }

    final Map<String, double> accuracy = {};
    for (final category in totalByCategory.keys) {
      accuracy[category] = (correctByCategory[category] ?? 0) / totalByCategory[category]!;
    }

    return accuracy;
  }

  // レベル別の問題数を取得
  Map<int, int> get levelQuestionCount => Map.unmodifiable(_levelQuestionCount);

  // テストをリセット
  void reset() {
    _currentDifficultyLevel = 2;
    _askedQuestions.clear();
    _answerHistory.clear();
    _levelQuestionCount.clear();
  }
}
