# easy_form_bloc [![pub package](https://img.shields.io/pub/v/easy_form_bloc?style=flat-square)](https://pub.dev/packages/easy_form_bloc)

**Make writing forms easier with BLoC pattern!**

Bloc form is lightweight library which helps you writing forms and avoid
boilerplate.  
Library cover domain layer of forms so when using it you are still able
to use your own view implementation.

### Already done

- [x] Generic type fields
- [x] Synchronous Field Validation
- [X] Asynchronous Field Validation
- [X] Mapping value to Map<String,dynamic>
- [X] Single step forms with multiple fields
- [X] Skippable steps with callbacks
- [X] Synchronous Form Submitting
- [X] Asynchronous Form Submitting
- [X] States for loading, errors

### Things to implement

- [ ] Predefined validators
- [ ] Form Factory to make creating form easier
- [ ] Cover codebase with unit tests
- [ ] Create group fields fe. password repeat etc.
- [ ] Add support for creating forms from JSON data

# Getting started

Library was created with plan to make it as flexible as possible to
align to many cases. Basically forms contains fields. Fields sometimes
are not required, values entered by user mostly should be validated.
Value can be validate maybe by some repository or just with some
synchronized function. When all required fields are valid we would like
to give user possibility to submit form with entered data. Sounds very
common? It could be login form, one page registration form or anything
simillar.

# Single page form - Example#1

![](example_app_single_form.gif)

In that case we would like to implement simple registration form with
fields:
- Login field - validated with async repository,
- Password field - validated locally,
- Required term checkbox,
- Not required GiODO checkbox

At begin we have to create our fields BLoCs. Login field:

```dart
  FormFieldBloc<String> _loginFieldBloc = FormFieldBloc(
      defaultValue: "",
      valueKey: "login",
      futureValidator: (value) => ValidationRepository.asyncValidation(value),
      isRequired: true);
```

Password field:

```dart
  FormFieldBloc<String> _passwordFieldBloc = FormFieldBloc(
      defaultValue: "",
      valueKey: "password",
      futureValidator: (value) => ValidationRepository.asyncValidation(value),
      isRequired: true);
```

Terms field:

```dart
  FormFieldBloc<bool> _termsFieldBloc = FormFieldBloc(
      defaultValue: false,
      valueKey: "terms",
      validator: (value) => value,
      isRequired: true);
```

Giodo field:

```dart
  FormFieldBloc<bool> _giodoFieldsBloc = FormFieldBloc(
      defaultValue: false,
      valueKey: "giodo",
      validator: (value) => value,
      isRequired: false);
```

When fields BLoC's are already setup all what you need to do is make
your views add event inside thoose BLoC's. To do that you have to call
f.e.

```dart
_passwordFieldBloc.add(FieldValueChanged("abc"));
```

Then whole "magic" happens, BLoC is emitting state that field is under
validation and it's called FormFieldValidating then when validation is
finished based on result it emmits FormFieldValidationFailed or
FormFieldValid and that's all, based on that you can show anything you
would like, f.e. loading indicators etc, error messages/pop ups. To
connect many fields into form you need to use SingleStepForm class. To
create that you have to pass, fields bloc's, and submit function or
submit future. In our case it is how it looks like

```dart
_formBloc = SingleStepFormBloc(
        fields: {
          _loginFieldBloc,
          _passwordFieldBloc,
          _termsFieldBloc,
          _giodoFieldBloc
        }.toList(),
        submitFuture: (values) => ValidationRepository.validateForm(values));
```

FormBloc is subscribing to all fields blocs stream and tracking that is
it possible to make whole form Enabled or Disabled and base on that
emitting FormNotValidForSubmit or FormValidForSubmit. To submit form you
have to add SubmitForm event into FormBloc.

```dart
_formBloc.add(SubmitForm());
```

When that happens BLoC is emitting FormSubmittingLoading state what
allows you to show loading indicators etc. and then it calls
submitFuture or submitFunction with form data. Form data is in
Map<String,dynamic> in our case it is how example data passed for submit
function/future will looks like

```json
{
"login": "abc@abc.com",
"password": "admin",
"terms": true,
"giodo": false
}
```

and that's all for whole easy registration case. The only thing you need
to add is UI and your own way to build that based on state. Below is
example how that BLoC could be used.

# Multiple page form - Example#2

![](example_app_single_form.gif)

Sometimes single page form is not enough to cover our case. Because we
would like to split our form into few steps, some could be skippable and
at the end of form we would like to user submit form with data from all
steps and be sure that our user went through all steps correctly.

In this example we will have to cover specified case:
- First step with simple required fields - Name, surname,
- In second step we will ask user for his favourite color,
- Last step will also have required fields - Username, password

### First step

We will begin with creating Fields BLoC's so we will have:

````dart
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
````

### Second step

In second step we will create BLoC's for form steps and form itself:

````dart
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
````

As you can see above it's possible to pass skipping and submitting step
callback it allows you to f.e. navigate to next screen, log something
etc.

### Final step

So that's all now you have to only write your own UI and enjoy with
working forms without writing whole boilerplate cause I did it for you
:)

# Documentation

## FormFieldBloc<T>

That class should be use as your domain layer for single field in your
form. It is generic so with it you can handle of type of data.

Constructor parameters:

| Name                | Type                            | Description                                                                                                                                              | Required                        |
|:--------------------|:--------------------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------|:--------------------------------|
| defaultValue        | T(generic)                      | Default value of field                                                                                                                                   | yes                             |
| valueKey            | String                          | Key will be used to create Map<String,dynamic> when form will be submitted                                                                               | yes                             |
| validator           | bool Function(T value)          | Function which will validate field value and return boolean result                                                                                       | yes if  futureValidator is null |
| futureValidator     | Future<bool> Function(T value)  | Function which will return future which will validate field value and return async result                                                                | yes if validator is null        |
| isRequired          | bool                            | Indicates if field is required to make form step or form valid for submit (if field is not required and it will be not valid the value will be not used) | optional (default true)         |
| transformValueToMap | Map<String,dynamic> Function(T) | Function which will transform value into Map to be used for Form submitting. Useful with not primitive types.                                            | optional                        |

