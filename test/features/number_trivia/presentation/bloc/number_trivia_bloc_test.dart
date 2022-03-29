import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:resocoder_tdd_clean_arch/core/error/failures.dart';
import 'package:resocoder_tdd_clean_arch/core/usecases/usecases.dart';
import 'package:resocoder_tdd_clean_arch/core/utils/constants.dart';
import 'package:resocoder_tdd_clean_arch/core/utils/input_converter.dart';
import 'package:resocoder_tdd_clean_arch/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:resocoder_tdd_clean_arch/features/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';
import 'package:resocoder_tdd_clean_arch/features/number_trivia/domain/use_cases/get_random_number_trivia.dart';
import 'package:resocoder_tdd_clean_arch/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUpAll(() {
    registerFallbackValue(const Params(number: 0));
    registerFallbackValue(NoParams());
    //Não posso utilizar uma Classe sem mockar ou registrar no Mocktail.
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
        getRandomNumberTrivia: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  test('initial state should be empty', () {
    expect(bloc.state, Empty());
    //Teste do estado inicial do Bloc
  });

  group('getTriviaForConcreteNumber', () {
    const tNumberString = '1';
    const tNumberParsed = 1;
    const tNumberTrivia =
        NumberTrivia(text: 'Teste do Number Trivia App', number: 1);

    //Custom Methods (para não repetir o código)
    void setUpMockInputConverterSuccess() =>
        when(() => mockInputConverter.stringToUnsignedInteger(any()))
            .thenReturn(Right(tNumberParsed));

    void setUpMockGetConcreteNumberTriviaSuccess() =>
        when(() => mockGetConcreteNumberTrivia(any()))
            .thenAnswer((_) async => const Right(tNumberTrivia));

    test(
        'should call the input converter to validate and convert the string to an unsigned integer',
        () async {
      //arrange
      setUpMockInputConverterSuccess();
      //act
      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(
          () => mockInputConverter.stringToUnsignedInteger(any()));
      //assert
      verify(() => mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    test('should emit [Error] when the input is invalid', () async {
      //arrange
      when(() => mockInputConverter.stringToUnsignedInteger(any()))
          .thenReturn(Left(InvalidInputFailure()));
      //assert Later
      final expected = [
        Empty(),
        const Error(errorMessage: INVALID_INPUT_FAILURE_MESSAGE),
      ];
      expectLater(bloc.state, emitsInOrder(expected));

      //act
      bloc.add(const GetTriviaForConcreteNumber(tNumberString));

      //!TESTE QUE NÃO PASSA
    });

    test('should get data from the concrete use case', () async {
      setUpMockInputConverterSuccess();
      setUpMockGetConcreteNumberTriviaSuccess();

      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(() => mockGetConcreteNumberTrivia(any()));

      verify(() =>
          mockGetConcreteNumberTrivia(const Params(number: tNumberParsed)));
    });

    test('should emite [Loading, Loaded] when data is gotten successfully',
        () async {
      //arrange
      setUpMockInputConverterSuccess();
      setUpMockGetConcreteNumberTriviaSuccess();

      //assertLater
      final expected = [
        Empty(),
        Loading(),
        Loaded(trivia: tNumberTrivia),
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      //act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      //!TESTE NÃO PASSA
    });

    test('should emite [Loading, Error] when data is fails', () async {
      //arrange
      setUpMockInputConverterSuccess();
      when(() => mockGetConcreteNumberTrivia(any()))
          .thenAnswer((_) async => Left(ServerFailure()));

      //assertLater
      final expected = [
        Empty(),
        Loading(),
        Error(errorMessage: SERVER_FAILURE_MESSAGE),
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      //act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      //!TESTE NÃO PASSA
    });

    test(
        'should emite [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      //arrange
      setUpMockInputConverterSuccess();
      when(() => mockGetConcreteNumberTrivia(any()))
          .thenAnswer((_) async => Left(CacheFailure()));

      //assertLater
      final expected = [
        Empty(),
        Loading(),
        Error(errorMessage: CACHE_FAILURE_MESSAGE),
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      //act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      //!TESTE NÃO PASSA
    });
  });

  group('getTriviaForRandomNumber', () {
    const tNumberTrivia =
        NumberTrivia(text: 'Teste do Number Trivia App', number: 1);

    test('should get data from the random useCase', () async {
      //arrange
      when(() => mockGetRandomNumberTrivia(any()))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      //act
      bloc.add(GetTriviaForRandomNumber());
      await untilCalled(() => mockGetRandomNumberTrivia(any()));
      //assert
      verify(() => mockGetRandomNumberTrivia(NoParams()));
    });

    test('should emite [Loading, Loaded] when data is gotten successfully',
        () async {
      //arrange
      when(() => mockGetRandomNumberTrivia(any()))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      //assertLater
      final expected = [
        Empty(),
        Loading(),
        Loaded(trivia: tNumberTrivia),
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      //act
      bloc.add(GetTriviaForRandomNumber());
      //!TESTE NÃO PASSA
    });

    test('should emite [Loading, Error] when data is fails', () async {
      //arrange
      when(() => mockGetRandomNumberTrivia(any()))
          .thenAnswer((_) async => Left(ServerFailure()));
      //assertLater
      final expected = [
        Empty(),
        Loading(),
        Error(errorMessage: SERVER_FAILURE_MESSAGE),
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      //act
      bloc.add(GetTriviaForRandomNumber());
      //!TESTE NÃO PASSA
    });

        test(
        'should emite [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      //arrange
      when(() => mockGetRandomNumberTrivia(any()))
          .thenAnswer((_) async => Left(CacheFailure()));
      //assertLater
      final expected = [
        Empty(),
        Loading(),
        Error(errorMessage: CACHE_FAILURE_MESSAGE),
      ];
      expectLater(bloc.state, emitsInOrder(expected));
      //act
      bloc.add(GetTriviaForRandomNumber());
      //!TESTE NÃO PASSA
    });
  });
}
