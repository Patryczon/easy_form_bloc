import 'package:equatable/equatable.dart';

abstract class FormFieldEvent extends Equatable {}

class FieldValueChanged<T> extends FormFieldEvent {
  final T value;

  FieldValueChanged(this.value);

  @override
  List<Object> get props => [value];
}

class ClearField extends FormFieldEvent {
  @override
  List<Object> get props => [];
}
