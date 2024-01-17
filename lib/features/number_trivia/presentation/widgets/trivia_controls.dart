import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc/number_trivia_bloc.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    super.key,
  });

  @override
  State<TriviaControls> createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // TextField
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromARGB(255, 218, 255, 220))),
            hintText: 'Input a number',
          ),
          onSubmitted: (_) {
            addConcrete();
          },
        ),
        const SizedBox(height: 20.0),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: addConcrete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text(
                  'Search',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: ElevatedButton(
                onPressed: addRandom,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                ),
                child: const Text(
                  'Get random trivia',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void addConcrete() {
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetTriviaForConcreteNumber(controller.text));
    controller.clear();
  }

  void addRandom() {
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandomNumber());
    controller.clear();
  }
}
