part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();

  @override
  List<Object> get props => [];
}

class Empty extends NumberTriviaState {}
//Antes: class NumberTriviaInitial extends NumberTriviaState {}
//Renomeado p/ EMPTY pois é um estado VAZIO.

class Loading extends NumberTriviaState {}
//Vai mostrar o Loading Indicator enquanto algo carrega, por exemplo.

class Loaded extends NumberTriviaState {
  //Quando está loaded vai carregar a entity (que é o modelo genérico do estado da tela).
  final NumberTrivia trivia;

  const Loaded({required this.trivia});
}

class Error extends NumberTriviaState {
  //Em caso de erro durante a mudança de estado, retorna com uma mensagem.
  final String errorMessage;

  const Error({required this.errorMessage});
}
