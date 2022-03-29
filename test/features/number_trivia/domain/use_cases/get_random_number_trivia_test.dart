import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:resocoder_tdd_clean_arch/core/usecases/usecases.dart';
import 'package:resocoder_tdd_clean_arch/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:resocoder_tdd_clean_arch/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:resocoder_tdd_clean_arch/features/number_trivia/domain/use_cases/get_random_number_trivia.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  late GetRandomNumberTrivia usecase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;

  setUpAll(() {
    registerFallbackValue(NoParams());
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(repository: mockNumberTriviaRepository);
  });

  const tNumberTrivia = NumberTrivia(number: 1, text: 'test');

  test(
    'should get trivia from the repository',
    () async {
      // arrange
      when(() => mockNumberTriviaRepository.getRandomNumberTrivia())
          .thenAnswer((_) async => const Right(tNumberTrivia));
      // act
      final result = await usecase(NoParams());
      // assert
      expect(result, const Right(tNumberTrivia));
      verify(() => mockNumberTriviaRepository.getRandomNumberTrivia());
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}
