import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_form_bloc/easy_form_bloc.dart';

class SingleStepFormState extends State<SingleStepForm> {
  final FormFieldBloc<String> _loginFieldBloc = FormFieldBloc(
      defaultValue: "",
      valueKey: "login",
      futureValidator: (value) => ValidationRepository.asyncValidation(value),
      isRequired: true);
  final FormFieldBloc<String> _passwordFieldBloc = FormFieldBloc(
      defaultValue: "",
      valueKey: "password",
      validator: (value) => value.isNotEmpty,
      isRequired: true);
  final FormFieldBloc<bool> _termsFieldBloc = FormFieldBloc(
      defaultValue: false,
      valueKey: "terms",
      validator: (value) => value,
      isRequired: true);
  final FormFieldBloc<bool> _giodoFieldBloc = FormFieldBloc(
      defaultValue: false,
      valueKey: "terms",
      validator: (value) => value,
      isRequired: false);
  SingleStepFormBloc _formBloc;

  SingleStepFormState() {
    _formBloc = SingleStepFormBloc(
        fields: {
          _loginFieldBloc,
          _passwordFieldBloc,
          _termsFieldBloc,
          _giodoFieldBloc
        }.toList(),
        submitFuture: (values) => ValidationRepository.validateForm(values));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder(
                  cubit: _loginFieldBloc,
                  builder: (context, state) => Column(
                        children: [
                          TextFormField(
                              initialValue: _loginFieldBloc.defaultValue,
                              onChanged: (value) =>
                                  _loginFieldBloc.add(FieldValueChanged(value)),
                              decoration: InputDecoration(labelText: "Login")),
                          state is FormFieldValidating
                              ? Container(
                                  width: 20,
                                  height: 20,
                                  padding: EdgeInsets.all(5),
                                  child: CircularProgressIndicator())
                              : Container(),
                        ],
                      )),
              BlocBuilder(
                  cubit: _passwordFieldBloc,
                  builder: (context, state) => TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(labelText: "Password"),
                        initialValue: _passwordFieldBloc.defaultValue,
                        onChanged: (value) =>
                            _passwordFieldBloc.add(FieldValueChanged(value)),
                      )),
              BlocBuilder(
                  cubit: _termsFieldBloc,
                  builder: (context, state) => Row(
                        children: [
                          Checkbox(
                            value: _termsFieldBloc.state.value,
                            onChanged: (value) =>
                                _termsFieldBloc.add(FieldValueChanged(value)),
                          ),
                          Text("Accept terms *required")
                        ],
                      )),
              BlocBuilder(
                  cubit: _giodoFieldBloc,
                  builder: (context, state) => Row(
                        children: [
                          Checkbox(
                            value: _giodoFieldBloc.state.value,
                            onChanged: (value) =>
                                _giodoFieldBloc.add(FieldValueChanged(value)),
                          ),
                          Text("Accept giodo (optional)")
                        ],
                      )),
              BlocBuilder(
                  cubit: _formBloc,
                  builder: (context, state) => FlatButton(
                      onPressed: (state is FormValidForSubmit &&
                              state is! FormSubmittingLoading)
                          ? () => {_formBloc.add(SubmitForm())}
                          : null,
                      color: Colors.black,
                      disabledColor: Colors.red,
                      child: Text("Submit",
                          style: TextStyle(color: Colors.white)))),
              BlocBuilder(
                  cubit: _loginFieldBloc,
                  builder: (context, state) => Text("LoginFieldBloc: " +
                      state.runtimeType.toString() +
                      " Props: " +
                      (state as Equatable).props.toString())),
              BlocBuilder(
                  cubit: _passwordFieldBloc,
                  builder: (context, state) => Text("PasswordFieldBloc: " +
                      state.runtimeType.toString() +
                      " Props: " +
                      (state as Equatable).props.toString())),
              BlocBuilder(
                  cubit: _termsFieldBloc,
                  builder: (context, state) => Text("TermsFieldBloc: " +
                      state.runtimeType.toString() +
                      " Props: " +
                      (state as Equatable).props.toString())),
              BlocBuilder(
                  cubit: _giodoFieldBloc,
                  builder: (context, state) => Text("GiodoFieldBloc: " +
                      state.runtimeType.toString() +
                      " Props: " +
                      (state as Equatable).props.toString())),
              BlocBuilder(
                  cubit: _formBloc,
                  builder: (context, state) => Text("FormBloc: " +
                      state.runtimeType.toString() +
                      " Props: " +
                      (state as Equatable).props.toString()))
            ],
          ),
        ),
      );
}

class SingleStepForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SingleStepFormState();
}

class ValidationRepository {
  static Future<bool> asyncValidation(String login) =>
      Future.delayed(Duration(seconds: 2), () => Future.value(true));

  static validateForm(Map<String, dynamic> values) =>
      Future.delayed(Duration(seconds: 2), () => Future.value(true));
}
