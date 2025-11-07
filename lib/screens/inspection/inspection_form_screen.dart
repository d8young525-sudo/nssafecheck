import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../viewmodels/inspection_viewmodel.dart';
import '../../models/inspection_model.dart';
import 'pages/inspection_page1.dart';
import 'pages/inspection_page2.dart';
import 'pages/inspection_page3.dart';
import 'pages/inspection_page4.dart';

/// 점검입력 메인 화면 - 4개 페이지를 TabView로 구성
/// Kotlin의 ViewPager + 4 Fragments 구조를 Flutter로 구현
class InspectionFormScreen extends StatefulWidget {
  final InspectionModel? inspection; // 기존 데이터 (수정용)
  final bool isReadOnly; // 읽기 전용 모드 (기본값: false - 편집 가능)
  
  const InspectionFormScreen({
    super.key,
    this.inspection,
    this.isReadOnly = false,
  });

  @override
  State<InspectionFormScreen> createState() => _InspectionFormScreenState();
}

class _InspectionFormScreenState extends State<InspectionFormScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late InspectionViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _viewModel = InspectionViewModel();

    // 기존 데이터가 있으면 ViewModel에 로드
    if (widget.inspection != null) {
      _loadExistingData(widget.inspection!);
    } else {
      // 새로운 점검일 경우 오늘 날짜 자동 설정
      DateTime now = DateTime.now();
      _viewModel.inspectDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      
      // 임시저장 데이터 확인
      _checkDraftData();
    }
  }

  /// 기존 점검 데이터를 ViewModel에 로드
  void _loadExistingData(InspectionModel inspection) {
    _viewModel.wellId = inspection.wellId;
    _viewModel.yangsuType = inspection.yangsuType;
    _viewModel.inspector = inspection.inspector;
    _viewModel.inspectDate = inspection.inspectDate;
    _viewModel.flowMeterYn = inspection.flowMeterYn;
    _viewModel.suwicheckpipeYn = inspection.suwicheckpipeYn;
    _viewModel.chulsufacYn = inspection.chulsufacYn;
    _viewModel.wlPondHeight2 = inspection.wlPondHeight2;
    _viewModel.flowMeterNum = inspection.flowMeterNum;
    _viewModel.weighMeterId = inspection.weighMeterId;
    _viewModel.weighMeterNum = inspection.weighMeterNum;
    _viewModel.electricYn = inspection.electricYn;
    _viewModel.watTemp = inspection.watTemp;
    _viewModel.junki = inspection.junki;
    _viewModel.ph = inspection.ph;
    _viewModel.naturalLevel1 = inspection.naturalLevel1;
    _viewModel.wlPumpDischarge1 = inspection.wlPumpDischarge1;
    _viewModel.frgSt = inspection.frgSt;
    _viewModel.prtCrkSt = inspection.prtCrkSt;
    _viewModel.prtLeakSt = inspection.prtLeakSt;
    _viewModel.prtSsdSt = inspection.prtSsdSt;
    _viewModel.constDate2 = inspection.constDate2;
    _viewModel.polprtCovcorSt = inspection.polprtCovcorSt;
    _viewModel.inspectorDept2 = inspection.inspectorDept2;
    _viewModel.boonsu2 = inspection.boonsu2;
    _viewModel.chkSphere2 = inspection.chkSphere2;
    _viewModel.switchboxLook = inspection.switchboxLook;
    _viewModel.switchboxInst = inspection.switchboxInst;
    _viewModel.switchboxGr = inspection.switchboxGr;
    _viewModel.switchboxIr = inspection.switchboxIr;
    _viewModel.switchboxMov = inspection.switchboxMov;
    _viewModel.pumpGr2 = inspection.pumpGr2;
    _viewModel.pumpIr = inspection.pumpIr;
    _viewModel.gpumpNoise2 = inspection.gpumpNoise2;
    _viewModel.gpumpGr2 = inspection.gpumpGr2;
    _viewModel.gpumpIr2 = inspection.gpumpIr2;
    _viewModel.switchboxLook2 = inspection.switchboxLook2;
    _viewModel.switchboxInst2 = inspection.switchboxInst2;
    _viewModel.switchboxGr2 = inspection.switchboxGr2;
    _viewModel.switchboxIr2 = inspection.switchboxIr2;
    _viewModel.pumpOpSt = inspection.pumpOpSt;
    _viewModel.wtPipeCor2 = inspection.wtPipeCor2;
    _viewModel.pumpFlow = inspection.pumpFlow;
    _viewModel.wlGenPumpCount = inspection.wlGenPumpCount;
    _viewModel.facStatus = inspection.facStatus;
    _viewModel.notuseReason = inspection.notuseReason;
    _viewModel.notuse = inspection.notuse;
    _viewModel.alterFac = inspection.alterFac;
    _viewModel.other = inspection.other;
    _viewModel.useContinue = inspection.useContinue;
  }

  @override
  void dispose() {
    // 화면 나갈 때 자동 임시저장
    _autoSaveDraft();
    _tabController.dispose();
    super.dispose();
  }

  /// 자동 임시저장 (화면 나갈 때)
  Future<void> _autoSaveDraft() async {
    try {
      // 새 점검 작성 중일 때만 임시저장
      if (widget.inspection != null) return;
      
      // 입력된 데이터가 있는지 확인 (오늘일자와 점검자만 있는 경우는 제외)
      // 실제 점검 데이터가 입력되었는지 확인
      final hasRealData = _viewModel.wellId != null ||
          _viewModel.yangsuType != null ||
          _viewModel.flowMeterYn != null ||
          _viewModel.suwicheckpipeYn != null ||
          _viewModel.chulsufacYn != null ||
          _viewModel.pumpIr != null ||
          _viewModel.other != null ||
          _viewModel.watTemp != null ||
          _viewModel.ph != null ||
          _viewModel.facStatus != null;

      if (!hasRealData) return;

      final prefs = await SharedPreferences.getInstance();
      
      // ViewModel의 모든 데이터를 Firestore 형식으로 변환
      final data = _viewModel.toFirestore();
      data['savedAt'] = DateTime.now().toIso8601String();
      
      final jsonString = jsonEncode(data);
      await prefs.setString('inspection_draft', jsonString);
    } catch (e) {
      // 오류 무시 (임시저장 실패해도 앱 동작에 문제 없음)
    }
  }

  /// 임시저장 데이터 확인 및 불러오기 제안
  Future<void> _checkDraftData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final draftJson = prefs.getString('inspection_draft');
      
      if (draftJson != null && draftJson.isNotEmpty) {
        if (!mounted) return;
        
        bool? shouldLoad = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('임시저장 데이터'),
            content: const Text('입력하던 점검 데이터가 있습니다.\n불러오시겠습니까?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('새로 작성'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('불러오기'),
              ),
            ],
          ),
        );

        if (shouldLoad == true) {
          _loadDraftData(draftJson);
        } else {
          await prefs.remove('inspection_draft');
        }
      }
    } catch (e) {
      // 오류 무시
    }
  }

  /// 임시저장 데이터 불러오기
  void _loadDraftData(String jsonString) {
    try {
      final Map<String, dynamic> data = jsonDecode(jsonString);
      
      // ViewModel에 데이터 복원
      if (data['basicInfo'] != null) {
        final basic = data['basicInfo'];
        _viewModel.wellId = basic['WELL_ID'];
        _viewModel.inspector = basic['INSPECTOR'];
        _viewModel.inspectDate = basic['INSPECT_DATE'];
        _viewModel.yangsuType = basic['YANGSU_TYPE'];
        _viewModel.chkSphere2 = basic['CHK_SPHERE2'];
        _viewModel.constDate2 = basic['CONST_DATE2'];
        _viewModel.polprtCovcorSt = basic['POLPRT_COVCOR_ST'];
        _viewModel.boonsu2 = basic['BOONSU2'];
        _viewModel.inspectorDept2 = basic['INSPECTOR_DEPT2'];
        _viewModel.frgSt = basic['FRG_ST'];
        _viewModel.prtCrkSt = basic['PRT_CRK_ST'];
        _viewModel.prtLeakSt = basic['PRT_LEAK_ST'];
        _viewModel.prtSsdSt = basic['PRT_SSD_ST'];
      }
      
      if (data['facilities'] != null) {
        final fac = data['facilities'];
        _viewModel.flowMeterYn = fac['FLOW_METER_YN'];
        _viewModel.chulsufacYn = fac['CHULSUFAC_YN'];
        _viewModel.suwicheckpipeYn = fac['SUWICHECKPIPE_YN'];
        _viewModel.wlPondHeight2 = fac['WL_POND_HEIGHT2'];
        _viewModel.electricYn = fac['ELECTRIC_YN'];
        _viewModel.weighMeterId = fac['WEIGH_METER_ID'];
        _viewModel.weighMeterNum = fac['WEIGH_METER_NUM'];
        _viewModel.wlPumpDischarge1 = fac['WL_PUMP_DISCHARGE_1'];
        _viewModel.flowMeterNum = fac['FLOW_METER_NUM'];
        _viewModel.watTemp = fac['WAT_TEMP'];
        _viewModel.junki = fac['JUNKI'];
        _viewModel.ph = fac['PH'];
        _viewModel.naturalLevel1 = fac['NATURAL_LEVEL_1'];
        _viewModel.facStatus = fac['FAC_STATUS'];
        _viewModel.notuseReason = fac['NOTUSE_REASON'];
        _viewModel.alterFac = fac['ALTER_FAC'];
        _viewModel.notuse = fac['NOTUSE'];
        _viewModel.useContinue = fac['USE_CONTINUE'];
      }
      
      if (data['electrical'] != null) {
        final elec = data['electrical'];
        _viewModel.pumpIr = elec['PUMP_IR'];
        _viewModel.wtPipeCor2 = elec['WT_PIPE_COR2'];
        _viewModel.pumpOpSt = elec['PUMP_OP_ST'];
        _viewModel.wlGenPumpCount = elec['WL_GEN_PUMP_COUNT'];
        _viewModel.pumpFlow = elec['PUMP_FLOW'];
        _viewModel.switchboxLook = elec['SWITCHBOX_LOOK'];
        _viewModel.switchboxInst = elec['SWITCHBOX_INST'];
        _viewModel.pumpGr2 = elec['PUMP_GR2'];
        _viewModel.switchboxGr = elec['SWITCHBOX_GR'];
        _viewModel.switchboxIr = elec['SWITCHBOX_IR'];
        _viewModel.gpumpNoise2 = elec['GPUMP_NOISE2'];
        _viewModel.gpumpGr2 = elec['GPUMP_GR2'];
        _viewModel.gpumpIr2 = elec['GPUMP_IR2'];
        _viewModel.switchboxLook2 = elec['SWITCHBOX_LOOK2'];
        _viewModel.switchboxInst2 = elec['SWITCHBOX_INST2'];
        _viewModel.switchboxGr2 = elec['SWITCHBOX_GR2'];
        _viewModel.switchboxIr2 = elec['SWITCHBOX_IR2'];
        _viewModel.switchboxMov = elec['SWITCHBOX_MOV'];
      }
      
      if (data['assessment'] != null) {
        _viewModel.other = data['assessment']['OTHER'];
      }
      
      if (mounted) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('임시저장 데이터를 불러왔습니다'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('임시저장 데이터 불러오기 실패: $e')),
        );
      }
    }
  }

  /// 점검완료
  Future<void> _completeInspection() async {
    // 필수 필드 검증
    if (_viewModel.wellId == null || _viewModel.wellId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('시설번호를 입력해주세요')),
      );
      return;
    }

    if (_viewModel.inspector == null || _viewModel.inspector!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('점검자 성명을 입력해주세요')),
      );
      _tabController.animateTo(0); // Page 1로 이동
      return;
    }

    if (_viewModel.inspectDate == null || _viewModel.inspectDate!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('점검일자를 선택해주세요')),
      );
      _tabController.animateTo(0); // Page 1로 이동
      return;
    }

    // 확인 다이얼로그
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('점검완료'),
        content: const Text('점검을 완료하고 저장하시겠습니까?\n완료 후에는 수정할 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('완료'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      // Hive에 저장 또는 업데이트
      if (widget.inspection != null) {
        // 기존 점검 수정
        widget.inspection!.wellId = _viewModel.wellId;
        widget.inspection!.yangsuType = _viewModel.yangsuType;
        widget.inspection!.inspector = _viewModel.inspector;
        widget.inspection!.inspectDate = _viewModel.inspectDate;
        widget.inspection!.flowMeterYn = _viewModel.flowMeterYn;
        widget.inspection!.suwicheckpipeYn = _viewModel.suwicheckpipeYn;
        widget.inspection!.chulsufacYn = _viewModel.chulsufacYn;
        widget.inspection!.wlPondHeight2 = _viewModel.wlPondHeight2;
        widget.inspection!.flowMeterNum = _viewModel.flowMeterNum;
        widget.inspection!.weighMeterId = _viewModel.weighMeterId;
        widget.inspection!.weighMeterNum = _viewModel.weighMeterNum;
        widget.inspection!.electricYn = _viewModel.electricYn;
        widget.inspection!.watTemp = _viewModel.watTemp;
        widget.inspection!.junki = _viewModel.junki;
        widget.inspection!.ph = _viewModel.ph;
        widget.inspection!.naturalLevel1 = _viewModel.naturalLevel1;
        widget.inspection!.wlPumpDischarge1 = _viewModel.wlPumpDischarge1;
        widget.inspection!.frgSt = _viewModel.frgSt;
        widget.inspection!.prtCrkSt = _viewModel.prtCrkSt;
        widget.inspection!.prtLeakSt = _viewModel.prtLeakSt;
        widget.inspection!.prtSsdSt = _viewModel.prtSsdSt;
        widget.inspection!.constDate2 = _viewModel.constDate2;
        widget.inspection!.polprtCovcorSt = _viewModel.polprtCovcorSt;
        widget.inspection!.inspectorDept2 = _viewModel.inspectorDept2;
        widget.inspection!.boonsu2 = _viewModel.boonsu2;
        widget.inspection!.chkSphere2 = _viewModel.chkSphere2;
        widget.inspection!.switchboxLook = _viewModel.switchboxLook;
        widget.inspection!.switchboxInst = _viewModel.switchboxInst;
        widget.inspection!.switchboxGr = _viewModel.switchboxGr;
        widget.inspection!.switchboxIr = _viewModel.switchboxIr;
        widget.inspection!.switchboxMov = _viewModel.switchboxMov;
        widget.inspection!.pumpGr2 = _viewModel.pumpGr2;
        widget.inspection!.pumpIr = _viewModel.pumpIr;
        widget.inspection!.gpumpNoise2 = _viewModel.gpumpNoise2;
        widget.inspection!.gpumpGr2 = _viewModel.gpumpGr2;
        widget.inspection!.gpumpIr2 = _viewModel.gpumpIr2;
        widget.inspection!.switchboxLook2 = _viewModel.switchboxLook2;
        widget.inspection!.switchboxInst2 = _viewModel.switchboxInst2;
        widget.inspection!.switchboxGr2 = _viewModel.switchboxGr2;
        widget.inspection!.switchboxIr2 = _viewModel.switchboxIr2;
        widget.inspection!.pumpOpSt = _viewModel.pumpOpSt;
        widget.inspection!.wtPipeCor2 = _viewModel.wtPipeCor2;
        widget.inspection!.pumpFlow = _viewModel.pumpFlow;
        widget.inspection!.wlGenPumpCount = _viewModel.wlGenPumpCount;
        widget.inspection!.facStatus = _viewModel.facStatus;
        widget.inspection!.notuseReason = _viewModel.notuseReason;
        widget.inspection!.notuse = _viewModel.notuse;
        widget.inspection!.alterFac = _viewModel.alterFac;
        widget.inspection!.other = _viewModel.other;
        widget.inspection!.useContinue = _viewModel.useContinue;
        widget.inspection!.updatedAt = DateTime.now();
        
        await widget.inspection!.save();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('점검 데이터가 수정되었습니다'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context); // 상세 화면으로 돌아가기
        }
      } else {
        // 새 점검 저장
        final box = await Hive.openBox<InspectionModel>('inspections');
        final inspection = InspectionModel.fromViewModel(_viewModel);
        await box.add(inspection);
        
        // 임시저장 데이터 삭제
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('inspection_draft');
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('점검이 완료되고 저장되었습니다'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.popUntil(context, (route) => route.isFirst);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('저장 실패: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<InspectionViewModel>.value(
      value: _viewModel,
      child: WillPopScope(
        onWillPop: () async {
          // 뒤로가기 시 확인
          bool? shouldPop = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('점검 취소'),
              content: const Text('작성 중인 점검 데이터가 저장되지 않습니다.\n정말 나가시겠습니까?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('계속 작성'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('나가기'),
                ),
              ],
            ),
          );
          return shouldPop ?? false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Consumer<InspectionViewModel>(
              builder: (context, vm, child) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      vm.wellId != null && vm.wellId!.isNotEmpty
                          ? '점검입력 - ${vm.wellId}'
                          : '점검입력',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const Text(
                      'v1.0.8',
                      style: TextStyle(fontSize: 10, color: Colors.white70),
                    ),
                  ],
                );
              },
            ),
            centerTitle: true,
            actions: [
              // 우측 상단 아이콘 제거 (플로팅 버튼으로 대체)
            ],
            bottom: TabBar(
              controller: _tabController,
              isScrollable: false, // 전체 너비 사용
              indicatorColor: Colors.white,
              labelPadding: const EdgeInsets.symmetric(horizontal: 4),
              labelStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 14,
              ),
              tabs: const [
                Tab(
                  height: 56,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('① 기본'),
                      SizedBox(height: 2),
                      Text('정보', style: TextStyle(fontSize: 11)),
                    ],
                  ),
                ),
                Tab(
                  height: 56,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('② 측정'),
                      SizedBox(height: 2),
                      Text('장치', style: TextStyle(fontSize: 11)),
                    ],
                  ),
                ),
                Tab(
                  height: 56,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('③ 전기'),
                      SizedBox(height: 2),
                      Text('설비', style: TextStyle(fontSize: 11)),
                    ],
                  ),
                ),
                Tab(
                  height: 56,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('④ 기타'),
                      SizedBox(height: 2),
                      Text('사항', style: TextStyle(fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: const [
              InspectionPage1(), // 기본정보
              InspectionPage2(), // 측정장치
              InspectionPage3(), // 전기설비
              InspectionPage4(), // 기타사항
            ],
          ),
          // 플로팅 액션 버튼 (4페이지에서만 표시)
          // 모든 페이지에 플로팅 버튼 표시
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _completeInspection,
            backgroundColor: Colors.blue,
            icon: const Icon(Icons.save, color: Colors.white),
            label: Text(
              widget.inspection != null ? '수정 완료' : '점검 완료',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
