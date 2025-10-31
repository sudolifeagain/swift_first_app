import 'dart:math';

class ScoreCalculator {
  // 難易度レベルごとの基準スコア範囲
  static const Map<int, Map<String, int>> _levelScoreRanges = {
    1: {'min': 300, 'max': 400},
    2: {'min': 400, 'max': 500},
    3: {'min': 500, 'max': 650},
    4: {'min': 650, 'max': 800},
    5: {'min': 800, 'max': 990},
  };

  // TOEICスコアを計算
  static int calculateTOEICScore({
    required List<bool> answerHistory,
    required Map<int, int> levelQuestionCount,
  }) {
    if (answerHistory.isEmpty) {
      return 0;
    }

    // 全体の正答率
    final totalCorrect = answerHistory.where((a) => a).length;
    final totalQuestions = answerHistory.length;
    final overallAccuracy = totalCorrect / totalQuestions;

    // 各レベルでの正答数を集計
    int currentIndex = 0;
    final Map<int, int> correctByLevel = {};
    final Map<int, int> totalByLevel = {};

    for (final level in levelQuestionCount.keys) {
      final count = levelQuestionCount[level]!;
      final levelAnswers = answerHistory.sublist(currentIndex, min(currentIndex + count, answerHistory.length));
      
      totalByLevel[level] = levelAnswers.length;
      correctByLevel[level] = levelAnswers.where((a) => a).length;
      
      currentIndex += count;
    }

    // 最も多く回答したレベルを基準とする
    int primaryLevel = 2;
    int maxCount = 0;
    for (final level in totalByLevel.keys) {
      if (totalByLevel[level]! > maxCount) {
        maxCount = totalByLevel[level]!;
        primaryLevel = level;
      }
    }

    // そのレベルでの正答率
    final levelAccuracy = totalByLevel[primaryLevel]! > 0
        ? correctByLevel[primaryLevel]! / totalByLevel[primaryLevel]!
        : 0.5;

    // 基準スコアを計算
    final minScore = _levelScoreRanges[primaryLevel]!['min']!;
    final maxScore = _levelScoreRanges[primaryLevel]!['max']!;
    final levelRange = maxScore - minScore;

    // スコア = 基準最小値 + (レベル範囲 × 正答率)
    int baseScore = minScore + (levelRange * levelAccuracy).round();

    // 全体の正答率による微調整（±20点）
    final adjustment = ((overallAccuracy - 0.5) * 40).round();
    int finalScore = baseScore + adjustment;

    // スコアを10点単位に丸める
    finalScore = (finalScore / 10).round() * 10;

    // スコアを10-990の範囲に制限
    return finalScore.clamp(10, 990);
  }

  // スコアに基づくレベル評価
  static String getScoreEvaluation(int score) {
    if (score < 300) return '初級';
    if (score < 500) return '中級';
    if (score < 650) return '中上級';
    if (score < 800) return '上級';
    return '最上級';
  }

  // スコアに基づくコメント
  static String getScoreComment(int score) {
    if (score < 300) {
      return '基礎から着実に学習を進めましょう！';
    } else if (score < 500) {
      return '基本的な英語力が身についています。さらなる向上を目指しましょう！';
    } else if (score < 650) {
      return '実用的な英語力があります。より高度な表現を学びましょう！';
    } else if (score < 800) {
      return '優れた英語力です。ビジネスでも活用できるレベルです！';
    } else {
      return '素晴らしい！非常に高い英語力をお持ちです！';
    }
  }
}
