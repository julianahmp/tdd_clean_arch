import 'package:dartz/dartz.dart';
import 'package:resocoder_tdd_clean_arch/core/error/exceptions.dart';

import 'package:resocoder_tdd_clean_arch/core/error/failures.dart';
import 'package:resocoder_tdd_clean_arch/core/network/network_info.dart';
import 'package:resocoder_tdd_clean_arch/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:resocoder_tdd_clean_arch/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:resocoder_tdd_clean_arch/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:resocoder_tdd_clean_arch/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  //O Repository do Data sempre vai implementar o Repository da Domain.
  //É nesse repository que a gente cria a lógica que recebe a chamada da api do DataSource e faz as tratativas de erro.
  final NetworkInfo networkInfo;
  final NumberTriviaLocalDataSource localDataSource;
  final NumberTriviaRemoteDataSource remoteDataSource;
  NumberTriviaRepositoryImpl({
    required this.networkInfo,
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
    int number,
  ) async {
    return await _getTrivia(() => getConcreteNumberTrivia(number));
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() => getRandomNumberTrivia());
  }

  //HighOrderFunction - uma função que eu posso chamar no paramêtro de um método para evitar duplicação de código.
  Future<Either<Failure, NumberTrivia>> _getTrivia(
  /*Future<NumberTrivia> pq a função retorna isso mas...vou tentar não passar essa tipagem*/
  Function() getConcreteOrRandom) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteRandomNumberTrivia = await getConcreteOrRandom();
        localDataSource.getCacheNumberTrivia(remoteRandomNumberTrivia);
        //Chamo a função que vai armanezar o remoteNumberTrivia no Local Cache.
        return Right(remoteRandomNumberTrivia);
      } on ServerExceptions {
        return Left(ServerFailure());
      }
    } else {
      return Right(await localDataSource.getLastNumberTrivia());
    }
  }
}
