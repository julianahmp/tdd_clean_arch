import 'package:dartz/dartz.dart';
import 'package:resocoder_tdd_clean_arch/core/error/failures.dart';
import '../entities/number_trivia.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number);
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
  //No repository da Domain criamos apenas o contrato.
}
