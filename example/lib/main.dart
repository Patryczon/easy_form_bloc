import 'package:bloc/bloc.dart';
import 'package:easy_form_bloc/easy_form_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/debug_bloc_observer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  Bloc.observer = DebugBlocObserver();
  runApp(MyApp());
}

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

class MultiPageFormState extends State<MultiPageForm> {
  final PageController _pageController = PageController();
  final FormFieldBloc<String> _nameFieldBloc = FormFieldBloc(
      defaultValue: "",
      valueKey: "name",
      validator: (value) => value.isNotEmpty,
      isRequired: true);

  final FormFieldBloc<String> _surNameFieldBloc = FormFieldBloc(
      defaultValue: "",
      valueKey: "surName",
      validator: (value) => value.isNotEmpty,
      isRequired: true);

  final FormFieldBloc<Color> _favouriteColorFieldBloc = FormFieldBloc(
      defaultValue: Colors.white,
      valueKey: "favouriteColor",
      validator: (value) => true,
      isRequired: false,
      transformValueToMap: (color) => {"colorCode": color.value});

  final FormFieldBloc<String> _loginFieldBloc = FormFieldBloc(
      defaultValue: "",
      valueKey: "login",
      validator: (value) => value.isNotEmpty,
      isRequired: true);

  final FormFieldBloc<String> _passwordFieldBloc = FormFieldBloc(
      defaultValue: "",
      valueKey: "password",
      validator: (value) => Validator.isPasswordValid(value),
      isRequired: true);

  FormStepBloc _firstStepBloc;
  FormStepBloc _secondStepBloc;
  FormStepBloc _thirdStepBloc;
  MultiStepsFormBloc _formBloc;

  MultiPageFormState() {
    _firstStepBloc = FormStepBloc(
        fieldsBlocs: [_nameFieldBloc, _surNameFieldBloc],
        submitStepCallback: _navigateToNextStep);
    _secondStepBloc = FormStepBloc(
        fieldsBlocs: [_favouriteColorFieldBloc],
        skipStepCallback: _navigateToNextStep,
        submitStepCallback: _navigateToNextStep);
    _thirdStepBloc = FormStepBloc(
        fieldsBlocs: [_loginFieldBloc, _passwordFieldBloc],
        submitStepCallback: _navigateToNextStep);
    _formBloc = MultiStepsFormBloc(
        formSteps: [_firstStepBloc, _secondStepBloc, _thirdStepBloc],
        submitFuture: Repository.submitForm);
  }

  _navigateToNextStep() => _pageController.nextPage(
      duration: Duration(milliseconds: 50), curve: Curves.easeIn);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: PageView(
          controller: _pageController,
          children: [
            FirstFormPage(
                stepBloc: _firstStepBloc,
                nameFieldBloc: _nameFieldBloc,
                surNameFieldBloc: _surNameFieldBloc),
            SecondFormPage(
                stepBloc: _secondStepBloc,
                favouriteColorFieldBloc: _favouriteColorFieldBloc),
            ThirdFormPage(
              loginFieldBloc: _loginFieldBloc,
              passwordFieldBloc: _passwordFieldBloc,
              stepBloc: _thirdStepBloc,
            ),
            FourthFormPage(formBloc: _formBloc)
          ],
        ),
      );

  @override
  void dispose() {
    super.dispose();
    _nameFieldBloc.close();
    _surNameFieldBloc.close();
    _loginFieldBloc.close();
    _passwordFieldBloc.close();
    _favouriteColorFieldBloc.close();
    _firstStepBloc.close();
    _secondStepBloc.close();
    _thirdStepBloc.close();
    _formBloc.close();
  }
}

class MultiPageForm extends StatefulWidget {
  @override
  State<MultiPageForm> createState() => MultiPageFormState();
}

class FirstFormPage extends StatelessWidget {
  final FormFieldBloc<String> nameFieldBloc;
  final FormFieldBloc<String> surNameFieldBloc;
  final FormStepBloc stepBloc;

  const FirstFormPage(
      {Key key, this.nameFieldBloc, this.surNameFieldBloc, this.stepBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder(
                cubit: nameFieldBloc,
                builder: (context, state) => TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(labelText: "Name"),
                      initialValue: nameFieldBloc.defaultValue,
                      onChanged: (value) =>
                          nameFieldBloc.add(FieldValueChanged(value)),
                    )),
            BlocBuilder(
                cubit: surNameFieldBloc,
                builder: (context, state) => TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(labelText: "Surname"),
                      initialValue: surNameFieldBloc.defaultValue,
                      onChanged: (value) =>
                          surNameFieldBloc.add(FieldValueChanged(value)),
                    )),
            BlocBuilder(
              cubit: stepBloc,
              builder: (context, state) => FlatButton(
                  color: Colors.black,
                  onPressed: state is FormStepValid
                      ? () => {stepBloc.add(SubmitFormStep())}
                      : null,
                  disabledColor: Colors.red,
                  child: Text(state.toString(),
                      style: TextStyle(color: Colors.white))),
            ),
            BlocBuilder(
                cubit: nameFieldBloc,
                builder: (context, state) => Text("NameFieldBloc: " +
                    state.runtimeType.toString() +
                    " Props: " +
                    (state as Equatable).props.toString())),
            BlocBuilder(
                cubit: surNameFieldBloc,
                builder: (context, state) => Text("SurnameFieldBloc: " +
                    state.runtimeType.toString() +
                    " Props: " +
                    (state as Equatable).props.toString())),
            BlocBuilder(
                cubit: stepBloc,
                builder: (context, state) => Text("StepBloc: " +
                    state.runtimeType.toString() +
                    " Props: " +
                    (state as Equatable).props.toString()))
          ],
        ),
      );
}

