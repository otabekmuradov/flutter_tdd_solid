import 'package:flutter/material.dart';
import 'package:proj_with_reso/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'package:proj_with_reso/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
            foregroundColor: Colors.green.shade900,
            color: Colors.green.shade100,
            elevation: 0),
      ),
      home: const NumberTriviaPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
