class Stop {
  final String stopId;
  final String stopCode;
  final String stopName;
  final double stopLat;
  final double stopLon;

  Stop({
    required this.stopId,
    required this.stopCode,
    required this.stopName,
    required this.stopLat,
    required this.stopLon,
  });

  factory Stop.fromJson(Map<String, dynamic> json) {
    return Stop(
      stopId: json['stop_id'],
      stopCode: json['stop_code'],
      stopName: json['stop_name'],
      stopLat: json['stop_lat'],
      stopLon: json['stop_lon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stop_id': stopId,
      'stop_code': stopCode,
      'stop_name': stopName,
      'stop_lat': stopLat,
      'stop_lon': stopLon,
    };
  }
}
