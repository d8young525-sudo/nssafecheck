import 'dart:math';

class GPSCoordinate {
  final int degrees; // 도
  final int minutes; // 분
  final double seconds; // 초

  GPSCoordinate({
    required this.degrees,
    required this.minutes,
    required this.seconds,
  });

  // 십진수 좌표를 도/분/초로 변환
  factory GPSCoordinate.fromDecimal(double decimal) {
    // 도 계산
    int degrees = decimal.floor();
    
    // 분 계산
    double minutesDecimal = (decimal - degrees) * 60;
    int minutes = minutesDecimal.floor();
    
    // 초 계산
    double seconds = (minutesDecimal - minutes) * 60;
    
    return GPSCoordinate(
      degrees: degrees.abs(),
      minutes: minutes,
      seconds: double.parse(seconds.toStringAsFixed(2)),
    );
  }

  // 도/분/초를 십진수로 변환
  double toDecimal() {
    return degrees + (minutes / 60) + (seconds / 3600);
  }

  @override
  String toString() {
    return '$degrees° $minutes\' ${seconds.toStringAsFixed(2)}"';
  }

  // Map 변환 (Firestore 저장용)
  Map<String, String> toMap() {
    return {
      'degrees': degrees.toString(),
      'minutes': minutes.toString(),
      'seconds': seconds.toStringAsFixed(2),
    };
  }

  // Map에서 복원
  factory GPSCoordinate.fromMap(Map<String, dynamic> map) {
    return GPSCoordinate(
      degrees: int.tryParse(map['degrees']?.toString() ?? '0') ?? 0,
      minutes: int.tryParse(map['minutes']?.toString() ?? '0') ?? 0,
      seconds: double.tryParse(map['seconds']?.toString() ?? '0.0') ?? 0.0,
    );
  }
}

class GPSUtils {
  // 한국 표준 좌표계 범위
  static const double MIN_LATITUDE = 33.0;  // 제주도
  static const double MAX_LATITUDE = 39.0;  // 북한 경계
  static const double MIN_LONGITUDE = 124.0; // 서해
  static const double MAX_LONGITUDE = 132.0; // 동해

  // 좌표 유효성 검증
  static bool isValidCoordinate(double latitude, double longitude) {
    return latitude >= MIN_LATITUDE &&
           latitude <= MAX_LATITUDE &&
           longitude >= MIN_LONGITUDE &&
           longitude <= MAX_LONGITUDE;
  }

  // 경도 유효성 검증
  static bool isValidLongitude(double longitude) {
    return longitude >= MIN_LONGITUDE && longitude <= MAX_LONGITUDE;
  }

  // 위도 유효성 검증
  static bool isValidLatitude(double latitude) {
    return latitude >= MIN_LATITUDE && latitude <= MAX_LATITUDE;
  }

  // 십진수 좌표를 도/분/초로 분리
  static Map<String, GPSCoordinate> splitCoordinates(
    double latitude,
    double longitude,
  ) {
    return {
      'latitude': GPSCoordinate.fromDecimal(latitude),
      'longitude': GPSCoordinate.fromDecimal(longitude),
    };
  }

  // 도/분/초를 십진수로 결합
  static Map<String, double> combineCoordinates({
    required int latDegrees,
    required int latMinutes,
    required double latSeconds,
    required int lonDegrees,
    required int lonMinutes,
    required double lonSeconds,
  }) {
    double latitude = latDegrees + (latMinutes / 60) + (latSeconds / 3600);
    double longitude = lonDegrees + (lonMinutes / 60) + (lonSeconds / 3600);
    
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  // 두 좌표 간 거리 계산 (미터 단위)
  static double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371000; // 지구 반지름 (미터)
    
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);
    
    double a = sin(dLat / 2) * sin(dLat / 2) +
               cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
               sin(dLon / 2) * sin(dLon / 2);
    
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    
    return earthRadius * c;
  }

  static double _toRadians(double degrees) {
    return degrees * pi / 180;
  }
}
