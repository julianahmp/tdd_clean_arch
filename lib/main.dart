import 'package:flutter/material.dart';
import 'package:resocoder_tdd_clean_arch/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //?
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const NumberTriviaPage(),
    );
  }
}
