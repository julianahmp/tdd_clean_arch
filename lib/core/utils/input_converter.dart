import 'package:dartz/dartz.dart';
import 'package:resocoder_tdd_clean_arch/core/error/failures.dart';

class InputConverter {
  //Converte uma String em um int.
  Either<Failure, int> stringToUnsignedInteger(String str) {
    try {
      final integer = int.parse(str);
      if (integer < 0) {
        throw const FormatException();
      } else {
        return Right(integer);
      }
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}
