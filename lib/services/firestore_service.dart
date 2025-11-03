import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/facility_model.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ========== 사용자 관련 ==========

  // 현재 사용자 정보 가져오기
  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('❌ 사용자 정보 가져오기 실패: $e');
      return null;
    }
  }

  // ========== 관정 관련 ==========

  // 모든 관정 가져오기
  Future<List<Facility>> getAllFacilities() async {
    try {
      QuerySnapshot snapshot = await _db
          .collection('facilities')
          .where('status', isEqualTo: 'active')
          .get();

      return snapshot.docs
          .map((doc) => Facility.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('❌ 관정 목록 가져오기 실패: $e');
      return [];
    }
  }

  // 지역별 관정 가져오기
  Future<List<Facility>> getFacilitiesByRegion(String region) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection('facilities')
          .where('region', isEqualTo: region)
          .where('status', isEqualTo: 'active')
          .get();

      return snapshot.docs
          .map((doc) => Facility.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('❌ 지역별 관정 가져오기 실패: $e');
      return [];
    }
  }

  // 여러 지역의 관정 가져오기
  Future<List<Facility>> getFacilitiesByRegions(List<String> regions) async {
    if (regions.isEmpty) {
      return getAllFacilities();
    }

    try {
      // Firestore 'in' 쿼리는 최대 10개까지만 지원
      // 그 이상은 여러 쿼리로 나눠야 함
      if (regions.length <= 10) {
        QuerySnapshot snapshot = await _db
            .collection('facilities')
            .where('region', whereIn: regions)
            .where('status', isEqualTo: 'active')
            .get();

        return snapshot.docs
            .map((doc) => Facility.fromFirestore(doc))
            .toList();
      } else {
        // 10개 이상인 경우 chunk로 나눠서 가져오기
        List<Facility> allFacilities = [];
        for (int i = 0; i < regions.length; i += 10) {
          List<String> chunk = regions.sublist(
            i,
            i + 10 > regions.length ? regions.length : i + 10,
          );
          QuerySnapshot snapshot = await _db
              .collection('facilities')
              .where('region', whereIn: chunk)
              .where('status', isEqualTo: 'active')
              .get();

          allFacilities.addAll(
            snapshot.docs.map((doc) => Facility.fromFirestore(doc)),
          );
        }
        return allFacilities;
      }
    } catch (e) {
      print('❌ 관정 목록 가져오기 실패: $e');
      return [];
    }
  }

  // 관정 추가 (단일)
  Future<bool> addFacility(Facility facility) async {
    try {
      await _db.collection('facilities').add(facility.toFirestore());
      print('✅ 관정 추가 성공: ${facility.facilityId}');
      return true;
    } catch (e) {
      print('❌ 관정 추가 실패: $e');
      return false;
    }
  }

  // 관정 일괄 추가 (엑셀 업로드)
  Future<Map<String, dynamic>> addFacilitiesBatch(List<Facility> facilities) async {
    int successCount = 0;
    int failCount = 0;
    List<String> errors = [];

    WriteBatch batch = _db.batch();
    int batchCount = 0;
    const int maxBatchSize = 500; // Firestore batch 최대 크기

    try {
      for (var facility in facilities) {
        try {
          DocumentReference docRef = _db.collection('facilities').doc();
          batch.set(docRef, facility.toFirestore());
          batchCount++;

          // 500개마다 batch commit
          if (batchCount >= maxBatchSize) {
            await batch.commit();
            successCount += batchCount;
            batch = _db.batch();
            batchCount = 0;
          }
        } catch (e) {
          failCount++;
          errors.add('${facility.facilityId}: $e');
        }
      }

      // 남은 데이터 commit
      if (batchCount > 0) {
        await batch.commit();
        successCount += batchCount;
      }

      print('✅ 관정 일괄 추가 완료: 성공 $successCount개, 실패 $failCount개');
      
      return {
        'success': true,
        'successCount': successCount,
        'failCount': failCount,
        'errors': errors,
      };
    } catch (e) {
      print('❌ 관정 일괄 추가 실패: $e');
      return {
        'success': false,
        'successCount': successCount,
        'failCount': failCount + (facilities.length - successCount - failCount),
        'errors': [...errors, '배치 작업 실패: $e'],
      };
    }
  }

  // ========== 지역 관련 ==========

  // 모든 지역 가져오기
  Future<List<String>> getAllRegions() async {
    try {
      QuerySnapshot snapshot = await _db.collection('regions').get();
      return snapshot.docs
          .map((doc) => (doc.data() as Map<String, dynamic>)['regionName'] as String)
          .toList();
    } catch (e) {
      print('❌ 지역 목록 가져오기 실패: $e');
      return [];
    }
  }
}
