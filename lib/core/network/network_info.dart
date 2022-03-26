import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}
//Toda classe que eu criar um método, deve, de prefência ser abstrata para que eu possa implementá-la em seguida.

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;

  NetworkInfoImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
  //Aqui eu to passando o hasConnection como true pq é default.

  //Outra forma de fazer, mas aqui eu to falando que o hasConnection é de fato, true, sendo que eu poderia passar como falso.
  // @override
  // Future<bool> get isConnected {
  //   connectionChecker.hasConnection;
  //   return Future.value(true);
  // }
}