class SecondFormPage extends StatelessWidget {
  final FormFieldBloc<Color> favouriteColorFieldBloc;
  final FormStepBloc stepBloc;

  const SecondFormPage({Key key, this.favouriteColorFieldBloc, this.stepBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        BlocBuilder(
          cubit: favouriteColorFieldBloc,
          builder: (context, state) => ColorPicker(
            pickerColor: (state as FieldFormState).value,
            onColorChanged: (color) =>
                favouriteColorFieldBloc.add(FieldValueChanged(color)),
            showLabel: true,
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        FlatButton(
            color: Colors.black,
            onPressed: () => stepBloc.add(SubmitFormStep()),
            child:
                Text("Submit src.step", style: TextStyle(color: Colors.white))),
        FlatButton(
            color: Colors.black,
            onPressed: () => stepBloc.add(SkipFormStep()),
            child:
                Text("Skip src.step", style: TextStyle(color: Colors.white))),
        BlocBuilder(
            cubit: favouriteColorFieldBloc,
            builder: (context, state) => Text("FavouriteColorFieldBloc: " +
                state.runtimeType.toString() +
                " Props: " +
                (state as Equatable).props.toString())),
        BlocBuilder(
            cubit: stepBloc,
            builder: (context, state) => Text("StepBloc: " +
                state.runtimeType.toString() +
                " Props: " +
                (state as Equatable).props.toString()))
      ]);
}

class ThirdFormPage extends StatelessWidget {
  final FormFieldBloc<String> loginFieldBloc;
  final FormFieldBloc<String> passwordFieldBloc;
  final FormStepBloc stepBloc;

  const ThirdFormPage(
      {Key key, this.loginFieldBloc, this.passwordFieldBloc, this.stepBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder(
                cubit: loginFieldBloc,
                builder: (context, state) => TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(labelText: "Login"),
                      initialValue: loginFieldBloc.defaultValue,
                      onChanged: (value) =>
                          loginFieldBloc.add(FieldValueChanged(value)),
                    )),
            BlocBuilder(
                cubit: passwordFieldBloc,
                builder: (context, state) => TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(labelText: "Password"),
                      initialValue: passwordFieldBloc.defaultValue,
                      onChanged: (value) =>
                          passwordFieldBloc.add(FieldValueChanged(value)),
                    )),
            BlocBuilder(
              cubit: stepBloc,
              builder: (context, state) => FlatButton(
                  color: Colors.black,
                  onPressed: state is FormStepValid
                      ? () => {stepBloc.add(SubmitFormStep())}
                      : null,
                  disabledColor: Colors.red,
                  child: Text(state.toString(),
                      style: TextStyle(color: Colors.white))),
            ),
            BlocBuilder(
                cubit: loginFieldBloc,
                builder: (context, state) => Text("LoginFieldBloc: " +
                    state.runtimeType.toString() +
                    " Props: " +
                    (state as Equatable).props.toString())),
            BlocBuilder(
                cubit: passwordFieldBloc,
                builder: (context, state) => Text("PasswordFieldBloc: " +
                    state.runtimeType.toString() +
                    " Props: " +
                    (state as Equatable).props.toString())),
            BlocBuilder(
                cubit: stepBloc,
                builder: (context, state) => Text("StepBloc: " +
                    state.runtimeType.toString() +
                    " Props: " +
                    (state as Equatable).props.toString()))
          ],
        ),
      );
}

class FourthFormPage extends StatelessWidget {
  final FormBloc formBloc;

  const FourthFormPage({Key key, this.formBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlatButton(
              color: Colors.black,
              onPressed: () => formBloc.add(SubmitForm()),
              disabledColor: Colors.red,
              child:
                  Text("Submit Form", style: TextStyle(color: Colors.white))),
          BlocBuilder(
              cubit: formBloc,
              builder: (context, state) => Text(state.toString() +
                  (state is FormSubmitted
                      ? state.dataSubmitted.toString()
                      : ""))),
          BlocBuilder(
              cubit: formBloc,
              builder: (context, state) => Text("FormBloc: " +
                  state.runtimeType.toString() +
                  " Props: " +
                  (state as Equatable).props.toString()))
        ],
      );
}

//Example of validator class
class Validator {
  static bool isPasswordValid(String password) => password.isNotEmpty;

  static bool isEmailValid(String email) => email.isNotEmpty;

  static bool isNameValid(String name) => name.isNotEmpty;

  static bool isSurNameValid(String surName) => surName.isNotEmpty;
}

//Example of async repository
class Repository {
  static Future submitForm(Map<String, dynamic> data) =>
      Future.delayed(Duration(seconds: 2), () => Future.value(""));
}

class ValidationRepository {
  static Future<bool> asyncValidation(String login) =>
      Future.delayed(Duration(seconds: 2), () => Future.value(true));

  static validateForm(Map<String, dynamic> values) =>
      Future.delayed(Duration(seconds: 2), () => Future.value(true));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(backgroundColor: Colors.white, body: MainScreen()),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton(
                color: Colors.black,
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SingleStepForm())),
                child: Text("Single step form",
                    style: TextStyle(color: Colors.white))),
            FlatButton(
                color: Colors.black,
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => MultiPageForm())),
                child: Text("Multi steps form",
                    style: TextStyle(color: Colors.white))),
          ],
        ),
      );
}
