import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:internship_practice/features/call/data/models/video_call_model.dart';
import 'package:internship_practice/features/call/domain/entities/video_call_entity.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tVideoCallModel = VideoCallModel(rtcToken: "asasd");

  test('should be a subclass of VideoCallEntity', () async {
    // assert
    expect(tVideoCallModel, isA<VideoCallEntity>());
  });

  group('fromJson', () {
    test('should return a proper JSON map containing the token', () async {
      // arrane
      final Map<String, dynamic> jsonMap = json.decode(fixture('token.json'));
      // act
      final result = VideoCallModel.fromJson(jsonMap);
      // assert
      expect(result, tVideoCallModel);
    });
  });
}
