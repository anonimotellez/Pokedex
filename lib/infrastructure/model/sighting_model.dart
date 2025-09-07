//conditions for information
class Sighting {
  final String imagePath;
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  Sighting({
    required this.imagePath,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    "imagePath": imagePath,
    "latitude": latitude,
    "longitude": longitude,
    "timestamp": timestamp.toIso8601String(),
  };

  factory Sighting.fromJson(Map<String, dynamic> json) => Sighting(
    imagePath: json["imagePath"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    timestamp: DateTime.parse(json["timestamp"]),
  );
}
