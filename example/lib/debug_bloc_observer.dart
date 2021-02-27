import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class DebugBlocObserver extends BlocObserver {
  @override
  void onChange(Cubit cubit, Change change) {
    if (isInDebugMode)
      print(
          '${cubit.runtimeType} $change new state properties ${(change.nextState as Equatable).props.toString()}');
    super.onChange(cubit, change);
  }

  @override
  void onEvent(Bloc bloc, Object event) {
    if (isInDebugMode) print(event.runtimeType);
    print('${bloc.runtimeType} ${(event as Equatable).props.toString()}');
    super.onEvent(bloc, event);
  }
}

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}
