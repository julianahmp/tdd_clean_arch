import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:resocoder_tdd_clean_arch/core/error/failures.dart';
import 'package:resocoder_tdd_clean_arch/core/usecases/usecases.dart';
import 'package:resocoder_tdd_clean_arch/core/utils/constants.dart';
import 'package:resocoder_tdd_clean_arch/core/utils/input_converter.dart';
import 'package:resocoder_tdd_clean_arch/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:resocoder_tdd_clean_arch/features/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';
import 'package:resocoder_tdd_clean_arch/features/number_trivia/domain/use_cases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc(
      {required this.getConcreteNumberTrivia,
      required this.getRandomNumberTrivia,
      required this.inputConverter})
      : super(Empty()) {

    on<GetTriviaForConcreteNumber>((event, emit) async {
      return await getConcreteNumberTriviaEvent(event, emit);
    });

    on<GetTriviaForRandomNumber>((event, emit) async {
      return await getRandomNumberTriviaEvent(emit);
    });
  }



  getConcreteNumberTriviaEvent(GetTriviaForConcreteNumber event, Emitter<NumberTriviaState> emit) async {
    final inputEither = inputConverter.stringToUnsignedInteger(event.numberString);
    //O inputEither acessa o método que tem o Either<Failure, int> e com o fold do dartZ
    //acessamos esses dois lados e passamos o que queremos como resultado.
    return inputEither.fold(
      //!Sem return não funciona
      (failure) => const Error(errorMessage: INVALID_INPUT_FAILURE_MESSAGE),
      (integer) async {
      emit(Loading());
      final failureOrTrivia = await getConcreteNumberTrivia(Params(number: integer));
      failureOrTrivia.fold(
          (failure) => emit(Error(errorMessage: _mapFailureToMesssage(failure))),
          (successNumberTrivia) => emit(Loaded(trivia: successNumberTrivia)));
    });
  }

  getRandomNumberTriviaEvent(Emitter<NumberTriviaState> emit) async {
    emit(Loading());
    //Sempre que for emitir um estado utilizar o emit.
    final failureOrTrivia = await getRandomNumberTrivia(NoParams());
    return failureOrTrivia.fold(
      (failure) => emit(Error(errorMessage: _mapFailureToMesssage(failure))),
      (successNumberTrivia) => emit(Loaded(trivia: successNumberTrivia)));
  }

    String _mapFailureToMesssage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      //Quando o Failure não é nenhum dos estipulados:
      default:
        return 'Unexpected Error';
    }
  }
}

    //   on<NumberTriviaEvent>((event, emit) async {
    //   if (event is GetTriviaForConcreteNumber) {
    //     final inputEither =
    //         inputConverter.stringToUnsignedInteger(event.numberString);
    //     inputEither.fold(
    //         (failure) =>
    //             const Error(errorMessage: INVALID_INPUT_FAILURE_MESSAGE),
    //         (integer) async {
    //       Loading();
    //       final failureOrTrivia =
    //           await getConcreteNumberTrivia(Params(number: integer));
    //       failureOrTrivia.fold(
    //           (failure) => Error(errorMessage: _mapFailureToMesssage(failure)),
    //           (trivia) => Loaded(trivia: trivia));
    //     });
    //   } else if (event is GetTriviaForRandomNumber) {
    //     Loading();
    //     final failureOrTrivia = await getRandomNumberTrivia(NoParams());
    //     failureOrTrivia.fold(
    //         (failure) => Error(errorMessage: _mapFailureToMesssage(failure)),
    //         (trivia) => Loaded(trivia: trivia));
    //   }
    // });