import 'dart:io';
import 'package:excel/excel.dart';
import '../models/facility_model.dart';

class ExcelService {
  // 엑셀 파일에서 관정 데이터 추출
  Future<List<Facility>> parseFacilityExcel(String filePath) async {
    try {
      var bytes = File(filePath).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);

      List<Facility> facilities = [];

      // 첫 번째 시트 사용
      String? sheetName = excel.tables.keys.first;
      var table = excel.tables[sheetName];

      if (table == null || table.rows.isEmpty) {
        throw Exception('엑셀 파일이 비어있습니다');
      }

      // 헤더 행 (첫 번째 행)
      List<String> headers = [];
      for (var cell in table.rows.first) {
        headers.add(cell?.value?.toString() ?? '');
      }

      print('📋 엑셀 헤더: $headers');

      // 데이터 행 (두 번째 행부터)
      for (int rowIndex = 1; rowIndex < table.rows.length; rowIndex++) {
        var row = table.rows[rowIndex];
        
        // 빈 행 건너뛰기
        bool isEmpty = true;
        for (var cell in row) {
          if (cell?.value != null && cell!.value.toString().trim().isNotEmpty) {
            isEmpty = false;
            break;
          }
        }
        if (isEmpty) continue;

        // 행 데이터를 Map으로 변환
        Map<String, dynamic> rowData = {};
        for (int colIndex = 0; colIndex < headers.length && colIndex < row.length; colIndex++) {
          String header = headers[colIndex];
          var cellValue = row[colIndex]?.value;
          rowData[header] = cellValue;
        }

        try {
          // Facility 객체 생성
          Facility facility = _parseFacilityRow(rowData);
          facilities.add(facility);
        } catch (e) {
          print('⚠️  행 $rowIndex 파싱 실패: $e');
          // 계속 진행
        }
      }

      print('✅ 엑셀 파싱 완료: ${facilities.length}개 관정');
      return facilities;
    } catch (e) {
      print('❌ 엑셀 파일 읽기 실패: $e');
      rethrow;
    }
  }

  // 행 데이터에서 Facility 객체 생성
  Facility _parseFacilityRow(Map<String, dynamic> rowData) {
    // WELL_ID 추출 (필수)
    String facilityId = rowData['WELL_ID']?.toString() ?? '';
    if (facilityId.isEmpty) {
      throw Exception('WELL_ID가 없습니다');
    }

    // 시설명 (WELL_ID를 기본값으로 사용)
    String facilityName = facilityId;

    // 지역 추출 (샘플 데이터 기반 추정)
    String region = _extractRegion(facilityId);

    return Facility(
      id: '', // Firestore에서 자동 생성
      facilityId: facilityId,
      facilityName: facilityName,
      region: region,
      address: null,
      latitude: null,
      longitude: null,
      status: 'active',
    );
  }

  // WELL_ID에서 지역 추출 (예: YI-005 -> 용인, PT-001 -> 평택)
  String _extractRegion(String wellId) {
    if (wellId.isEmpty) return '미분류';

    // 첫 두 글자를 기반으로 지역 추정
    String prefix = wellId.length >= 2 ? wellId.substring(0, 2).toUpperCase() : wellId;

    // 실제 관리 지역 코드 매핑
    switch (prefix) {
      case 'PT':
        return '평택';
      case 'YI':
        return '용인';
      case 'PJ':
        return '파주';
      case 'IC':
        return '이천';
      case 'AS':
        return '안성';
      case 'HS':
        return '화성';
      case 'YA':
        return '양주';
      case 'PC':
        return '포천';
      case 'YJ':
        return '여주';
      case 'YC':
        return '연천';
      case 'GP':
        return '가평';
      case 'YP':
        return '양평';
      default:
        return '미분류';
    }
  }

  // 관정 데이터를 엑셀로 내보내기 (향후 구현)
  Future<String> exportFacilitiesToExcel(List<Facility> facilities) async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['관정목록'];

    // 헤더 작성
    List<String> headers = [
      '관정ID',
      '시설명',
      '지역',
      '주소',
      '위도',
      '경도',
      '상태',
    ];

    for (int i = 0; i < headers.length; i++) {
      sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
          .value = TextCellValue(headers[i]);
    }

    // 데이터 작성
    for (int rowIndex = 0; rowIndex < facilities.length; rowIndex++) {
      Facility facility = facilities[rowIndex];
      List<dynamic> rowData = [
        facility.facilityId,
        facility.facilityName,
        facility.region,
        facility.address ?? '',
        facility.latitude?.toString() ?? '',
        facility.longitude?.toString() ?? '',
        facility.status,
      ];

      for (int colIndex = 0; colIndex < rowData.length; colIndex++) {
        sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: colIndex, rowIndex: rowIndex + 1))
            .value = TextCellValue(rowData[colIndex].toString());
      }
    }

    // 파일 저장 경로 (임시)
    String outputPath = '/tmp/facilities_export.xlsx';
    File(outputPath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(excel.encode()!);

    print('✅ 엑셀 내보내기 완료: $outputPath');
    return outputPath;
  }
}
