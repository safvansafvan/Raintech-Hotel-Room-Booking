class Room {
  Room({
    required this.code,
    required this.type,
    required this.pricePerNight,
    required this.maxGuests,
  });

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
