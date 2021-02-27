import 'package:equatable/equatable.dart';

abstract class FormStepState extends Equatable {
  @override
  List<Object> get props => [];
}

class FormStepNotValid extends FormStepState {}

class FormStepValid extends FormStepState {}

class FormStepSkipped extends FormStepState {}

class FormStepSubmitted extends FormStepState {
  final Map<String, dynamic> allStepValues;

  FormStepSubmitted(this.allStepValues);
  @override
  List<Object> get props => [allStepValues];
}
