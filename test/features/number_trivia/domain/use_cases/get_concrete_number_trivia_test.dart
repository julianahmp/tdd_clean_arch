import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:resocoder_tdd_clean_arch/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:resocoder_tdd_clean_arch/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:resocoder_tdd_clean_arch/features/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  late GetConcreteNumberTrivia usecase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;

  setUpAll(() {
    registerFallbackValue(const Params(number: 0));
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(repository: mockNumberTriviaRepository);
  });

  const tNumber = 1;
  const tNumberTrivia = NumberTrivia(number: 1, text: 'test');

  test(
    'should get trivia for the number from the repository',
    () async {
      //arrange
      when(() => mockNumberTriviaRepository.getConcreteNumberTrivia(any()))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      //act
      final result = await usecase(const Params(number: tNumber));
      //Quando o método é o call do UseCase nós não precisamos chamá-lo diretamente.
      //assert
      expect(result, const Right(tNumberTrivia));
      //Verifico a chamada do método
      verify(() => mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
      //Verifico que nada além daquele método vai ser chamado no repository
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}
