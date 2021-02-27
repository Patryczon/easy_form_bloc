import 'package:bloc/bloc.dart';
import 'form_field_event.dart';
import 'form_field_state.dart';

class FormFieldBloc<T> extends Bloc<FormFieldEvent, FieldFormState<T>> {
  bool Function(T value) validator;
  Future<bool> Function(T value) futureValidator;
  final T defaultValue;
  final String valueKey;
  final bool isRequired;
  final Map<String, dynamic> Function(T) transformValueToMap;

  FormFieldBloc(
      {this.defaultValue,
      this.valueKey,
      this.validator,
      this.futureValidator,
      this.isRequired = true,
      this.transformValueToMap})
      : assert(!(futureValidator == null && validator == null) &&
            isRequired != null),
        super(isRequired
            ? FormFieldEmpty<T>(defaultValue)
            : FormFieldValid<T>(defaultValue, valueKey,
                valueMap: transformValueToMap == null
                    ? null
                    : transformValueToMap(defaultValue)));

  @override
  Stream<FieldFormState<T>> mapEventToState(FormFieldEvent event) async* {
    if (event is ClearField)
      yield FormFieldEmpty<T>(defaultValue);
    else if (event is FieldValueChanged<T>) {
      yield FormFieldValidating<T>(event.value);
      yield await _fieldChanged(event.value);
    }
  }

  Future<FieldFormState<T>> _fieldChanged(T value) async {
    if (value == defaultValue)
      return FormFieldEmpty<T>(defaultValue);
    else {
      if (validator == null) {
        return _validateFieldAsync(value);
      } else {
        return Future.value(_validateWithFunction(value));
      }
    }
  }

  FieldFormState<T> _validateWithFunction(value) {
    try {
      return validator(value)
          ? FormFieldValid<T>(
              value,
              valueKey,
              valueMap: transformValueToMap == null
                  ? null
                  : transformValueToMap(value),
            )
          : FormFieldNotValid<T>(value);
    } catch (exception) {
      return FormFieldValidationFailed<T>(value, exception);
    }
  }

  Future<FieldFormState<T>> _validateFieldAsync(value) async {
    return futureValidator(value)
        .then((isValid) => isValid
            ? FormFieldValid<T>(
                transformValueToMap == null
                    ? value
                    : transformValueToMap(value),
                valueKey)
            : FormFieldNotValid<T>(value))
        .catchError(
            (exception) => FormFieldValidationFailed<T>(value, exception));
  }
}
