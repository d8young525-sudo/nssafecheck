import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/inspection_viewmodel.dart';
import '../../models/facility_model.dart';
import 'pages/inspection_page1.dart';
import 'pages/inspection_page2.dart';
import 'pages/inspection_page3.dart';
import 'pages/inspection_page4.dart';
import 'pages/inspection_page5.dart';

/// 점검입력 메인 화면 - 5개 페이지를 TabView로 구성
/// Kotlin의 ViewPager + 5 Fragments 구조를 Flutter로 구현
class InspectionFormScreen extends StatefulWidget {
  const InspectionFormScreen({super.key});

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
    _tabController = TabController(length: 5, vsync: this);
    _viewModel = InspectionViewModel();

    // ViewModel 초기화 - 오늘 날짜 자동 설정
    DateTime now = DateTime.now();
    _viewModel.inspectDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// 임시저장
  Future<void> _saveDraft() async {
    try {
      // TODO: Firebase에 draft 상태로 저장
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('임시저장되었습니다'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('임시저장 실패: $e')),
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
      // TODO: Firebase에 completed 상태로 저장
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('점검이 완료되었습니다'),
            backgroundColor: Colors.green,
          ),
        );

        // 홈 화면으로 돌아가기
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('점검완료 저장 실패: $e')),
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
                return Text(
                  vm.wellId != null && vm.wellId!.isNotEmpty
                      ? '점검입력 - ${vm.wellId}'
                      : '점검입력',
                );
              },
            ),
            centerTitle: true,
            actions: [
              // 임시저장 버튼
              IconButton(
                icon: const Icon(Icons.save_outlined),
                tooltip: '임시저장',
                onPressed: _saveDraft,
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: Colors.white,
              labelPadding: const EdgeInsets.symmetric(horizontal: 12),
              labelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 12,
              ),
              tabs: const [
                Tab(text: '① 기본'),
                Tab(text: '② 측정'),
                Tab(text: '③ 전기'),
                Tab(text: '④ 기타'),
                Tab(text: '⑤ 사진'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: const [
              InspectionPage1(), // 기본정보 (19개 필드)
              InspectionPage2(), // 측정장치 (18개 필드)
              InspectionPage3(), // 전기설비 (18개 필드)
              InspectionPage4(), // 기타사항 (1개 필드)
              InspectionPage5(), // 사진촬영 (18개 사진)
            ],
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // 페이지 인디케이터
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_tabController.index + 1} / 5',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // 완료 버튼 (마지막 페이지에서만)
                  Expanded(
                    child: _tabController.index < 4
                        ? ElevatedButton(
                            onPressed: () =>
                                _tabController.animateTo(_tabController.index + 1),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('다음 페이지'),
                          )
                        : ElevatedButton.icon(
                            onPressed: _completeInspection,
                            icon: const Icon(Icons.check_circle),
                            label: const Text('점검완료'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
