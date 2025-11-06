import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import '../../models/inspection_model.dart';

/// 점검 데이터 내보내기 서비스
class InspectionExportService {
  /// CSV 내보내기 (외주출력 엑셀 템플릿 기반 헤더)
  static Future<void> exportToCsv(List<InspectionModel> inspections) async {
    if (inspections.isEmpty) {
      throw Exception('내보낼 데이터가 없습니다');
    }

    // CSV 헤더 (외주출력 시트 1행 기반)
    List<List<dynamic>> rows = [
      [
        'WELL_ID',              // 시설명
        'YANGSU_TYPE',          // 양수장형태
        'INSPECTOR',            // 점검자
        'INSPECT_DATE',         // 점검일자
        'FLOW_METER_YN',        // 유량계유무
        'SUWICHECKPIPE_YN',     // 수위확인관유무
        'CHULSUFAC_YN',         // 출수구유무
        'WL_POND_HEIGHT2',      // 수위
        'FLOW_METER_NUM',       // 유량계번호
        'WEIGH_METER_ID',       // 계량기ID
        'WEIGH_METER_NUM',      // 계량기번호
        'ELECTRIC_YN',          // 전기유무
        'WAT_TEMP',             // 수온
        'JUNKI',                // 전기전도도
        'PH',                   // pH
        'NATURAL_LEVEL_1',      // 자연수위
        'WL_PUMP_DISCHARGE_1',  // 토출량
        'FRG_ST',               // 이물질
        'PRT_CRK_ST',           // 균열
        'PRT_LEAK_ST',          // 누수
        'PRT_SSD_ST',           // 침하
        'CONST_DATE2',          // 장옥덮개
        'POLPRT_COVCOR_ST',     // 부식도
        'INSPECTOR_DEPT2',      // 스마트안내문
        'BOONSU2',              // 관정덮개
        'CHK_SPHERE2',          // 출입문
        'SWITCHBOX_LOOK',       // 배전함외관
        'SWITCHBOX_INST',       // 배전함설치
        'SWITCHBOX_GR',         // 배전함접지단자
        'SWITCHBOX_IR',         // 배전함절연단자
        'SWITCHBOX_MOV',        // 배전반동작
        'PUMP_GR2',             // 전기연결(펌프접지)
        'PUMP_IR',              // 펌프절연저항
        'GPUMP_NOISE2',         // 지시전압
        'GPUMP_GR2',            // 지시전류
        'GPUMP_IR2',            // 휴즈
        'SWITCHBOX_LOOK2',      // Floatless
        'SWITCHBOX_INST2',      // EOCR
        'SWITCHBOX_GR2',        // 마그네틱
        'SWITCHBOX_IR2',        // 램프
        'PUMP_OP_ST',           // 펌프작동상태
        'WT_PIPE_COR2',         // 소음발생여부(배관부식)
        'PUMP_FLOW',            // 펌프유량
        'WL_GEN_PUMP_COUNT',    // 펌프대수
        'FAC_STATUS',           // 시설상태
        'NOTUSE_REASON',        // 미사용사유
        'NOTUSE',               // 미사용
        'ALTER_FAC',            // 대체시설
        'OTHER',                // 기타사항
      ],
    ];

    // 데이터 행 추가 (외주출력 템플릿 기반 순서)
    for (var inspection in inspections) {
      // 날짜 형식 변환: "2025-11-06" → "20251106"
      String formattedDate = '';
      if (inspection.inspectDate != null && inspection.inspectDate!.isNotEmpty) {
        formattedDate = inspection.inspectDate!.replaceAll('-', '');
      }
      
      rows.add([
        inspection.wellId ?? '',                  // WELL_ID
        inspection.yangsuType ?? '',              // YANGSU_TYPE
        inspection.inspector ?? '',               // INSPECTOR
        formattedDate,                            // INSPECT_DATE (YYYYMMDD 형식)
        inspection.flowMeterYn ?? '',             // FLOW_METER_YN
        inspection.suwicheckpipeYn ?? '',         // SUWICHECKPIPE_YN
        inspection.chulsufacYn ?? '',             // CHULSUFAC_YN
        inspection.wlPondHeight2 ?? '',           // WL_POND_HEIGHT2
        inspection.flowMeterNum ?? '',            // FLOW_METER_NUM
        inspection.weighMeterId ?? '',            // WEIGH_METER_ID
        inspection.weighMeterNum ?? '',           // WEIGH_METER_NUM
        inspection.electricYn ?? '',              // ELECTRIC_YN
        inspection.watTemp ?? '',                 // WAT_TEMP
        inspection.junki ?? '',                   // JUNKI
        inspection.ph ?? '',                      // PH
        inspection.naturalLevel1 ?? '',           // NATURAL_LEVEL_1
        inspection.wlPumpDischarge1 ?? '',        // WL_PUMP_DISCHARGE_1
        inspection.frgSt ?? '',                   // FRG_ST
        inspection.prtCrkSt ?? '',                // PRT_CRK_ST
        inspection.prtLeakSt ?? '',               // PRT_LEAK_ST
        inspection.prtSsdSt ?? '',                // PRT_SSD_ST
        inspection.constDate2 ?? '',              // CONST_DATE2
        inspection.polprtCovcorSt ?? '',          // POLPRT_COVCOR_ST
        inspection.inspectorDept2 ?? '',          // INSPECTOR_DEPT2
        inspection.boonsu2 ?? '',                 // BOONSU2
        inspection.chkSphere2 ?? '',              // CHK_SPHERE2
        inspection.switchboxLook ?? '',           // SWITCHBOX_LOOK
        inspection.switchboxInst ?? '',           // SWITCHBOX_INST
        inspection.switchboxGr ?? '',             // SWITCHBOX_GR
        inspection.switchboxIr ?? '',             // SWITCHBOX_IR
        inspection.switchboxMov ?? '',            // SWITCHBOX_MOV
        inspection.pumpGr2 ?? '',                 // PUMP_GR2
        inspection.pumpIr ?? '',                  // PUMP_IR
        inspection.gpumpNoise2 ?? '',             // GPUMP_NOISE2
        inspection.gpumpGr2 ?? '',                // GPUMP_GR2
        inspection.gpumpIr2 ?? '',                // GPUMP_IR2
        inspection.switchboxLook2 ?? '',          // SWITCHBOX_LOOK2
        inspection.switchboxInst2 ?? '',          // SWITCHBOX_INST2
        inspection.switchboxGr2 ?? '',            // SWITCHBOX_GR2
        inspection.switchboxIr2 ?? '',            // SWITCHBOX_IR2
        inspection.pumpOpSt ?? '',                // PUMP_OP_ST
        inspection.wtPipeCor2 ?? '',              // WT_PIPE_COR2
        inspection.pumpFlow ?? '',                // PUMP_FLOW
        inspection.wlGenPumpCount ?? '',          // WL_GEN_PUMP_COUNT
        inspection.facStatus ?? '',               // FAC_STATUS
        inspection.notuseReason ?? '',            // NOTUSE_REASON
        inspection.notuse ?? '',                  // NOTUSE
        inspection.alterFac ?? '',                // ALTER_FAC
        inspection.other ?? '',                   // OTHER
      ]);
    }

    // CSV 문자열 생성
    String csv = const ListToCsvConverter().convert(rows);

    // UTF-8 BOM 추가 (한글 깨짐 방지)
    final bom = '\uFEFF'; // UTF-8 BOM 문자
    final csvWithBom = bom + csv;
    
    // UTF-8로 인코딩
    final bytes = utf8.encode(csvWithBom);
    
    // 파일 다운로드 (웹)
    final blob = html.Blob([bytes], 'text/csv;charset=utf-8');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'inspections_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.csv')
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  /// 표 형식 내보내기 (HTML 테이블)
  static Future<void> exportToTable(List<InspectionModel> inspections) async {
    if (inspections.isEmpty) {
      throw Exception('내보낼 데이터가 없습니다');
    }

    // HTML 테이블 생성
    StringBuffer htmlContent = StringBuffer();
    htmlContent.writeln('<!DOCTYPE html>');
    htmlContent.writeln('<html lang="ko">');
    htmlContent.writeln('<head>');
    htmlContent.writeln('  <meta charset="UTF-8">');
    htmlContent.writeln('  <meta name="viewport" content="width=device-width, initial-scale=1.0">');
    htmlContent.writeln('  <title>점검 이력</title>');
    htmlContent.writeln('  <style>');
    htmlContent.writeln('    body { font-family: "Malgun Gothic", sans-serif; margin: 20px; }');
    htmlContent.writeln('    h1 { color: #2196F3; }');
    htmlContent.writeln('    table { width: 100%; border-collapse: collapse; margin-top: 20px; }');
    htmlContent.writeln('    th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }');
    htmlContent.writeln('    th { background-color: #2196F3; color: white; font-weight: bold; }');
    htmlContent.writeln('    tr:nth-child(even) { background-color: #f9f9f9; }');
    htmlContent.writeln('    tr:hover { background-color: #f5f5f5; }');
    htmlContent.writeln('    .section-header { background-color: #e3f2fd; font-weight: bold; }');
    htmlContent.writeln('    @media print { button { display: none; } }');
    htmlContent.writeln('  </style>');
    htmlContent.writeln('</head>');
    htmlContent.writeln('<body>');
    htmlContent.writeln('  <h1>점검 이력</h1>');
    htmlContent.writeln('  <p>생성일시: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}</p>');
    htmlContent.writeln('  <button onclick="window.print()">인쇄하기</button>');

    for (var inspection in inspections) {
      htmlContent.writeln('  <h2>${inspection.wellId ?? "점검 데이터"}</h2>');
      htmlContent.writeln('  <table>');

      // 메타 정보
      htmlContent.writeln('    <tr class="section-header"><td colspan="2">메타 정보</td></tr>');
      if (inspection.id != null) {
        htmlContent.writeln('    <tr><th>ID</th><td>${inspection.id}</td></tr>');
      }
      if (inspection.createdAt != null) {
        htmlContent.writeln('    <tr><th>생성일시</th><td>${DateFormat('yyyy-MM-dd HH:mm').format(inspection.createdAt!)}</td></tr>');
      }
      if (inspection.updatedAt != null) {
        htmlContent.writeln('    <tr><th>수정일시</th><td>${DateFormat('yyyy-MM-dd HH:mm').format(inspection.updatedAt!)}</td></tr>');
      }

      // 기본정보
      htmlContent.writeln('    <tr class="section-header"><td colspan="2">① 기본정보</td></tr>');
      _addRow(htmlContent, '시설명', inspection.wellId);
      _addRow(htmlContent, '점검자', inspection.inspector);
      _addRow(htmlContent, '점검일자', inspection.inspectDate);
      _addRow(htmlContent, '양수장 형태', inspection.yangsuType);
      _addRow(htmlContent, '출입문', inspection.chkSphere2);
      _addRow(htmlContent, '장옥덮개', inspection.constDate2);
      _addRow(htmlContent, '부식도', inspection.polprtCovcorSt);
      _addRow(htmlContent, '관정덮개', inspection.boonsu2);
      _addRow(htmlContent, '스마트안내문', inspection.inspectorDept2);
      _addRow(htmlContent, '이물질', inspection.frgSt);
      _addRow(htmlContent, '균열', inspection.prtCrkSt);
      _addRow(htmlContent, '누수', inspection.prtLeakSt);
      _addRow(htmlContent, '침하', inspection.prtSsdSt);

      // 측정장치
      htmlContent.writeln('    <tr class="section-header"><td colspan="2">② 측정장치</td></tr>');
      _addRow(htmlContent, '유량계 유무', inspection.flowMeterYn);
      _addRow(htmlContent, '출수구 유무', inspection.chulsufacYn);
      _addRow(htmlContent, '수위확인관 유무', inspection.suwicheckpipeYn);
      _addRow(htmlContent, '수위', inspection.wlPondHeight2);
      _addRow(htmlContent, '전기 유무', inspection.electricYn);
      _addRow(htmlContent, '계량기 ID', inspection.weighMeterId);
      _addRow(htmlContent, '계량기 번호', inspection.weighMeterNum);
      _addRow(htmlContent, '토출량', inspection.wlPumpDischarge1);
      _addRow(htmlContent, '유량계 번호', inspection.flowMeterNum);
      _addRow(htmlContent, '수온', inspection.watTemp);
      _addRow(htmlContent, '전기전도도', inspection.junki);
      _addRow(htmlContent, 'pH', inspection.ph);
      _addRow(htmlContent, '자연수위', inspection.naturalLevel1);
      _addRow(htmlContent, '시설상태', inspection.facStatus);
      _addRow(htmlContent, '미사용사유', inspection.notuseReason);
      _addRow(htmlContent, '대체시설', inspection.alterFac);
      _addRow(htmlContent, '미사용', inspection.notuse);
      _addRow(htmlContent, '사용계속', inspection.useContinue);

      // 전기설비
      htmlContent.writeln('    <tr class="section-header"><td colspan="2">③ 전기설비</td></tr>');
      _addRow(htmlContent, '펌프 절연', inspection.pumpIr);
      _addRow(htmlContent, '배관 부식', inspection.wtPipeCor2);
      _addRow(htmlContent, '펌프 작동상태', inspection.pumpOpSt);
      _addRow(htmlContent, '펌프 대수', inspection.wlGenPumpCount);
      _addRow(htmlContent, '펌프 유량', inspection.pumpFlow);
      _addRow(htmlContent, '개폐기 외관', inspection.switchboxLook);
      _addRow(htmlContent, '개폐기 설치', inspection.switchboxInst);
      _addRow(htmlContent, '펌프 접지', inspection.pumpGr2);
      _addRow(htmlContent, '개폐기 접지', inspection.switchboxGr);
      _addRow(htmlContent, '개폐기 절연', inspection.switchboxIr);
      _addRow(htmlContent, '발전기 소음', inspection.gpumpNoise2);
      _addRow(htmlContent, '발전기 접지', inspection.gpumpGr2);
      _addRow(htmlContent, '발전기 절연', inspection.gpumpIr2);
      _addRow(htmlContent, '제어반 외관', inspection.switchboxLook2);
      _addRow(htmlContent, '제어반 설치', inspection.switchboxInst2);
      _addRow(htmlContent, '제어반 접지', inspection.switchboxGr2);
      _addRow(htmlContent, '제어반 절연', inspection.switchboxIr2);
      _addRow(htmlContent, '제어반 동작', inspection.switchboxMov);

      // 기타사항
      htmlContent.writeln('    <tr class="section-header"><td colspan="2">④ 기타사항</td></tr>');
      _addRow(htmlContent, '기타사항', inspection.other);

      htmlContent.writeln('  </table>');
      htmlContent.writeln('  <br>');
    }

    htmlContent.writeln('</body>');
    htmlContent.writeln('</html>');

    // HTML 파일 다운로드
    final bytes = utf8.encode(htmlContent.toString());
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'inspections_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.html')
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  static void _addRow(StringBuffer htmlContent, String label, String? value) {
    htmlContent.writeln('    <tr><th>$label</th><td>${value?.isNotEmpty == true ? value : '-'}</td></tr>');
  }
}
