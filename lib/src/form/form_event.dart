import 'package:equatable/equatable.dart';

abstract class FormEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class DisableForm extends FormEvent {}

class EnableForm extends FormEvent {}

class SubmitForm extends FormEvent {}
