import 'package:equatable/equatable.dart';

abstract class BottomNavEvent extends Equatable {
  const BottomNavEvent();

  @override
  List<Object?> get props => [];
}

class ChangeBottomNavTabEvent extends BottomNavEvent {
  final int index;

  const ChangeBottomNavTabEvent(this.index);

  @override
  List<Object?> get props => [index];
}
