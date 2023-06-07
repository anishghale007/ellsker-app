import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internship_practice/features/call/domain/usecases/make_call_usecase.dart';

part 'call_event.dart';
part 'call_state.dart';

class CallBloc extends Bloc<CallEvent, CallState> {
  final MakeCallUsecase makeCallUsecase;

  CallBloc({
    required this.makeCallUsecase,
  }) : super(CallInitial()) {
    on<CallEvent>((event, emit) {});
  }
}
