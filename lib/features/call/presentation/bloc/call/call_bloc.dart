import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internship_practice/features/call/domain/entities/call_entity.dart';
import 'package:internship_practice/features/call/domain/usecases/get_call_logs_usecase.dart';
import 'package:internship_practice/features/call/domain/usecases/make_call_usecase.dart';

part 'call_event.dart';
part 'call_state.dart';

class CallBloc extends Bloc<CallEvent, CallState> {
  final MakeCallUsecase makeCallUsecase;
  final GetCallLogsUsecase getCallLogsUsecase;

  CallBloc({
    required this.makeCallUsecase,
    required this.getCallLogsUsecase,
  }) : super(CallInitial()) {
    on<MakeCallEvent>(_makeCall);
    on<GetAllCallLogsEvent>(_getAllCallLogs);
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

  Future<void> _getAllCallLogs(
      GetAllCallLogsEvent event, Emitter<CallState> emit) async {
    emit(CallLoading());
    final response = await getCallLogsUsecase.call(
      GetCallLogsParams(userId: event.userId),
    );
    response.fold(
      (failure) => emit(CallError(errorMessage: failure.toString())),
      (callLogList) => emit(CallLogsLoaded(callLogsList: callLogList)),
    );
  }

  // Stream<List<CallEntity>> _getAllCallLogs(
  //     GetAllCallLogsEvent event, Emitter<CallState> emit) {
  //   return getCallLogsUsecase.call(
  //     GetCallLogsParams(
  //       userId: event.userId,
  //     ),
  //   );
  // }
}
