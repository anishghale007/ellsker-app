import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internship_practice/features/call/domain/entities/rtc_token_entity.dart';
import 'package:internship_practice/features/call/domain/usecases/get_rtc_token_usecase.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late GetRtcTokenUsecase getRtcTokenUsecase;
  late MockCallRepository mockCallRepository;

  setUp(() {
    mockCallRepository = MockCallRepository();
    getRtcTokenUsecase = GetRtcTokenUsecase(callRepository: mockCallRepository);
  });

  group('rtc token usecase', () {
    test('should get token from the repository', () async {
      const tGetRtcTokenParams = GetRtcTokenParams(
        channelName: "test",
        role: "publisher",
        tokenType: "userAccount",
        uid: "10",
      );
      const tVideoCallEntity = RtcTokenEntity(rtcToken: "asdadasdasd");
      // arrange
      when(mockCallRepository.getRtcToken(tGetRtcTokenParams))
          .thenAnswer((_) async => const Right(tVideoCallEntity));
      // act
      final result = await getRtcTokenUsecase(tGetRtcTokenParams);
      // assert
      verify(mockCallRepository.getRtcToken(tGetRtcTokenParams));
      expect(result, const Right(tVideoCallEntity));
    });
  });
}
