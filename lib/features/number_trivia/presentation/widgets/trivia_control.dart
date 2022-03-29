import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resocoder_tdd_clean_arch/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class TriviaControl extends StatefulWidget {
  const TriviaControl({Key? key}) : super(key: key);

  @override
  State<TriviaControl> createState() => _TriviaControlState();
}

class _TriviaControlState extends State<TriviaControl> {
  final controller = TextEditingController();
  //Controller para limpar o TextField
  String inputString = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          onChanged: (value) {
            inputString = value;
          },
          onFieldSubmitted: (_) {
            //Quando o usuário aperta submit no próprio teclado do device
            callConcreteNumberEvent();
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
            hintText: 'Input a number',
          ),
          keyboardType: TextInputType.number,
          controller: controller,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                child: const Text('Search'),
                onPressed: () => callConcreteNumberEvent(),
                //Sempre passo o EVENTO pois é a interação do usuário
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                child: const Text('Get random trivia'),
                onPressed: () => callRandomNumberEvent(),
              ),
            ),
          ],
        )
      ],
    );
  }

  void callConcreteNumberEvent() {
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetTriviaForConcreteNumber(inputString));
  }

  void callRandomNumberEvent() {
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandomNumber());
  }
}
