import 'package:resocoder_tdd_clean_arch/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:resocoder_tdd_clean_arch/core/usecases/usecases.dart';
import 'package:resocoder_tdd_clean_arch/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:resocoder_tdd_clean_arch/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepository repository;

  GetRandomNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(noParams) async {
    return await repository.getRandomNumberTrivia();
  }
}
