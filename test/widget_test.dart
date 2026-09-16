import 'package:flutter_test/flutter_test.dart';
import 'package:bhavana/core/constants/app_constants.dart';
import 'package:bhavana/features/session/models/track_type.dart';

void main() {
  test('app constants and tracks', () {
    expect(AppConstants.appName, 'Bhāvanā');
    expect(AppConstants.appSlug, 'bhavana');
    expect(TrackType.mind.label, 'Mind');
    expect(TrackType.body.label, 'Body');
    expect(TrackType.flexibility.label, 'Flexibility');
  });
}
