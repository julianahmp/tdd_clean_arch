import 'dart:convert';

import 'package:resocoder_tdd_clean_arch/core/error/exceptions.dart';
import 'package:resocoder_tdd_clean_arch/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NumberTriviaLocalDataSource {
  //Métodos para pegar os dados armanezados.
  Future<NumberTriviaModel> getLastNumberTrivia();
  //Pega apenas o último número armazenado.
  Future<void> getCacheNumberTrivia(NumberTriviaModel triviaToCache);
  //Ele é um future void pq não retorna nada, mas recebe como paramêtro o triviaToCache para quando a função for chamada.
}

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  //Adiciono o SharedPreferences que vai fazer o armazenamento local
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString = sharedPreferences.getString('last_number_trivia');
    if (jsonString != null) {
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
      //Recupero o Json e transformo em String
      //Quando eu não tenho um valor que é um Future eu passo o Future.value para ele converter para um Future.
    } else {
      throw CacheExceptions();
    }
  }

  @override
  Future<void> getCacheNumberTrivia(NumberTriviaModel triviaToCache) {
    return sharedPreferences.setString(
        'last_number_trivia', json.encode(triviaToCache.toJson()));
    //Armanezo a String em formato Json (c/ o encode)
    //Não preciso de um if aqui pq se ele for null não tem problema, pois só significa que não vai armanezar nada.
  }
}