### Possible events:

#### FieldValueChanged<T>

That event should be added to bloc every time when you would like to
update BLoC field data.  
Constructor params:

| Name  | Type        | Description            | Required |
|:------|:------------|:-----------------------|:---------|
| value | T (generic) | Current value of field | yes      |

#### ClearField

That event will reset value of field to default one and BLoC will emit
FormFieldEmpty state.

### Possible states:

All possible fields states inherit FieldFormState class which has field
value which is generic typed.

#### FormFieldNotValid<T> extends FieldFormState<T>

That state will be emitted when validation after value changed will
return false.

#### FormFieldEmpty<T> extends FieldFormState<T>

That state will be emitted when current value is equal to default one.

#### FormFieldValidating<T> extends FieldFormState<T>

That state will be emitted when validation of field is in progress.

#### FormFieldValidationFailed<T> extends FieldFormState<T>

This state will be emitted when validation throw exception.

Constructor params:

| Name      | Type      | Description                         | Required |
|:----------|:----------|:------------------------------------|:---------|
| exception | Exception | Exception happend during validation | yes      |

#### FormFieldValid<T> extends FieldFormState<T>

This state will be emitted when value was validated with success

| Name     | Type               | Description                                                                                                            | Required |
|:---------|:-------------------|:-----------------------------------------------------------------------------------------------------------------------|:---------|
| fieldKey | String             | Field used to create key:value map when submitting form                                                                | yes      |
| valueMap | Map<String,dynamic | That value is optional and will be not null when we want to map our value to map with our transformValueToMap function | no       |

## FormStepBloc

That is based class for whole form. It is responsible for grouping
fields/steps and based on theirs states emits valid state

Constructor parameters:

| Name           | Type                                  | Description                                                                       | Required                      |
|:---------------|:--------------------------------------|:----------------------------------------------------------------------------------|:------------------------------|
| submitFunction | Function(Map<String, dynamic>)        | here we pass function which will be used for submiting form with valid data       | yes if submitFuture is null   |
| submitFuture   | Future Function(Map<String, dynamic>) | here we pass function which will be used for async submiting form with valid data | yes if submitFunction is null |

You can extend that class on your own to implement forms but there are 2
already prepared classes:

### **SingleStepFormBloc extends FormStepBloc**

That class is prepared to handle Forms with many fields but only with
one steps. It is listening to all fields blocs and if all required are
valid form itself is also valid for submitting.

Constructor parameters:

| Name           | Type                                  | Description                                                                       | Required                      |
|:---------------|:--------------------------------------|:----------------------------------------------------------------------------------|:------------------------------|
| submitFunction | Function(Map<String, dynamic>)        | here we pass function which will be used for submiting form with valid data       | yes if submitFuture is null   |
| submitFuture   | Future Function(Map<String, dynamic>) | here we pass function which will be used for async submiting form with valid data | yes if submitFunction is null |
| fields         | List<FormFieldBloc<dynamic>>          | list of fields blocs which form is containing                                     | yes                           |

### **MultiStepFormBloc extends FormStepBloc**

That class is prepared to handle many steps with many forms inside. It
is listening to a
That class is prepared to handle many steps with many forms inside. It
is listening to all steps blocs and if all are valid or skipped form
itself is also valid for submitting.ll steps blocs and if all are valid or skipped form
itself is also valid for submitting.

Constructor parameters:

| Name           | Type                                  | Description                                                                       | Required                      |
|:---------------|:--------------------------------------|:----------------------------------------------------------------------------------|:------------------------------|
| submitFunction | Function(Map<String, dynamic>)        | here we pass function which will be used for submiting form with valid data       | yes if submitFuture is null   |
| submitFuture   | Future Function(Map<String, dynamic>) | here we pass function which will be used for async submiting form with valid data | yes if submitFunction is null |
| formSteps      | List<FormStepBloc>                    | list of forms which form is containing                                            | yes                           |

### Possible events:

#### DisableForm

    That event is using for making forms disabled.

#### EnableForm

    That event is using for making forms enabled.

#### SubmitForm

    That event is using for submitting form, after that event is added FormBloc is calling submitFunction or submitFuture.

### Possible states:

#### FormNotValidForSubmit

    That state is initial one and will be emitted when not all steps/fields are valid.

#### FormValidForSubmit

    That state will be emitted when all required fields are valid and/or all steps are valid/skipped.

#### FormSubmittingLoading

    That state will be emitted after SubmitForm event was added and before calling submitFunction or submitFuture.

#### FormSubmitted extends FormValidForSubmit

    That state will be emitted when form submittion was successful. 

    Constructor params:

| Name          | Type                | Description                                   | Required |
|:--------------|:--------------------|:----------------------------------------------|:---------|
| dataSubmitted | Map<String,dynamic> | That fields contains data which was submitted | yes      |

#### FailedFormSubmitted

    That state will be emitted when submitFunction or submitFuture throws exception. 

    Constructor params:

| Name          | Type                | Description                                   | Required |
|:--------------|:--------------------|:----------------------------------------------|:---------|
| ex            | Exception           | Exception which was thrown during submission  | yes      |
| dataSubmitted | Map<String,dynamic> | That fields contains data which was submitted | yes      |


## Contribution ❤

Issues and pull requests are welcome

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/Patryczon/easy_form_bloc/issues

