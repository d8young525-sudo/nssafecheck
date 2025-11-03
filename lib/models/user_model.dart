import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String name;
  final String role; // 'inspector' or 'admin'
  final List<String> assignedRegions; // 담당 지역 목록
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    this.role = 'inspector',
    this.assignedRegions = const [],
    this.createdAt,
    this.updatedAt,
  });

  // Firestore에서 데이터 가져오기
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      role: data['role'] ?? 'inspector',
      assignedRegions: List<String>.from(data['assignedRegions'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  // Firestore에 저장할 데이터
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'role': role,
      'assignedRegions': assignedRegions,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  // 관리자 여부 확인
  bool get isAdmin => role == 'admin';

  // 특정 지역에 대한 권한 확인
  bool hasAccessToRegion(String region) {
    if (isAdmin) return true; // 관리자는 모든 지역 접근 가능
    return assignedRegions.contains(region);
  }
}
