import 'package:flutter_bloc/flutter_bloc.dart';
import 'bottom_nav_event.dart';
import 'bottom_nav_state.dart';

class BottomNav3Bloc extends Bloc<BottomNavEvent, BottomNavState> {
  BottomNav3Bloc() : super(const BottomNavState()) {
    on<ChangeBottomNavTabEvent>((event, emit) {
      emit(state.copyWith(currentIndex: event.index));
    });
  }
}
