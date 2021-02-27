import 'package:flutter/cupertino.dart';
import 'field/form_field_bloc.dart';
import 'field/form_field_state.dart';
import 'form/form_bloc.dart';
import 'form/form_event.dart';

class SingleStepFormBloc extends FormBloc {
  final List<FormFieldBloc<dynamic>> fields;

  SingleStepFormBloc(
      {@required this.fields,
      Future Function(Map<String, dynamic>) submitFuture,
      Function(Map<String, dynamic>) submitFunction})
      : super(submitFunction: submitFunction, submitFuture: submitFuture);

  @override
  void listenIsFormEnabled() {
    fields.forEach((fieldBloc) {
      fieldBloc.listen((event) {
        if (fields.any((element) =>
            element.state is FormFieldNotValid ||
            element.state is FormFieldValidating ||
            (element.isRequired == true && element.state is FormFieldEmpty))) {
          add(DisableForm());
        } else {
          add(EnableForm());
        }
      });
    });
  }

  @override
  Map<String, dynamic> getFormData() {
    Map<String, dynamic> valueMap = {};
    fields
        .where(
            (element) => element.state is FormFieldValid || !element.isRequired)
        .forEach((element) {
      valueMap.addAll((element.state as FormFieldValid).keyValueMap());
    });
    return valueMap;
  }
}
