class EnglishQuestion {
  final String id;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final int difficultyLevel; // 1-5 (1=初級, 5=最上級)
  final String category; // 語彙、文法、読解
  final String explanation;

  const EnglishQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.difficultyLevel,
    required this.category,
    required this.explanation,
  });

  // すべての選択肢をシャッフルして返す
  List<String> get shuffledOptions {
    final List<String> shuffled = [...options];
    shuffled.shuffle();
    return shuffled;
  }
}
