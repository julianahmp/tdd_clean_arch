import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resocoder_tdd_clean_arch/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:resocoder_tdd_clean_arch/features/number_trivia/presentation/widgets/loading_widget.dart';
import 'package:resocoder_tdd_clean_arch/features/number_trivia/presentation/widgets/message_display.dart';
import 'package:resocoder_tdd_clean_arch/features/number_trivia/presentation/widgets/trivia_control.dart';
import 'package:resocoder_tdd_clean_arch/features/number_trivia/presentation/widgets/trivia_display.dart';
import 'package:resocoder_tdd_clean_arch/injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
      ),
      body: SingleChildScrollView(
        child: buildBody(context),
      ),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl.get<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  if (state is Empty) {
                    return const MessageDisplay(
                      message: 'Start Searching!',
                    );
                  } else if (state is Loading) {
                    return const LoadingWidget();
                  } else if (state is Loaded) {
                    return TriviaDisplay(numberTrivia: state.trivia);
                  } else if (state is Error) {
                    return MessageDisplay(
                      message: state.errorMessage,
                    );
                  }
                  return Container();
                },
              ),
              const SizedBox(height: 20),
              const TriviaControl(),
            ],
          ),
        ),
      ),
    );
  }
}
