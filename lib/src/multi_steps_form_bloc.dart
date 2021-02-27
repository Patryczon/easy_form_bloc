import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'field/form_field_state.dart';
import 'form/form_bloc.dart';
import 'form/form_event.dart';
import 'step/form_step_bloc.dart';
import 'step/form_step_state.dart';

class MultiStepsFormBloc extends FormBloc {
  final List<FormStepBloc> formSteps;

  MultiStepsFormBloc(
      {@required this.formSteps,
      Future Function(Map<String, dynamic>) submitFuture,
      Function(Map<String, dynamic>) submitFunction})
      : super(submitFunction: submitFunction, submitFuture: submitFuture);

  @override
  void listenIsFormEnabled() {
    {
      MergeStream(formSteps).listen((event) {
        if (formSteps.any((element) => element.state is FormStepNotValid))
          add(DisableForm());
        else
          add(EnableForm());
      });
    }
  }

  @override
  Map<String, dynamic> getFormData() {
    Map<String, dynamic> valueMap = {};
    formSteps
        .where((element) => element.state is FormStepSubmitted)
        .expand((states) => states.fieldsBlocs)
        .where((element) => element.state is FormFieldValid)
        .forEach((element) {
      valueMap.addAll((element.state as FormFieldValid).keyValueMap());
    });
    return valueMap;
  }
}
