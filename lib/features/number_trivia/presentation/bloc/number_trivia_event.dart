part of 'number_trivia_bloc.dart';

abstract class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();

  @override
  List<Object> get props => [];
}

//Crio as classes que são relacionadas aos meus eventos, nesse caso, tenho dois botões e um text input (relacionado ao botão), por isso crio duas classes que vão emitir esses eventos.
class GetTriviaForConcreteNumber extends NumberTriviaEvent {
  final String numberString;
  //Recebe o input pois o usuário digita o número que quer.

  const GetTriviaForConcreteNumber(this.numberString);
}

class GetTriviaForRandomNumber extends NumberTriviaEvent {
  //Esse não recebe nenhum paramêtro pois é um número gerado randomicamente.
}
