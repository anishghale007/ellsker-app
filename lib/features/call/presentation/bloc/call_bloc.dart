import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internship_practice/features/call/domain/entities/video_call_entity.dart';
import 'package:internship_practice/features/call/domain/usecases/get_rtc_token_usecase.dart';

part 'call_event.dart';
part 'call_state.dart';

class CallBloc extends Bloc<CallEvent, CallState> {
  final GetRtcTokenUsecase getRtcTokenUsecase;

  CallBloc({
    required this.getRtcTokenUsecase,
  }) : super(CallInitial()) {
    on<GetRtcTokenEvent>(
      (event, emit) async {
        final response = await getRtcTokenUsecase.call(
          GetRtcTokenParams(
            channelName: event.channelName,
            role: event.role,
            tokenType: event.tokenType,
            uid: event.uid,
          ),
        );
        response.fold(
            (failure) => emit(CallError(errorMessage: failure.toString())),
            (success) => emit(CallSuccess(videoCallEntity: success)));
      },
    );
  }

  // Future<void> _onGetRtcToken(
  //     GetRtcTokenEvent event, Emitter<CallState> emit) async {
  //   emit(CallLoading());
  //   final response = await getRtcTokenUsecase.call(NoParams());
  //   response.fold(
  //     (failure) => emit(CallError(errorMessage: failure.toString())),
  //     (success) => emit(CallSuccess(videoCallEntity: success)),
  //   );
  // }
}
