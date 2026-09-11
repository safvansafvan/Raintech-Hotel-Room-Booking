class Room {
  Room({
    required this.code,
    required this.type,
    required this.pricePerNight,
    required this.maxGuests,
  }) {
    if (code.trim().isEmpty) {
      throw ArgumentError.value(code, 'code', 'must not be empty');
    }
    if (type.trim().isEmpty) {
      throw ArgumentError.value(type, 'type', 'must not be empty');
    }
    if (pricePerNight <= 0) {
      throw ArgumentError.value(
        pricePerNight,
        'pricePerNight',
        'must be greater than zero',
      );
    }
    if (maxGuests <= 0) {
      throw ArgumentError.value(
        maxGuests,
        'maxGuests',
        'must be greater than zero',
      );
    }
  }

  final String code;
  final String type;
  final int pricePerNight;
  final int maxGuests;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Room &&
            code == other.code &&
            type == other.type &&
            pricePerNight == other.pricePerNight &&
            maxGuests == other.maxGuests;
  }

  @override
  int get hashCode => Object.hash(code, type, pricePerNight, maxGuests);

  @override
  String toString() {
    return 'Room(code: $code, type: $type, pricePerNight: $pricePerNight, '
        'maxGuests: $maxGuests)';
  }
}
