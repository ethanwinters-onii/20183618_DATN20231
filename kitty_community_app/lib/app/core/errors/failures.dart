abstract class Failure {
  final String message;

  const Failure({required this.message});

  @override
  List<Object?> get props => [];
}

class SystemFailure extends Failure {
  const SystemFailure({required String message}) : super(message: message);
}

class NoInternetConnection extends Failure {
  const NoInternetConnection({required String message})
      : super(message: message);
}

class NoDataFound extends Failure {
  const NoDataFound({required String message}) : super(message: message);
}

class DataConsistencyError extends Failure {
  const DataConsistencyError({required String message})
      : super(message: message);
}

class NoCacheData extends Failure {
  const NoCacheData({required String message}) : super(message: message);
}

//Error when excute server function
class NoPermission extends Failure {
  const NoPermission({required String message}) : super(message: message);
}

// To remove
class AuthFailure extends Failure {
  final String? code;
  const AuthFailure({this.code, required String message})
      : super(message: message);

  @override
  List<Object?> get props => [code];
}

class ServerFailureWithMessage extends Failure {
  const ServerFailureWithMessage({required String message})
      : super(message: message);
}