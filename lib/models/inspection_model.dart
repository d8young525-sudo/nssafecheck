import 'package:cloud_firestore/cloud_firestore.dart';

class InspectionModel {
  final String id; // 문서 ID
  final String facilityId; // 관정 ID
  final String inspectorId; // 점검자 ID
  final String inspectorName; // 점검자 이름
  final DateTime inspectDate; // 점검 일시
  final String region; // 지역

  // PART 1: 기본정보
  final Map<String, dynamic> basicInfo;
  
  // PART 2: 측정 장치 및 시설
  final Map<String, dynamic> facilities;
  
  // PART 3: 전기 설비
  final Map<String, dynamic> electrical;
  
  // PART 4: 종합 평가
  final Map<String, dynamic> assessment;

  // 사진 정보 (기기 로컬 경로만 저장)
  final List<Map<String, dynamic>> photos;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  InspectionModel({
    required this.id,
    required this.facilityId,
    required this.inspectorId,
    required this.inspectorName,
    required this.inspectDate,
    required this.region,
    required this.basicInfo,
    required this.facilities,
    required this.electrical,
    required this.assessment,
    this.photos = const [],
    this.createdAt,
    this.updatedAt,
  });

  // Firestore에서 데이터 가져오기
  factory InspectionModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return InspectionModel(
      id: doc.id,
      facilityId: data['facilityId'] ?? '',
      inspectorId: data['inspectorId'] ?? '',
      inspectorName: data['inspectorName'] ?? '',
      inspectDate: (data['inspectDate'] as Timestamp).toDate(),
      region: data['region'] ?? '',
      basicInfo: Map<String, dynamic>.from(data['basicInfo'] ?? {}),
      facilities: Map<String, dynamic>.from(data['facilities'] ?? {}),
      electrical: Map<String, dynamic>.from(data['electrical'] ?? {}),
      assessment: Map<String, dynamic>.from(data['assessment'] ?? {}),
      photos: List<Map<String, dynamic>>.from(data['photos'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  // Firestore에 저장할 데이터
  Map<String, dynamic> toFirestore() {
    return {
      'facilityId': facilityId,
      'inspectorId': inspectorId,
      'inspectorName': inspectorName,
      'inspectDate': Timestamp.fromDate(inspectDate),
      'region': region,
      'basicInfo': basicInfo,
      'facilities': facilities,
      'electrical': electrical,
      'assessment': assessment,
      'photos': photos,
      'createdAt': createdAt != null 
          ? Timestamp.fromDate(createdAt!) 
          : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  // 엑셀 내보내기용 평탄화 데이터
  Map<String, dynamic> toExcelRow() {
    return {
      'WELL_ID': facilityId,
      'INSPECTOR': inspectorName,
      'INSPECT_DATE': inspectDate.toString().split(' ')[0],
      
      // PART 1
      ...basicInfo,
      
      // PART 2
      ...facilities,
      
      // PART 3
      ...electrical,
      
      // PART 4
      ...assessment,
    };
  }
}
