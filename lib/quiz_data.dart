// quiz_data.dart

import 'quiz.dart'; // quiz.dart で定義した Quiz クラスをインポート

// アプリ全体で利用する問題のリスト。外部からアクセスできるよう 'final' とします。
// const を使用することで、コンパイル時に値が決定されメモリ効率が良くなります。
const List<Quiz> quizData = [
  // --- 第1問 ---
  Quiz(
    question: 'FlutterでUIを構築する部品は何と呼ばれますか？',
    correctAnswer: 'ウィジェット (Widget)',
    incorrectAnswers: ['コンポーネント (Component)', 'エレメント (Element)', 'ノード (Node)'],
    explanation: 'FlutterのUIはすべてウィジェットで構成されます。画面全体から小さなテキストまで、すべてウィジェットです。',
  ),

  // --- 第2問 ---
  Quiz(
    question: 'Flutterで状態を持たないウィジェットは何と呼ばれますか？',
    correctAnswer: 'StatelessWidget',
    incorrectAnswers: ['StatefulWidget', 'ConsumerWidget', 'HookWidget'],
    explanation: '状態を持たない時に使うウィジェットがStatelessWidgetです。',
  ),

  // --- 第3問 ---
  Quiz(
    question: 'StatefulWidgetで、状態の変更を画面に反映させるために使う関数はなんですか？',
    correctAnswer: 'setState',
    incorrectAnswers: ['useEffect', 'ref', 'provider',],
    explanation:
        'StatefulWidgetではsetStateを使うことで状態の変更を画面に反映させることができます。',
  ),
];
