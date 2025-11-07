import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/inspection_model.dart';
import 'inspection_form_screen.dart';

/// 점검 이력 상세 조회 화면 (엑셀 양식 기반 A4 한장 형식)
class InspectionDetailScreen extends StatelessWidget {
  final InspectionModel inspection;

  const InspectionDetailScreen({super.key, required this.inspection});

  /// 점검 데이터 삭제
  Future<void> _deleteInspection(BuildContext context) async {
    // 확인 다이얼로그
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('점검 데이터 삭제'),
        content: const Text('이 점검 데이터를 삭제하시겠습니까?\n삭제된 데이터는 복구할 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('삭제'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      // Hive에서 삭제
      if (inspection.key != null) {
        await inspection.delete();
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('점검 데이터가 삭제되었습니다'),
              backgroundColor: Colors.green,
            ),
          );

          // 이력 화면으로 돌아가기
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('삭제 실패: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: Text(inspection.wellId ?? '점검 상세'),
        centerTitle: true,
        actions: [
          // 인쇄 버튼 (PDF/이미지로 저장 가능)
          IconButton(
            icon: const Icon(Icons.print),
            tooltip: 'PDF로 저장',
            onPressed: () {
              // 웹 브라우저 인쇄 다이얼로그 호출
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('PDF로 저장'),
                  content: const Text(
                    '브라우저 인쇄 기능을 사용하여 PDF로 저장할 수 있습니다.\n\n'
                    '1. Ctrl+P (또는 Cmd+P) 를 누르세요\n'
                    '2. 대상을 "PDF로 저장"으로 선택\n'
                    '3. 저장 버튼을 클릭하세요',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('확인'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 제목
              _buildTitle(),
              const SizedBox(height: 16),
              
              // 기본정보 (시설명, 성명, 조사일자)
              _buildBasicInfo(),
              const SizedBox(height: 2),
              
              // 양수장 형태
              _buildSingleRow('양수장 형태', inspection.yangsuType),
              const SizedBox(height: 2),
              
              // 양수장 출입문
              _buildSingleRow('양수장 출입문', inspection.chkSphere2),
              const SizedBox(height: 2),
              
              // 양수장 장옥덮개 & 장옥덮개부식
              _buildDoubleRow(
                '양수장 장옥덮개', inspection.constDate2,
                '장옥덮개부식', inspection.polprtCovcorSt,
              ),
              const SizedBox(height: 2),
              
              // 스마트 안내문
              _buildSingleRow('스마트 안내문', inspection.inspectorDept2),
              const SizedBox(height: 2),
              
              // 관정덮개 & 이물질배출여부
              _buildDoubleRow(
                '관정덮개', inspection.boonsu2,
                '이물질배출여부', inspection.frgSt,
              ),
              const SizedBox(height: 2),
              
              // 섹션 헤더: 양수장 및 보호공
              _buildSectionHeader('양수장 및 보호공'),
              const SizedBox(height: 2),
              
              // 균열, 누수, 침하
              _buildTripleRow(
                '균열', inspection.prtCrkSt,
                '누수', inspection.prtLeakSt,
                '침하', inspection.prtSsdSt,
              ),
              const SizedBox(height: 2),
              
              // 유량계 & 유량계수치
              _buildDoubleRow(
                '유량계', inspection.flowMeterYn,
                '유량계수치', inspection.flowMeterNum,
              ),
              const SizedBox(height: 2),
              
              // 출수장치 & 수온
              _buildDoubleRow(
                '출수장치', inspection.chulsufacYn,
                '수온', inspection.watTemp,
              ),
              const SizedBox(height: 2),
              
              // 수위측정관 & EC
              _buildDoubleRow(
                '수위측정관', inspection.suwicheckpipeYn,
                'EC', inspection.junki,
              ),
              const SizedBox(height: 2),
              
              // 압력계 & pH
              _buildDoubleRow(
                '압력계', inspection.wlPondHeight2,
                'pH', inspection.ph,
              ),
              const SizedBox(height: 2),
              
              // 한전전기 & 자연수위
              _buildDoubleRow(
                '한전전기', inspection.electricYn,
                '자연수위', inspection.naturalLevel1,
              ),
              const SizedBox(height: 2),
              
              // 한전계량기 & 채수량
              _buildDoubleRow(
                '한전계량기', inspection.weighMeterId,
                '채수량', inspection.wlPumpDischarge1,
              ),
              const SizedBox(height: 2),
              
              // 누적사용량
              _buildSingleRow('누적사용량', inspection.weighMeterNum),
              const SizedBox(height: 2),
              
              // 이용상태 & 미활용원인
              _buildDoubleRow(
                '이용상태', inspection.facStatus,
                '미활용원인', inspection.notuseReason,
              ),
              const SizedBox(height: 2),
              
              // 현재시설 & 미활용공처리방안
              _buildDoubleRow(
                '현재시설', inspection.useContinue,
                '미활용공처리방안', inspection.notuse,
              ),
              const SizedBox(height: 2),
              
              // 대체시설
              _buildSingleRow('대체시설', inspection.alterFac),
              const SizedBox(height: 2),
              
              // 섹션 헤더: 수중모터
              _buildSectionHeader('수중모터'),
              const SizedBox(height: 2),
              
              // 절연저항
              _buildSingleRow('절연저항', inspection.pumpIr),
              const SizedBox(height: 2),
              
              // 소음발생여부
              _buildSingleRow('소음발생여부', inspection.gpumpNoise2),
              const SizedBox(height: 2),
              
              // 작동상태
              _buildSingleRow('작동상태', inspection.pumpOpSt),
              const SizedBox(height: 2),
              
              // 섹션 헤더: 배전함 / 배전반
              _buildSectionHeader('배전함 / 배전반'),
              const SizedBox(height: 2),
              
              // 배전함외형 & 설치
              _buildDoubleRow(
                '배전함외형', inspection.switchboxLook,
                '설치', inspection.switchboxInst,
              ),
              const SizedBox(height: 2),
              
              // 전기연결
              _buildSingleRow('전기연결', inspection.pumpGr2),
              const SizedBox(height: 2),
              
              // 접지단자 & 절연단자
              _buildDoubleRow(
                '접지단자', inspection.switchboxGr,
                '절연단자', inspection.switchboxIr,
              ),
              const SizedBox(height: 2),
              
              // 전압계 & 지시전압
              _buildDoubleRow(
                '전압계', inspection.switchboxLook2,
                '지시전압', inspection.switchboxInst2,
              ),
              const SizedBox(height: 2),
              
              // 전류계 & 지시전류
              _buildDoubleRow(
                '전류계', inspection.switchboxGr2,
                '지시전류', inspection.switchboxIr2,
              ),
              const SizedBox(height: 2),
              
              // 배전반동작
              _buildSingleRow('배전반동작', inspection.switchboxMov),
              const SizedBox(height: 2),
              
              // 섹션 헤더: 계기류고장
              _buildSectionHeader('계기류고장'),
              const SizedBox(height: 2),
              
              // 휴즈, floatless, EOCR
              _buildTripleRow(
                '휴즈', inspection.gpumpGr2,
                'floatless', inspection.gpumpIr2,
                'EOCR', inspection.pumpFlow,
              ),
              const SizedBox(height: 2),
              
              // 마그네틱 & 램프
              _buildDoubleRow(
                '마그네틱', inspection.wtPipeCor2,
                '램프', inspection.wlGenPumpCount,
              ),
              const SizedBox(height: 2),
              
              // 기타사항
              _buildMultilineRow('기타사항', inspection.other),
              
              const SizedBox(height: 24),
              
              // 저장 정보
              _buildMetaInfo(dateFormat),
            ],
          ),
        ),
      ),
      // 하단 수정/삭제 버튼
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // 수정하기 버튼
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // InspectionFormScreen으로 이동 (편집 모드)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InspectionFormScreen(
                          inspection: inspection,
                          isReadOnly: false, // 편집 모드
                        ),
                      ),
                    ).then((_) {
                      // 수정 완료 후 돌아올 때 화면 새로고침
                      // (Navigator.pop으로 자동 새로고침됨)
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.edit, size: 20),
                      SizedBox(width: 8),
                      Text(
                        '수정하기',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // 삭제하기 버튼
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _deleteInspection(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete, size: 20),
                      SizedBox(width: 8),
                      Text(
                        '삭제하기',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 제목
  Widget _buildTitle() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[700],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        '농업용 공공관정 정기점검',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// 기본정보 (시설명, 성명, 조사일자)
  Widget _buildBasicInfo() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[400]!),
      ),
      child: Row(
        children: [
          // 시설명
          _buildInfoCell('시설명', inspection.wellId, flex: 2),
          Container(width: 1, color: Colors.grey[400]),
          // 성명
          _buildInfoCell('성명', inspection.inspector, flex: 2),
          Container(width: 1, color: Colors.grey[400]),
          // 조사일자
          _buildInfoCell('조사일자', inspection.inspectDate, flex: 2),
        ],
      ),
    );
  }

  Widget _buildInfoCell(String label, String? value, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border(bottom: BorderSide(color: Colors.grey[400]!)),
            ),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            child: Text(
              value?.isNotEmpty == true ? value! : '-',
              style: const TextStyle(fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  /// 한 줄 (라벨 + 값)
  Widget _buildSingleRow(String label, String? value) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[400]!),
      ),
      child: Row(
        children: [
          Container(
            width: 120,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border(right: BorderSide(color: Colors.grey[400]!)),
            ),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Text(
                value?.isNotEmpty == true ? value! : '-',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 두 컬럼 (라벨1 + 값1 | 라벨2 + 값2)
  Widget _buildDoubleRow(String label1, String? value1, String label2, String? value2) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[400]!),
      ),
      child: Row(
        children: [
          // 첫 번째 컬럼
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 100,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border(right: BorderSide(color: Colors.grey[400]!)),
                  ),
                  child: Text(
                    label1,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      value1?.isNotEmpty == true ? value1! : '-',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(width: 1, color: Colors.grey[400]),
          // 두 번째 컬럼
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 100,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border(right: BorderSide(color: Colors.grey[400]!)),
                  ),
                  child: Text(
                    label2,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      value2?.isNotEmpty == true ? value2! : '-',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 세 컬럼 (라벨1 + 값1 | 라벨2 + 값2 | 라벨3 + 값3)
  Widget _buildTripleRow(
    String label1, String? value1,
    String label2, String? value2,
    String label3, String? value3,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[400]!),
      ),
      child: Row(
        children: [
          // 첫 번째 컬럼
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 70,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border(right: BorderSide(color: Colors.grey[400]!)),
                  ),
                  child: Text(
                    label1,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      value1?.isNotEmpty == true ? value1! : '-',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(width: 1, color: Colors.grey[400]),
          // 두 번째 컬럼
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 70,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border(right: BorderSide(color: Colors.grey[400]!)),
                  ),
                  child: Text(
                    label2,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      value2?.isNotEmpty == true ? value2! : '-',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(width: 1, color: Colors.grey[400]),
          // 세 번째 컬럼
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 70,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border(right: BorderSide(color: Colors.grey[400]!)),
                  ),
                  child: Text(
                    label3,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      value3?.isNotEmpty == true ? value3! : '-',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 섹션 헤더
  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[100],
        border: Border.all(color: Colors.grey[400]!),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// 여러 줄 입력 (기타사항)
  Widget _buildMultilineRow(String label, String? value) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[400]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border(bottom: BorderSide(color: Colors.grey[400]!)),
            ),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            constraints: const BoxConstraints(minHeight: 80),
            child: Text(
              value?.isNotEmpty == true ? value! : '-',
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaInfo(DateFormat dateFormat) {
    return Card(
      elevation: 2,
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  '저장 정보',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (inspection.id != null)
              Text('ID: ${inspection.id}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
            if (inspection.createdAt != null)
              Text('생성: ${dateFormat.format(inspection.createdAt!)}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
            if (inspection.updatedAt != null)
              Text('수정: ${dateFormat.format(inspection.updatedAt!)}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
