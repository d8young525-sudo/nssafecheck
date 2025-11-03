import 'package:cloud_firestore/cloud_firestore.dart';

class Facility {
  final String id; // 문서 ID
  final String facilityId; // YI-005, YP-152 등
  final String facilityName; // 시설명
  final String region; // 지역
  final String? address; // 주소
  final double? latitude; // 위도
  final double? longitude; // 경도
  final String status; // 'active', 'inactive'
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Facility({
    required this.id,
    required this.facilityId,
    required this.facilityName,
    required this.region,
    this.address,
    this.latitude,
    this.longitude,
    this.status = 'active',
    this.createdAt,
    this.updatedAt,
  });

  // Firestore에서 데이터 가져오기
  factory Facility.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Facility(
      id: doc.id,
      facilityId: data['facilityId'] ?? '',
      facilityName: data['facilityName'] ?? '',
      region: data['region'] ?? '',
      address: data['address'],
      latitude: data['latitude']?.toDouble(),
      longitude: data['longitude']?.toDouble(),
      status: data['status'] ?? 'active',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  // Firestore에 저장할 데이터
  Map<String, dynamic> toFirestore() {
    return {
      'facilityId': facilityId,
      'facilityName': facilityName,
      'region': region,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  // 엑셀 데이터에서 생성 (샘플.xlsx 구조 기반)
  factory Facility.fromExcel(Map<String, dynamic> excelData) {
    return Facility(
      id: '', // Firestore에서 자동 생성
      facilityId: excelData['WELL_ID']?.toString() ?? '',
      facilityName: excelData['시설명']?.toString() ?? excelData['WELL_ID']?.toString() ?? '',
      region: excelData['지역']?.toString() ?? '미분류',
      address: excelData['주소']?.toString(),
      latitude: _parseDouble(excelData['위도']),
      longitude: _parseDouble(excelData['경도']),
      status: 'active',
    );
  }

  // 숫자 파싱 헬퍼
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      try {
        return double.parse(value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}
