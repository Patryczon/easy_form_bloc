import 'package:bloc/bloc.dart';

import 'form_event.dart';
import 'form_state.dart';

abstract class FormBloc extends Bloc<FormEvent, FormState> {
  final Function(Map<String, dynamic>) submitFunction;
  final Future Function(Map<String, dynamic>) submitFuture;

  void listenIsFormEnabled();

  Map<String, dynamic> getFormData();

  FormBloc({this.submitFuture, this.submitFunction})
      : assert(!(submitFuture == null && submitFunction == null)),
        super(FormNotValidForSubmit()) {
    listenIsFormEnabled();
  }

  @override
  Stream<FormState> mapEventToState(FormEvent event) async* {
    if (event is DisableForm) yield FormNotValidForSubmit();
    if (event is EnableForm) yield FormValidForSubmit();
    if (event is SubmitForm && state is FormValidForSubmit) {
      yield FormSubmittingLoading();
      if (submitFunction != null) yield _submitFormWithFunction(getFormData());
      if (submitFuture != null)
        yield await _submitFormWithFuture(getFormData());
    }
  }

  Future<FormState> _submitFormWithFuture(Map<String, dynamic> data) =>
      submitFuture(data)
          .then((value) => FormSubmitted(data))
          .catchError((ex) => FailedFormSubmitted(ex, data));

  FormState _submitFormWithFunction(Map<String, dynamic> data) {
    try {
      submitFunction(data);
      return FormSubmitted(data);
    } catch (ex) {
      return FailedFormSubmitted(ex, data);
    }
  }
}
