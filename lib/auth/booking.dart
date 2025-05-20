class Booking {
  final String slotId;
  final DateTime startTime;
  final DateTime endTime;
  final DateTime createdAt;

  Booking({
    required this.slotId,
    required this.startTime,
    required this.endTime,
    required this.createdAt,
  });

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      slotId: map['slotId'] ?? '',
      startTime: DateTime.parse(map['startTime']),
      endTime: DateTime.parse(map['endTime']),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
