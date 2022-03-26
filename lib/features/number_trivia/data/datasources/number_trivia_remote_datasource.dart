import 'dart:convert';

import 'package:resocoder_tdd_clean_arch/core/error/exceptions.dart';
import 'package:resocoder_tdd_clean_arch/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:http/http.dart' as http;

//Primeiro eu crio o contrato para o DataSource.
abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

//Depois eu crio a implementação deste contrato, onde vai acontecer a chamdada da API.
class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl(this.client);

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
    return await _getNumberTriviaUrl('http://numbersapi.com/$number');
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    return await _getNumberTriviaUrl('http://numbersapi.com/random');
  }

  //Método genérico para as duas chamadas da API.
  Future<NumberTriviaModel> _getNumberTriviaUrl(String url) async {
    final response = await client.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerExceptions();
    }
  }
}
