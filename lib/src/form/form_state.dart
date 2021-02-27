import 'package:equatable/equatable.dart';

abstract class FormState extends Equatable {
  @override
  List<Object> get props => [];
}

class FormNotValidForSubmit extends FormState {}

class FormValidForSubmit extends FormState {}

class FormSubmittingLoading extends FormState {}

class FormSubmitted extends FormValidForSubmit {
  final Map<String, dynamic> dataSubmitted;

  FormSubmitted(this.dataSubmitted);

  @override
  List<Object> get props => [dataSubmitted];
}

class FailedFormSubmitted extends FormState {
  final Exception ex;
  final Map<String, dynamic> dataSubmitted;

  FailedFormSubmitted(this.ex, this.dataSubmitted);

  @override
  List<Object> get props => [ex, dataSubmitted];
}
