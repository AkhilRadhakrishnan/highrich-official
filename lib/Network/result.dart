
class Result<T> {

  Result._();

  factory Result.unAuthored(T value) = UnAuthoredState<T>;

  factory Result.success(T value) = SuccessState<T>;

  factory Result.error(T msg) = ErrorState<T>;
}

class UnAuthoredState<T> extends Result<T> {
  UnAuthoredState(this.value) : super._();
  final T value;
}

class ErrorState<T> extends Result<T> {
  ErrorState(this.msg) : super._();
  final T msg;
}

class SuccessState<T> extends Result<T> {
  SuccessState(this.value) : super._();
  final T value;
}