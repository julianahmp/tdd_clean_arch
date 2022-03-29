import 'package:resocoder_tdd_clean_arch/features/number_trivia/domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  const NumberTriviaModel({required String text, required int number})
      : super(text: text, number: number);

  //?Eu extendo a entity mas pq precisa do super construtor?

  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) {
    return NumberTriviaModel(
      text: json['text'], 
      number: (json['number'] as num).toInt(),
      );
  }
  //?O que é factory? Pq nao pode ser feito com o JsonToDart?

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'number': number,
    };
  }
}
