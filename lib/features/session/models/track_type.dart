enum TrackType {
  mind,
  body,
  flexibility,
}

extension TrackTypeX on TrackType {
  String get label {
    switch (this) {
      case TrackType.mind:
        return 'Mind';
      case TrackType.body:
        return 'Body';
      case TrackType.flexibility:
        return 'Flexibility';
    }
  }

  String get subtitle {
    switch (this) {
      case TrackType.mind:
        return 'Breath, attention, and quiet presence';
      case TrackType.body:
        return 'Gentle movement and grounded strength';
      case TrackType.flexibility:
        return 'Soft opening and ease through the body';
    }
  }

  String get id => name;
}
