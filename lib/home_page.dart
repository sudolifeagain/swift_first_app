// home_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/adaptive_test_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '英語レベル診断',
          style: GoogleFonts.oswald(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple.shade50, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // アイコン
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.school,
                      size: 80,
                      color: Colors.deepPurple.shade700,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // タイトル
                  Text(
                    'あなたの英語力を\n測定しましょう',
                    style: GoogleFonts.notoSans(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple.shade900,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  // 説明
                  Text(
                    'AIが最適な難易度の問題を出題\nTOEICスコアで結果を表示',
                    style: GoogleFonts.notoSans(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 48),

                  // 機能カード
                  _buildFeatureCard(
                    icon: Icons.auto_graph,
                    title: 'アダプティブテスト',
                    description: '回答に応じて難易度が自動調整',
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureCard(
                    icon: Icons.analytics,
                    title: 'TOEICスコア換算',
                    description: '正確なレベル診断で実力を把握',
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureCard(
                    icon: Icons.category,
                    title: 'カテゴリ別分析',
                    description: '文法・語彙・読解の強み・弱みを確認',
                  ),

                  const SizedBox(height: 48),

                  // テスト開始ボタン
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdaptiveTestPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.play_arrow, size: 28),
                    label: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      child: Text(
                        'テストを始める',
                        style: GoogleFonts.roboto(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 8,
                      shadowColor: Colors.deepPurple.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 32, color: Colors.deepPurple.shade700),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

