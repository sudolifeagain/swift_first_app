import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/adaptive_test_service.dart';
import '../services/score_calculator.dart';

class AdaptiveResultPage extends StatelessWidget {
  final AdaptiveTestService testService;

  const AdaptiveResultPage({super.key, required this.testService});

  @override
  Widget build(BuildContext context) {
    // スコア計算
    final toeicScore = ScoreCalculator.calculateTOEICScore(
      answerHistory: testService.answerHistory,
      levelQuestionCount: testService.levelQuestionCount,
    );

    final evaluation = ScoreCalculator.getScoreEvaluation(toeicScore);
    final comment = ScoreCalculator.getScoreComment(toeicScore);

    // 統計情報
    final totalQuestions = testService.questionsAnswered;
    final correctAnswers = testService.answerHistory.where((a) => a).length;
    final accuracy = (correctAnswers / totalQuestions * 100).round();
    final categoryAccuracy = testService.getCategoryAccuracy();

    return Scaffold(
      appBar: AppBar(
        title: const Text('テスト結果'),
        backgroundColor: Colors.deepPurple,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // TOEICスコア表示
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.deepPurple.shade400, Colors.deepPurple.shade700],
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'あなたのTOEICスコア',
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '$toeicScore',
                      style: GoogleFonts.oswald(
                        fontSize: 72,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      evaluation,
                      style: GoogleFonts.roboto(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // コメント
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Icon(Icons.emoji_events, size: 40, color: Colors.amber.shade700),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        comment,
                        style: const TextStyle(fontSize: 16, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 統計情報
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '詳細統計',
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(height: 24),
                    _buildStatRow('総問題数', '$totalQuestions 問'),
                    _buildStatRow('正解数', '$correctAnswers 問'),
                    _buildStatRow('正答率', '$accuracy%'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // カテゴリ別正答率
            if (categoryAccuracy.isNotEmpty)
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'カテゴリ別正答率',
                        style: GoogleFonts.roboto(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(height: 24),
                      ...categoryAccuracy.entries.map((entry) {
                        final percentage = (entry.value * 100).round();
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(entry.key, style: const TextStyle(fontSize: 16)),
                                  Text('$percentage%', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              LinearProgressIndicator(
                                value: entry.value,
                                backgroundColor: Colors.grey[300],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  _getColorForAccuracy(entry.value),
                                ),
                                minHeight: 8,
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 32),

            // ホームに戻るボタン
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              icon: const Icon(Icons.home),
              label: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Text('ホームに戻る', style: TextStyle(fontSize: 18)),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Color _getColorForAccuracy(double accuracy) {
    if (accuracy >= 0.8) return Colors.green;
    if (accuracy >= 0.6) return Colors.blue;
    if (accuracy >= 0.4) return Colors.orange;
    return Colors.red;
  }
}
