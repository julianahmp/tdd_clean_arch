import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:resocoder_tdd_clean_arch/core/error/failures.dart';
import 'package:resocoder_tdd_clean_arch/core/usecases/usecases.dart';

import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia, Params> {
  //O UseCase deve implementar um UseCase genérico com a função call.
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia({required this.repository});

  @override
  Future<Either<Failure, NumberTrivia>> call(params) async {
    return await repository.getConcreteNumberTrivia(params.number);
    //Chama o repository da Domain para passar o método.
  }
}

class Params extends Equatable {
  final int number;
  const Params({required this.number});

  @override
  List<Object?> get props => [number];
}
