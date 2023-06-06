import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internship_practice/core/error/exceptions.dart';
import 'package:internship_practice/core/error/failure.dart';
import 'package:internship_practice/features/call/data/models/video_call_model.dart';
import 'package:internship_practice/features/call/data/repositories/call_repository_impl.dart';
import 'package:internship_practice/features/call/domain/entities/video_call_entity.dart';
import 'package:internship_practice/features/call/domain/usecases/get_rtc_token_usecase.dart';
import 'package:mockito/mockito.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late CallRepositoryImpl callRepositoryImpl;
  late MockCallRemoteDataSource mockCallRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockCallRemoteDataSource = MockCallRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    callRepositoryImpl = CallRepositoryImpl(
      callRemoteDataSource: mockCallRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestOnline(Function body) {
    group('device is online and connected to the Internet', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  group('get RTC token', () {
    const tVideoCallModel = VideoCallModel(rtcToken: "asasd");
    const VideoCallEntity tVideoCallEntity = tVideoCallModel;
    const tGetRtcTokenParams = GetRtcTokenParams(
      channelName: "test",
      role: "publisher",
      tokenType: "userAccount",
      uid: "10",
    );

    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockCallRemoteDataSource.getRtcToken(tGetRtcTokenParams))
          .thenAnswer((_) async => tVideoCallModel);
      // act
      await callRepositoryImpl.getRtcToken(tGetRtcTokenParams);
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestOnline(() {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
          'should return the remote data when the call to remote data source is successful',
          () async {
        // arrange
        when(mockCallRemoteDataSource.getRtcToken(tGetRtcTokenParams))
            .thenAnswer((_) async => tVideoCallModel);
        // act
        final result = await callRepositoryImpl.getRtcToken(tGetRtcTokenParams);
        // asssert
        verify(mockCallRemoteDataSource.getRtcToken(tGetRtcTokenParams));
        expect(result, equals(const Right(tVideoCallEntity)));
      });

      test(
          'should return ServerFailure when the call to remote data source is unsuccessful',
          () async {
        // arrange
        when(mockCallRemoteDataSource.getRtcToken(tGetRtcTokenParams))
            .thenThrow(ServerException());
        // act
        final result = await callRepositoryImpl.getRtcToken(tGetRtcTokenParams);
        // assert
        verify(mockCallRemoteDataSource.getRtcToken(tGetRtcTokenParams));
        expect(result, equals(Left(ServerFailure())));
      });
    });
  });
}
