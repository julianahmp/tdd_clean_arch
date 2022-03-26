import 'package:equatable/equatable.dart';

class NumberTrivia extends Equatable {
  //Será extendido no Model
  final String text;
  final int number;

  const NumberTrivia({
    required this.text,
    required this.number})
      : super();

  @override
  // ignore: todo
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
