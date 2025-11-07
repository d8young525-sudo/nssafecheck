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

  /// 표 형식 내보내기 (HTML 테이블) - 시설별 개별 파일로 저장
  /// 상세 페이지의 엑셀 기반 A4 양식을 HTML로 복제
  static Future<void> exportToTable(List<InspectionModel> inspections) async {
    if (inspections.isEmpty) {
      throw Exception('내보낼 데이터가 없습니다');
    }

    // 각 시설별로 개별 HTML 파일 생성 및 다운로드
    for (var inspection in inspections) {
      // HTML 생성
      StringBuffer htmlContent = StringBuffer();
      htmlContent.writeln('<!DOCTYPE html>');
      htmlContent.writeln('<html lang="ko">');
      htmlContent.writeln('<head>');
      htmlContent.writeln('  <meta charset="UTF-8">');
      htmlContent.writeln('  <meta name="viewport" content="width=device-width, initial-scale=1.0">');
      htmlContent.writeln('  <title>${inspection.wellId ?? "점검"} - 농업용 공공관정 정기점검</title>');
      htmlContent.writeln('  <style>');
      htmlContent.writeln('    body { font-family: "Malgun Gothic", "맑은 고딕", sans-serif; margin: 0; padding: 0; }');
      htmlContent.writeln('    .container { max-width: 210mm; margin: 0 auto; padding: 10mm; box-sizing: border-box; }');
      
      // 제목 스타일 (A4 최적화 - 작게)
      htmlContent.writeln('    .title { background-color: #1976D2; color: white; padding: 8px; border-radius: 4px; text-align: center; font-size: 16px; font-weight: bold; margin-bottom: 6px; }');
      
      // 테이블 기본 스타일
      htmlContent.writeln('    table { width: 100%; border-collapse: collapse; margin-bottom: 1px; }');
      htmlContent.writeln('    td { border: 1px solid #BDBDBD; padding: 4px 6px; font-size: 10px; }');
      htmlContent.writeln('    .label { background-color: #EEEEEE; font-weight: 600; font-size: 9px; }');
      htmlContent.writeln('    .value { background-color: white; }');
      
      // 기본정보 3컬럼 그리드 (압축)
      htmlContent.writeln('    .basic-info { display: table; width: 100%; border: 1px solid #BDBDBD; margin-bottom: 1px; }');
      htmlContent.writeln('    .basic-cell { display: table-cell; width: 33.33%; text-align: center; border-right: 1px solid #BDBDBD; }');
      htmlContent.writeln('    .basic-cell:last-child { border-right: none; }');
      htmlContent.writeln('    .basic-label { background-color: #EEEEEE; padding: 4px; border-bottom: 1px solid #BDBDBD; font-weight: bold; font-size: 10px; }');
      htmlContent.writeln('    .basic-value { padding: 4px; font-size: 10px; }');
      
      // 섹션 헤더 (압축)
      htmlContent.writeln('    .section-header { background-color: #BBDEFB; border: 1px solid #BDBDBD; padding: 4px; text-align: center; font-weight: bold; font-size: 11px; color: #1976D2; margin-bottom: 1px; }');
      
      // 싱글 로우 (라벨 80px로 축소)
      htmlContent.writeln('    .single-row { display: table; width: 100%; border: 1px solid #BDBDBD; margin-bottom: 1px; }');
      htmlContent.writeln('    .single-label { display: table-cell; width: 80px; background-color: #EEEEEE; padding: 4px 6px; font-weight: 600; font-size: 9px; border-right: 1px solid #BDBDBD; }');
      htmlContent.writeln('    .single-value { display: table-cell; padding: 4px 6px; font-size: 10px; }');
      
      // 더블 로우 (각 라벨 70px로 축소)
      htmlContent.writeln('    .double-row { display: table; width: 100%; border: 1px solid #BDBDBD; margin-bottom: 1px; }');
      htmlContent.writeln('    .double-col { display: table-cell; width: 50%; border-right: 1px solid #BDBDBD; }');
      htmlContent.writeln('    .double-col:last-child { border-right: none; }');
      htmlContent.writeln('    .double-label { display: inline-block; width: 70px; background-color: #EEEEEE; padding: 4px 6px; font-weight: 600; font-size: 9px; border-right: 1px solid #BDBDBD; vertical-align: top; }');
      htmlContent.writeln('    .double-value { display: inline-block; padding: 4px 6px; font-size: 10px; vertical-align: top; }');
      
      // 트리플 로우 (각 라벨 50px로 축소)
      htmlContent.writeln('    .triple-row { display: table; width: 100%; border: 1px solid #BDBDBD; margin-bottom: 1px; }');
      htmlContent.writeln('    .triple-col { display: table-cell; width: 33.33%; border-right: 1px solid #BDBDBD; }');
      htmlContent.writeln('    .triple-col:last-child { border-right: none; }');
      htmlContent.writeln('    .triple-label { display: inline-block; width: 50px; background-color: #EEEEEE; padding: 4px 6px; font-weight: 600; font-size: 9px; border-right: 1px solid #BDBDBD; vertical-align: top; }');
      htmlContent.writeln('    .triple-value { display: inline-block; padding: 4px 6px; font-size: 10px; vertical-align: top; }');
      
      // 멀티라인 로우 (기타사항 - 압축)
      htmlContent.writeln('    .multiline-row { border: 1px solid #BDBDBD; margin-bottom: 1px; }');
      htmlContent.writeln('    .multiline-label { background-color: #EEEEEE; padding: 4px 6px; font-weight: 600; font-size: 9px; border-bottom: 1px solid #BDBDBD; }');
      htmlContent.writeln('    .multiline-value { padding: 4px 6px; min-height: 40px; font-size: 10px; }');
      
      // 메타 정보 (압축)
      htmlContent.writeln('    .meta-info { background-color: #E3F2FD; border: 1px solid #BBDEFB; border-radius: 4px; padding: 8px; margin-top: 8px; }');
      htmlContent.writeln('    .meta-title { color: #1976D2; font-weight: bold; font-size: 11px; margin-bottom: 4px; }');
      htmlContent.writeln('    .meta-text { font-size: 9px; color: #757575; margin: 2px 0; }');
      
      // A4 인쇄 설정
      htmlContent.writeln('    @media print { ');
      htmlContent.writeln('      @page { size: A4 portrait; margin: 10mm; } ');
      htmlContent.writeln('      body { margin: 0; padding: 0; }');
      htmlContent.writeln('      .container { padding: 0; max-width: 100%; }');
      htmlContent.writeln('    }');
      htmlContent.writeln('  </style>');
      htmlContent.writeln('</head>');
      htmlContent.writeln('<body>');
      htmlContent.writeln('  <div class="container">');
      
      // 제목
      htmlContent.writeln('    <div class="title">농업용 공공관정 정기점검</div>');
      
      // 기본정보 (시설명, 성명, 조사일자)
      htmlContent.writeln('    <div class="basic-info">');
      htmlContent.writeln('      <div class="basic-cell">');
      htmlContent.writeln('        <div class="basic-label">시설명</div>');
      htmlContent.writeln('        <div class="basic-value">${_formatValue(inspection.wellId)}</div>');
      htmlContent.writeln('      </div>');
      htmlContent.writeln('      <div class="basic-cell">');
      htmlContent.writeln('        <div class="basic-label">성명</div>');
      htmlContent.writeln('        <div class="basic-value">${_formatValue(inspection.inspector)}</div>');
      htmlContent.writeln('      </div>');
      htmlContent.writeln('      <div class="basic-cell">');
      htmlContent.writeln('        <div class="basic-label">조사일자</div>');
      htmlContent.writeln('        <div class="basic-value">${_formatValue(inspection.inspectDate)}</div>');
      htmlContent.writeln('      </div>');
      htmlContent.writeln('    </div>');
      
      // 양수장 형태
      _addSingleRow(htmlContent, '양수장 형태', inspection.yangsuType);
      
      // 양수장 출입문
      _addSingleRow(htmlContent, '양수장 출입문', inspection.chkSphere2);
      
      // 양수장 장옥덮개 & 장옥덮개부식
      _addDoubleRow(htmlContent, '양수장 장옥덮개', inspection.constDate2, '장옥덮개부식', inspection.polprtCovcorSt);
      
      // 스마트 안내문
      _addSingleRow(htmlContent, '스마트 안내문', inspection.inspectorDept2);
      
      // 관정덮개 & 이물질배출여부
      _addDoubleRow(htmlContent, '관정덮개', inspection.boonsu2, '이물질배출여부', inspection.frgSt);
      
      // 섹션: 양수장 및 보호공
      htmlContent.writeln('    <div class="section-header">양수장 및 보호공</div>');
      
      // 균열, 누수, 침하
      _addTripleRow(htmlContent, '균열', inspection.prtCrkSt, '누수', inspection.prtLeakSt, '침하', inspection.prtSsdSt);
      
      // 유량계 & 유량계수치
      _addDoubleRow(htmlContent, '유량계', inspection.flowMeterYn, '유량계수치', inspection.flowMeterNum);
      
      // 출수장치 & 수온
      _addDoubleRow(htmlContent, '출수장치', inspection.chulsufacYn, '수온', inspection.watTemp);
      
      // 수위측정관 & EC
      _addDoubleRow(htmlContent, '수위측정관', inspection.suwicheckpipeYn, 'EC', inspection.junki);
      
      // 압력계 & pH
      _addDoubleRow(htmlContent, '압력계', inspection.wlPondHeight2, 'pH', inspection.ph);
      
      // 한전전기 & 자연수위
      _addDoubleRow(htmlContent, '한전전기', inspection.electricYn, '자연수위', inspection.naturalLevel1);
      
      // 한전계량기 & 채수량
      _addDoubleRow(htmlContent, '한전계량기', inspection.weighMeterId, '채수량', inspection.wlPumpDischarge1);
      
      // 누적사용량
      _addSingleRow(htmlContent, '누적사용량', inspection.weighMeterNum);
      
      // 이용상태 & 미활용원인
      _addDoubleRow(htmlContent, '이용상태', inspection.facStatus, '미활용원인', inspection.notuseReason);
      
      // 현재시설 & 미활용공처리방안
      _addDoubleRow(htmlContent, '현재시설', inspection.useContinue, '미활용공처리방안', inspection.notuse);
      
      // 대체시설
      _addSingleRow(htmlContent, '대체시설', inspection.alterFac);
      
      // 섹션: 수중모터
      htmlContent.writeln('    <div class="section-header">수중모터</div>');
      
      // 절연저항
      _addSingleRow(htmlContent, '절연저항', inspection.pumpIr);
      
      // 소음발생여부
      _addSingleRow(htmlContent, '소음발생여부', inspection.gpumpNoise2);
      
      // 작동상태
      _addSingleRow(htmlContent, '작동상태', inspection.pumpOpSt);
      
      // 섹션: 배전함 / 배전반
      htmlContent.writeln('    <div class="section-header">배전함 / 배전반</div>');
      
      // 배전함외형 & 설치
      _addDoubleRow(htmlContent, '배전함외형', inspection.switchboxLook, '설치', inspection.switchboxInst);
      
      // 전기연결
      _addSingleRow(htmlContent, '전기연결', inspection.pumpGr2);
      
      // 접지단자 & 절연단자
      _addDoubleRow(htmlContent, '접지단자', inspection.switchboxGr, '절연단자', inspection.switchboxIr);
      
      // 전압계 & 지시전압
      _addDoubleRow(htmlContent, '전압계', inspection.switchboxLook2, '지시전압', inspection.switchboxInst2);
      
      // 전류계 & 지시전류
      _addDoubleRow(htmlContent, '전류계', inspection.switchboxGr2, '지시전류', inspection.switchboxIr2);
      
      // 배전반동작
      _addSingleRow(htmlContent, '배전반동작', inspection.switchboxMov);
      
      // 섹션: 계기류고장
      htmlContent.writeln('    <div class="section-header">계기류고장</div>');
      
      // 휴즈, floatless, EOCR
      _addTripleRow(htmlContent, '휴즈', inspection.gpumpGr2, 'floatless', inspection.gpumpIr2, 'EOCR', inspection.pumpFlow);
      
      // 마그네틱 & 램프
      _addDoubleRow(htmlContent, '마그네틱', inspection.wtPipeCor2, '램프', inspection.wlGenPumpCount);
      
      // 기타사항
      _addMultilineRow(htmlContent, '기타사항', inspection.other);
      
      // 저장 정보
      htmlContent.writeln('    <div class="meta-info">');
      htmlContent.writeln('      <div class="meta-title">저장 정보</div>');
      if (inspection.id != null) {
        htmlContent.writeln('      <div class="meta-text">ID: ${inspection.id}</div>');
      }
      if (inspection.createdAt != null) {
        htmlContent.writeln('      <div class="meta-text">생성: ${DateFormat('yyyy-MM-dd HH:mm').format(inspection.createdAt!)}</div>');
      }
      if (inspection.updatedAt != null) {
        htmlContent.writeln('      <div class="meta-text">수정: ${DateFormat('yyyy-MM-dd HH:mm').format(inspection.updatedAt!)}</div>');
      }
      htmlContent.writeln('    </div>');
      
      htmlContent.writeln('  </div>');
      htmlContent.writeln('</body>');
      htmlContent.writeln('</html>');

      // 시설명을 파일명으로 사용 (특수문자 제거)
      String fileName = inspection.wellId ?? 'inspection';
      // 파일명에 사용할 수 없는 문자 제거
      fileName = fileName.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');
      
      // HTML 파일 다운로드
      final bytes = utf8.encode(htmlContent.toString());
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', '$fileName.html')
        ..click();
      html.Url.revokeObjectUrl(url);
      
      // 연속 다운로드를 위한 짧은 대기
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }
  
  /// 값 포맷팅 헬퍼 (null 또는 빈 값을 '-'로 표시)
  static String _formatValue(String? value) {
    return value?.isNotEmpty == true ? value! : '-';
  }
  
  /// 싱글 로우 생성
  static void _addSingleRow(StringBuffer html, String label, String? value) {
    html.writeln('    <div class="single-row">');
    html.writeln('      <div class="single-label">$label</div>');
    html.writeln('      <div class="single-value">${_formatValue(value)}</div>');
    html.writeln('    </div>');
  }
  
  /// 더블 로우 생성
  static void _addDoubleRow(StringBuffer html, String label1, String? value1, String label2, String? value2) {
    html.writeln('    <div class="double-row">');
    html.writeln('      <div class="double-col">');
    html.writeln('        <span class="double-label">$label1</span>');
    html.writeln('        <span class="double-value">${_formatValue(value1)}</span>');
    html.writeln('      </div>');
    html.writeln('      <div class="double-col">');
    html.writeln('        <span class="double-label">$label2</span>');
    html.writeln('        <span class="double-value">${_formatValue(value2)}</span>');
    html.writeln('      </div>');
    html.writeln('    </div>');
  }
  
  /// 트리플 로우 생성
  static void _addTripleRow(StringBuffer html, String label1, String? value1, String label2, String? value2, String label3, String? value3) {
    html.writeln('    <div class="triple-row">');
    html.writeln('      <div class="triple-col">');
    html.writeln('        <span class="triple-label">$label1</span>');
    html.writeln('        <span class="triple-value">${_formatValue(value1)}</span>');
    html.writeln('      </div>');
    html.writeln('      <div class="triple-col">');
    html.writeln('        <span class="triple-label">$label2</span>');
    html.writeln('        <span class="triple-value">${_formatValue(value2)}</span>');
    html.writeln('      </div>');
    html.writeln('      <div class="triple-col">');
    html.writeln('        <span class="triple-label">$label3</span>');
    html.writeln('        <span class="triple-value">${_formatValue(value3)}</span>');
    html.writeln('      </div>');
    html.writeln('    </div>');
  }
  
  /// 멀티라인 로우 생성 (기타사항)
  static void _addMultilineRow(StringBuffer html, String label, String? value) {
    html.writeln('    <div class="multiline-row">');
    html.writeln('      <div class="multiline-label">$label</div>');
    html.writeln('      <div class="multiline-value">${_formatValue(value)}</div>');
    html.writeln('    </div>');
  }

}
