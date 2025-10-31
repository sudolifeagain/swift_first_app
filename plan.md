# 英語学習レベル把握アプリ 実装計画

## プロジェクト概要
ユーザーの英語力をTOEICスコア換算で測定するアダプティブテストアプリケーション。
問題の難易度は回答の正確性に応じて動的に調整され、個々のユーザーに最適化された評価を提供します。

## 主要機能

### 1. アダプティブアルゴリズム
- 初期難易度: TOEIC 400-500レベル（中級）
- 正解時: 難易度を1段階上げる
- 不正解時: 難易度を1段階下げる
- 難易度レベル: 5段階（初級、中級、中上級、上級、最上級）

### 2. 問題データ構造
```dart
class EnglishQuestion {
  final String id;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final int difficultyLevel; // 1-5
  final String category; // 語彙、文法、読解
  final String explanation;
}
```

### 3. スコア計算アルゴリズム
- 基準スコア: 難易度レベルに基づく基礎点
  - レベル1: 300-400点
  - レベル2: 400-500点
  - レベル3: 500-650点
  - レベル4: 650-800点
  - レベル5: 800-990点
- 正答率による調整: 各レベル内での正答率に応じて微調整
- 最終スコア = 基準スコア + (正答率 × レベル幅)

### 4. UI/UX設計
- ホーム画面: テスト開始ボタン、過去のスコア履歴（将来実装）
- 問題画面: 問題文、4択オプション、進捗表示、難易度インジケーター
- 結果画面: TOEICスコア概算、レベル評価、各カテゴリ別の正答率

## 実装ステップ

### Phase 1: データモデルとロジック
1. `lib/models/english_question.dart` - 問題データモデル
2. `lib/data/question_bank.dart` - 5段階の難易度別問題データ
3. `lib/services/adaptive_test_service.dart` - アダプティブアルゴリズム
4. `lib/services/score_calculator.dart` - TOEICスコア計算ロジック

### Phase 2: UI実装
1. `lib/pages/home_page.dart` - ホーム画面（更新）
2. `lib/pages/adaptive_test_page.dart` - テスト実施画面
3. `lib/pages/adaptive_result_page.dart` - 結果表示画面
4. `lib/widgets/` - 共通ウィジェット（進捗バー、難易度表示など）

### Phase 3: テーマとスタイル
1. Material Design 3準拠のテーマ設定
2. google_fontsパッケージの導入
3. カラースキームの定義（学習アプリに適した配色）

### Phase 4: テストとデバッグ
1. アダプティブアルゴリズムのユニットテスト
2. スコア計算ロジックのユニットテスト
3. 統合テスト

## 技術スタック
- State Management: Provider
- Fonts: google_fonts
- Theme: Material Design 3
- Navigation: Navigator (基本的なプッシュ/ポップ)

## 次のステップ
1. 依存パッケージの追加（provider, google_fonts）
2. データモデルの実装
3. 問題データベースの作成
4. アダプティブテストサービスの実装
5. UI実装
