import 'package:equatable/equatable.dart';

abstract class FormStepEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ValidateFormStep extends FormStepEvent {}

class SkipFormStep extends FormStepEvent {}

class SubmitFormStep extends FormStepEvent {}
