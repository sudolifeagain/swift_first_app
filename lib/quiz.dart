// quiz.dart

class Quiz {
  // 必須項目
  final String question; // 問題文
  final String correctAnswer; // 正解の選択肢

  // 不正解の選択肢はリストにまとめ、正解と合わせてシャッフルして表示するのが一般的です
  final List<String> incorrectAnswers;

  final String explanation; // 解説

  // コンストラクタ：全ての値を必須とする（requiredを使用）
  const Quiz({
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
    required this.explanation,
  });

  // 便利なGetter：すべての選択肢を一つのリストにして返す
  List<String> get allAnswers {
    // 正解と不正解のリストを結合
    final List<String> answers = [correctAnswer, ...incorrectAnswers];
    // .shuffle() は元のリストを変更するので、新しいリストを作成してシャッフルするのが安全
    answers.shuffle();
    return answers;
  }
}
