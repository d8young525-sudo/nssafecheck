import 'package:hive/hive.dart';
import '../models/inspection_model.dart';

/// Hive 로컬 저장소 서비스
/// 점검 데이터의 CRUD 작업 관리
class HiveService {
  static const String _boxName = 'inspections';

  /// Hive Box 가져오기
  Box<InspectionModel> get _box => Hive.box<InspectionModel>(_boxName);

  /// 점검 데이터 저장
  /// - 새 점검: id로 키 생성하여 저장
  /// - 반환: 저장된 inspection의 id
  Future<String> saveInspection(InspectionModel inspection) async {
    try {
      // ID가 없으면 생성 (timestamp 기반)
      if (inspection.id == null || inspection.id!.isEmpty) {
        inspection.id = DateTime.now().millisecondsSinceEpoch.toString();
        inspection.createdAt = DateTime.now();
      }
      inspection.updatedAt = DateTime.now();

      // Hive에 저장 (key: inspection.id)
      await _box.put(inspection.id, inspection);
      
      return inspection.id!;
    } catch (e) {
      throw Exception('점검 저장 실패: $e');
    }
  }

  /// 점검 데이터 수정
  /// - 기존 inspection을 찾아서 업데이트
  Future<void> updateInspection(String id, InspectionModel inspection) async {
    try {
      inspection.id = id;
      inspection.updatedAt = DateTime.now();
      
      await _box.put(id, inspection);
    } catch (e) {
      throw Exception('점검 수정 실패: $e');
    }
  }

  /// 특정 점검 데이터 가져오기
  InspectionModel? getInspection(String id) {
    try {
      return _box.get(id);
    } catch (e) {
      throw Exception('점검 조회 실패: $e');
    }
  }

  /// 모든 점검 데이터 가져오기
  /// - 최신순 정렬 (updatedAt 기준)
  List<InspectionModel> getAllInspections() {
    try {
      final inspections = _box.values.toList();
      
      // 최신순 정렬
      inspections.sort((a, b) {
        if (a.updatedAt == null && b.updatedAt == null) return 0;
        if (a.updatedAt == null) return 1;
        if (b.updatedAt == null) return -1;
        return b.updatedAt!.compareTo(a.updatedAt!);
      });
      
      return inspections;
    } catch (e) {
      throw Exception('점검 목록 조회 실패: $e');
    }
  }

  /// 특정 기간의 점검 데이터 가져오기
  List<InspectionModel> getInspectionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) {
    try {
      final allInspections = _box.values.toList();
      
      return allInspections.where((inspection) {
        if (inspection.createdAt == null) return false;
        return inspection.createdAt!.isAfter(startDate) &&
            inspection.createdAt!.isBefore(endDate);
      }).toList();
    } catch (e) {
      throw Exception('기간별 점검 조회 실패: $e');
    }
  }

  /// 특정 시설의 점검 데이터 가져오기
  /// - wellId로 필터링
  List<InspectionModel> getInspectionsByWellId(String wellId) {
    try {
      final allInspections = _box.values.toList();
      
      return allInspections
          .where((inspection) => inspection.wellId == wellId)
          .toList();
    } catch (e) {
      throw Exception('시설별 점검 조회 실패: $e');
    }
  }

  /// 점검 데이터 삭제
  Future<void> deleteInspection(String id) async {
    try {
      await _box.delete(id);
    } catch (e) {
      throw Exception('점검 삭제 실패: $e');
    }
  }

  /// 모든 점검 데이터 삭제 (주의: 복구 불가능)
  Future<void> deleteAllInspections() async {
    try {
      await _box.clear();
    } catch (e) {
      throw Exception('전체 점검 삭제 실패: $e');
    }
  }

  /// 저장된 점검 개수
  int get inspectionCount => _box.length;

  /// 저장소가 비어있는지 확인
  bool get isEmpty => _box.isEmpty;

  /// 저장소에 데이터가 있는지 확인
  bool get isNotEmpty => _box.isNotEmpty;

  /// CSV 내보내기용 데이터 준비
  /// - 모든 점검 데이터를 Map 리스트로 변환
  List<Map<String, dynamic>> getInspectionsForExport() {
    try {
      final inspections = getAllInspections();
      return inspections.map((inspection) => inspection.toMap()).toList();
    } catch (e) {
      throw Exception('CSV 내보내기 데이터 준비 실패: $e');
    }
  }

  /// 특정 기간 데이터를 CSV 내보내기용으로 준비
  List<Map<String, dynamic>> getInspectionsForExportByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) {
    try {
      final inspections = getInspectionsByDateRange(startDate, endDate);
      return inspections.map((inspection) => inspection.toMap()).toList();
    } catch (e) {
      throw Exception('기간별 CSV 내보내기 데이터 준비 실패: $e');
    }
  }
}
