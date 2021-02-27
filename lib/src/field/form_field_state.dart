import 'package:equatable/equatable.dart';

abstract class FieldFormState<T> extends Equatable {
  final T value;

  FieldFormState(this.value);

  @override
  List<Object> get props => [value];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FieldFormState<T> &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}

class FormFieldNotValid<T> extends FieldFormState<T> {
  FormFieldNotValid(T value) : super(value);
}

class FormFieldEmpty<T> extends FieldFormState<T> {
  FormFieldEmpty(T value) : super(value);
}

class FormFieldValidating<T> extends FieldFormState<T> {
  FormFieldValidating(T value) : super(value);
}

class FormFieldValidationFailed<T> extends FieldFormState<T> {
  final Exception exception;

  FormFieldValidationFailed(T value, this.exception) : super(value);
}

class FormFieldValid<T> extends FieldFormState<T> {
  final String fieldKey;
  final Map<String, dynamic> valueMap;

  Map<String, dynamic> keyValueMap() => {fieldKey: valueMap ?? value};

  FormFieldValid(T value, this.fieldKey, {this.valueMap}) : super(value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FormFieldValid<T> &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          fieldKey == other.fieldKey;

  @override
  int get hashCode => value.hashCode;

  @override
  List<Object> get props => [value, fieldKey];
}
