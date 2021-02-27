import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../field/form_field_bloc.dart';
import '../field/form_field_state.dart';
import 'form_step_event.dart';
import 'form_step_state.dart';

class FormStepBloc extends Bloc<FormStepEvent, FormStepState> {
  final List<FormFieldBloc<dynamic>> fieldsBlocs;
  final Function skipStepCallback;
  final Function submitStepCallback;

  FormStepBloc(
      {this.fieldsBlocs, this.skipStepCallback, this.submitStepCallback})
      : super(FormStepNotValid()) {
    fieldsBlocs.forEach((fieldBloc) {
      fieldBloc.listen((event) {
        if (!fieldsBlocs
            .any((element) => element.state is FormFieldValidating)) {
          ValidateFormStep();
        }
      });
    });
    MergeStream(fieldsBlocs).listen((event) {
      add(ValidateFormStep());
    });
  }

  @override
  Stream<FormStepState> mapEventToState(FormStepEvent event) async* {
    if (event is ValidateFormStep) yield _validateAllFields();
    if (event is SkipFormStep) yield _skipFormStep();
    if (event is SubmitFormStep) yield _submitFormStep();
  }

  FormStepState _validateAllFields() => fieldsBlocs.any((element) =>
          element.state is FormFieldNotValid ||
          element.state is FormFieldValidating ||
          (element.isRequired == true && element.state is FormFieldEmpty))
      ? FormStepNotValid()
      : FormStepValid();

  FormStepState _skipFormStep() {
    skipStepCallback();
    return FormStepSkipped();
  }

  FormStepState _submitFormStep() {
    Map<String, dynamic> allFormValues = {};
    fieldsBlocs.where((element) => element.state is FormFieldValid).forEach(
        (element) => allFormValues
            .addAll((element.state as FormFieldValid).keyValueMap()));
    submitStepCallback();
    return FormStepSubmitted(allFormValues);
  }
}
