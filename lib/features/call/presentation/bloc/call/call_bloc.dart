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
    on<MakeCallEvent>(_makeCall);
  }

  Future<void> _makeCall(MakeCallEvent event, Emitter<CallState> emit) async {
    emit(CallLoading());
    final response = await makeCallUsecase.call(
      MakeCallParams(
        callerId: event.callerId,
        callerName: event.callerName,
        callerPhotoUrl: event.callerPhotoUrl,
        receiverId: event.receiverId,
        receiverName: event.receiverName,
        receiverPhotoUrl: event.receiverPhotoUrl,
        callStartTime: event.callStartTime,
        callEndTime: event.callEndTime,
      ),
    );
    response.fold(
      (failure) => emit(CallError(errorMessage: failure.toString())),
      (success) => emit(CallSuccess()),
    );
  }
}
