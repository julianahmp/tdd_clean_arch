import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:resocoder_tdd_clean_arch/core/utils/input_converter.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt', () {
    test(
        'should return an integer when the string represents an unsigned integer',
        () async {
      //arrange
      const str = '123';
      //act
      final result = inputConverter.stringToUnsignedInteger(str);
      //assert
      expect(result, equals(const Right(123)));
    });

    test('should return a failure when the string is not an integer', () async {
      //arrange
      const str = 'abc';
      //act
      final result = inputConverter.stringToUnsignedInteger(str);
      //assert
      expect(result, const Left(InvalidInputFailure));
    });

    test('should return a failure when the string is a negative integer',
        () async {
      //arrange
      const str = '-123';
      //act
      final result = inputConverter.stringToUnsignedInteger(str);
      //assert
      expect(result, equals(const Left(InvalidInputFailure)));
    });
  });
}
