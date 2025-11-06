import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/inspection_model.dart';
import 'inspection_form_screen.dart';

/// 점검 이력 상세 조회 화면 (읽기 전용)
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 메타 정보
            _buildMetaInfo(dateFormat),

            const SizedBox(height: 24),

            // Page 1: 기본정보
            _buildSection('① 기본정보', [
              _buildField('시설명', inspection.wellId),
              _buildField('점검자', inspection.inspector),
              _buildField('점검일자', inspection.inspectDate),
              _buildField('양수장 형태', inspection.yangsuType),
              _buildField('출입문', inspection.chkSphere2),
              _buildField('장옥덮개', inspection.constDate2),
              _buildField('부식도', inspection.polprtCovcorSt),
              _buildField('관정덮개', inspection.boonsu2),
              _buildField('스마트안내문', inspection.inspectorDept2),
              _buildField('이물질', inspection.frgSt),
              _buildField('균열', inspection.prtCrkSt),
              _buildField('누수', inspection.prtLeakSt),
              _buildField('침하', inspection.prtSsdSt),
            ]),

            const SizedBox(height: 16),

            // Page 2: 측정장치
            _buildSection('② 측정장치', [
              _buildField('유량계 유무', inspection.flowMeterYn),
              _buildField('출수구 유무', inspection.chulsufacYn),
              _buildField('수위확인관 유무', inspection.suwicheckpipeYn),
              _buildField('수위', inspection.wlPondHeight2),
              _buildField('전기 유무', inspection.electricYn),
              _buildField('계량기 ID', inspection.weighMeterId),
              _buildField('계량기 번호', inspection.weighMeterNum),
              _buildField('토출량', inspection.wlPumpDischarge1),
              _buildField('유량계 번호', inspection.flowMeterNum),
              _buildField('수온', inspection.watTemp),
              _buildField('전기전도도', inspection.junki),
              _buildField('pH', inspection.ph),
              _buildField('자연수위', inspection.naturalLevel1),
              _buildField('시설상태', inspection.facStatus),
              _buildField('미사용사유', inspection.notuseReason),
              _buildField('대체시설', inspection.alterFac),
              _buildField('미사용', inspection.notuse),
              _buildField('사용계속', inspection.useContinue),
            ]),

            const SizedBox(height: 16),

            // Page 3: 전기설비
            _buildSection('③ 전기설비', [
              _buildField('펌프 절연', inspection.pumpIr),
              _buildField('배관 부식', inspection.wtPipeCor2),
              _buildField('펌프 작동상태', inspection.pumpOpSt),
              _buildField('펌프 대수', inspection.wlGenPumpCount),
              _buildField('펌프 유량', inspection.pumpFlow),
              _buildField('개폐기 외관', inspection.switchboxLook),
              _buildField('개폐기 설치', inspection.switchboxInst),
              _buildField('펌프 접지', inspection.pumpGr2),
              _buildField('개폐기 접지', inspection.switchboxGr),
              _buildField('개폐기 절연', inspection.switchboxIr),
              _buildField('발전기 소음', inspection.gpumpNoise2),
              _buildField('발전기 접지', inspection.gpumpGr2),
              _buildField('발전기 절연', inspection.gpumpIr2),
              _buildField('제어반 외관', inspection.switchboxLook2),
              _buildField('제어반 설치', inspection.switchboxInst2),
              _buildField('제어반 접지', inspection.switchboxGr2),
              _buildField('제어반 절연', inspection.switchboxIr2),
              _buildField('제어반 동작', inspection.switchboxMov),
            ]),

            const SizedBox(height: 16),

            // Page 4: 기타사항
            _buildSection('④ 기타사항', [
              _buildField('기타사항', inspection.other, maxLines: 5),
            ]),
          ],
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

  Widget _buildMetaInfo(DateFormat dateFormat) {
    return Card(
      elevation: 2,
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.blue),
                const SizedBox(width: 8),
                const Text(
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

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, String? value, {int maxLines = 1}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 1),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!, width: 1),
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 필드명 (왼쪽 - 배경색)
          Container(
            width: 140,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border(
                right: BorderSide(color: Colors.grey[300]!, width: 1),
              ),
            ),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          // 값 (오른쪽)
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Text(
                value?.isNotEmpty == true ? value! : '-',
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                ),
                maxLines: maxLines,
              ),
            ),
          ),
        ],
      ),
    );
  }

}
