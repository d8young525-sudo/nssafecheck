import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../viewmodels/inspection_viewmodel.dart';

/// Page 1: 기본정보 (15개 필드)
/// 지역/시설명 입력 + 작성자/점검일자 자동설정
class InspectionPage1 extends StatefulWidget {
  const InspectionPage1({super.key});

  @override
  State<InspectionPage1> createState() => _InspectionPage1State();
}

class _InspectionPage1State extends State<InspectionPage1> {
  final _facilityNumberController = TextEditingController();
  final _inspectorController = TextEditingController();
  final _dateController = TextEditingController();

  String? _selectedRegion; // 선택된 지역
  String? _selectedYangsuType; // 양수장 형태
  String? _selectedDoor; // 출입문
  String? _selectedCover; // 장옥덮개
  String? _selectedCorrosion; // 부식도
  String? _selectedSmartSign; // 스마트안내문
  String? _selectedWellCover; // 관정덮개
  String? _selectedForeignSub; // 이물질
  List<String> _selectedCracks = []; // 균열 (Multi-select)
  List<String> _selectedLeaks = []; // 누수 (Multi-select)
  List<String> _selectedSubsidence = []; // 침하 (Multi-select)

  bool _isLoadingUser = true;

  // 12개 지역 매핑
  final Map<String, String> _regionCodes = {
    '평택': 'PT',
    '용인': 'YI',
    '파주': 'PJ',
    '이천': 'IC',
    '안성': 'AS',
    '화성': 'HS',
    '양주': 'YA',
    '포천': 'PC',
    '여주': 'YJ',
    '연천': 'YC',
    '가평': 'GP',
    '양평': 'YP',
  };

  // 양수장 형태 옵션
  final List<String> _yangsuTypes = [
    '선택',
    '양수장',
    '보호공(사각)',
    '보호공(원형)',
    '밀폐공',
    'L-타입',
    '기타',
  ];

  // 장옥덮개 부식도 옵션
  final List<String> _corrosionOptions = ['선택', '녹발생', '부식', '노후'];

  // 스마트안내문 옵션
  final List<String> _smartSignOptions = ['선택', '유', '무', '설치불량'];

  // 관정덮개 옵션
  final List<String> _wellCoverOptions = ['선택', '양호', '미설치', '불량', '녹발생', '확인불가'];

  // 이물질 배출여부 옵션
  final List<String> _foreignSubOptions = ['선택', '양호', '탁수', '이물질', '녹물', '흙탕물', '확인불가'];

  // 균열 옵션
  final List<String> _crackOptions = [
    '균열(벽체)',
    '균열(바닥)',
    '균열(천장)',
    '파손',
    '노후',
    '백태',
    '박리',
  ];

  // 누수 옵션
  final List<String> _leakOptions = [
    '누수',
    '침수',
  ];

  // 침하 옵션
  final List<String> _subsidenceOptions = [
    '침하',
    '토사유입',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadViewModelData();
    _loadLastRegion(); // 이전 선택 지역 로드
  }

  @override
  void didUpdateWidget(InspectionPage1 oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 위젯이 재생성될 때마다 ViewModel 데이터 다시 로드
    _loadViewModelData();
  }

  /// 이전에 선택한 지역 로드
  Future<void> _loadLastRegion() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastRegion = prefs.getString('last_selected_region');
      if (lastRegion != null && _regionCodes.containsKey(lastRegion)) {
        setState(() {
          _selectedRegion = lastRegion;
        });
      }
    } catch (e) {
      // 무시 (오류가 있어도 동작에 영향 없음)
    }
  }

  /// 선택한 지역 저장
  Future<void> _saveLastRegion(String region) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_selected_region', region);
    } catch (e) {
      // 무시
    }
  }

  /// Firebase에서 로그인한 사용자 정보 가져오기
  Future<void> _loadUserData() async {
    setState(() => _isLoadingUser = true);

    try {
      User? firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        // Firestore에서 사용자 이름 가져오기
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .get();

        if (userDoc.exists && mounted) {
          String userName = userDoc.get('name') ?? '사용자';
          _inspectorController.text = userName;

          // ViewModel에 반영
          final viewModel = Provider.of<InspectionViewModel>(context, listen: false);
          viewModel.inspector = userName;
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('사용자 정보 로드 실패: $e')),
        );
      }
    } finally {
      setState(() => _isLoadingUser = false);
    }
  }

  /// ViewModel에서 데이터 로드
  void _loadViewModelData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<InspectionViewModel>(context, listen: false);

      // 점검일자 자동 설정 (오늘 날짜)
      if (viewModel.inspectDate != null) {
        _dateController.text = viewModel.inspectDate!;
      }

      // 기존 데이터 로드
      if (viewModel.wellId != null && viewModel.wellId!.contains('-')) {
        List<String> parts = viewModel.wellId!.split('-');
        String regionCode = parts[0];
        String facilityNumber = parts.length > 1 ? parts[1] : '';

        // 지역코드로 지역명 찾기
        _regionCodes.forEach((name, code) {
          if (code == regionCode) {
            setState(() => _selectedRegion = name);
          }
        });

        _facilityNumberController.text = facilityNumber;
      }

      if (viewModel.inspector != null) {
        _inspectorController.text = viewModel.inspector!;
      }

      setState(() {
        _selectedYangsuType = viewModel.yangsuType;
        _selectedDoor = viewModel.chkSphere2;
        _selectedCover = viewModel.constDate2;
        _selectedCorrosion = viewModel.polprtCovcorSt;
        _selectedSmartSign = viewModel.inspectorDept2;
        _selectedWellCover = viewModel.boonsu2;
        _selectedForeignSub = viewModel.frgSt;

        // Multi-select 데이터 로드
        if (viewModel.prtCrkSt != null && viewModel.prtCrkSt!.isNotEmpty) {
          _selectedCracks = viewModel.prtCrkSt!.split(',');
        }
        if (viewModel.prtLeakSt != null && viewModel.prtLeakSt!.isNotEmpty) {
          _selectedLeaks = viewModel.prtLeakSt!.split(',');
        }
        if (viewModel.prtSsdSt != null && viewModel.prtSsdSt!.isNotEmpty) {
          _selectedSubsidence = viewModel.prtSsdSt!.split(',');
        }
      });
    });
  }

  /// 점검일자 선택
  Future<void> _selectDate(BuildContext context) async {
    final viewModel = Provider.of<InspectionViewModel>(context, listen: false);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      String formattedDate = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      _dateController.text = formattedDate;
      viewModel.inspectDate = formattedDate;
    }
  }

  /// Multi-select 다이얼로그 표시
  Future<void> _showMultiSelectDialog({
    required String title,
    required List<String> options,
    required List<String> selectedItems,
    required Function(List<String>) onConfirm,
  }) async {
    List<String> tempSelected = List.from(selectedItems);

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: options.map((option) {
                return CheckboxListTile(
                  title: Text(option),
                  value: tempSelected.contains(option),
                  onChanged: (checked) {
                    setDialogState(() {
                      if (checked == true) {
                        tempSelected.add(option);
                      } else {
                        tempSelected.remove(option);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: () {
                onConfirm(tempSelected);
                Navigator.pop(context);
              },
              child: const Text('확인'),
            ),
          ],
        ),
      ),
    );
  }

  /// WELL_ID 업데이트
  void _updateWellId() {
    if (_selectedRegion != null && _facilityNumberController.text.isNotEmpty) {
      final viewModel = Provider.of<InspectionViewModel>(context, listen: false);
      String regionCode = _regionCodes[_selectedRegion]!;
      String fullWellId = '$regionCode-${_facilityNumberController.text}';
      viewModel.wellId = fullWellId;
    }
  }

  @override
  void dispose() {
    _facilityNumberController.dispose();
    _inspectorController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InspectionViewModel>(
      builder: (context, viewModel, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. 지역 선택
              _buildInfoCard(
                '1. 지역',
                DropdownButtonFormField<String>(
                  value: _selectedRegion,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    hintText: '지역을 선택하세요',
                  ),
                  items: _regionCodes.keys.map((region) {
                    return DropdownMenuItem(
                      value: region,
                      child: Text('$region (${_regionCodes[region]})'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedRegion = value);
                    if (value != null) {
                      _saveLastRegion(value); // 선택한 지역 저장
                    }
                    _updateWellId();
                  },
                ),
              ),

              // 2. 시설명 입력
              _buildInfoCard(
                '2. 시설명',
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 지역 코드 표시
                    Container(
                      width: 80,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.grey[400]!),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          bottomLeft: Radius.circular(4),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _selectedRegion != null
                              ? '${_regionCodes[_selectedRegion]}-'
                              : '선택-',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // 시설번호 입력
                    Expanded(
                      child: TextField(
                        controller: _facilityNumberController,
                        decoration: const InputDecoration(
                          hintText: '001',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(4),
                              bottomRight: Radius.circular(4),
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        enabled: _selectedRegion != null,
                        onChanged: (value) => _updateWellId(),
                      ),
                    ),
                  ],
                ),
              ),

              // 3. 작성자 (자동 입력, 편집 가능)
              _buildInfoCard(
                '3. 작성자',
                TextField(
                  controller: _inspectorController,
                  decoration: InputDecoration(
                    hintText: '작성자 성명',
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    suffixIcon: _isLoadingUser
                        ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : null,
                  ),
                  onChanged: (value) => viewModel.inspector = value,
                ),
              ),

              // 4. 점검일자 (오늘 날짜 자동, 편집 가능)
              _buildInfoCard(
                '4. 점검일자',
                InkWell(
                  onTap: () => _selectDate(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          viewModel.inspectDate ?? '날짜 선택',
                          style: TextStyle(
                            fontSize: 16,
                            color: viewModel.inspectDate != null
                                ? Colors.black87
                                : Colors.grey,
                          ),
                        ),
                        const Icon(Icons.calendar_today, size: 20),
                      ],
                    ),
                  ),
                ),
              ),

              // 5. 양수장 형태
              _buildInfoCard(
                '6. 양수장 형태',
                DropdownButtonFormField<String>(
                  value: _selectedYangsuType,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: _yangsuTypes.map((type) {
                    return DropdownMenuItem(value: type, child: Text(type));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedYangsuType = value;
                      // 양수장 외 선택 시 출입문/장옥덮개 자동으로 "미설치" 설정
                      if (value != '양수장') {
                        _selectedDoor = '미설치';
                        _selectedCover = '미설치';
                        viewModel.chkSphere2 = '미설치';
                        viewModel.constDate2 = '미설치';
                      }
                    });
                    viewModel.yangsuType = value;
                  },
                ),
              ),

              // 6. 양수장 출입문 (조건부)
              _buildInfoCard(
                '6. 양수장 출입문',
                DropdownButtonFormField<String>(
                  value: _selectedDoor,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: (_selectedYangsuType == '양수장'
                      ? ['선택', '양호', '불량', '파손(손잡이)', '파손(경첩)']
                      : ['미설치']).map((status) {
                    return DropdownMenuItem(value: status, child: Text(status));
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedDoor = value);
                    viewModel.chkSphere2 = value;
                  },
                ),
              ),

              // 7. 양수장 장옥덮개 (조건부)
              _buildInfoCard(
                '7. 양수장 장옥덮개',
                DropdownButtonFormField<String>(
                  value: _selectedCover,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: (_selectedYangsuType == '양수장'
                      ? ['선택', '양호', '불량', '파손', '확인불가']
                      : ['미설치']).map((status) {
                    return DropdownMenuItem(value: status, child: Text(status));
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedCover = value);
                    // '선택'을 선택하면 null로 저장
                    viewModel.constDate2 = (value == '선택') ? null : value;
                  },
                ),
              ),

              // 8. 장옥덮개 부식도
              _buildInfoCard(
                '8. 장옥덮개 부식도',
                DropdownButtonFormField<String>(
                  value: _selectedCorrosion,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: _corrosionOptions.map((status) {
                    return DropdownMenuItem(value: status, child: Text(status));
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedCorrosion = value);
                    // '선택'을 선택하면 null로 저장
                    viewModel.polprtCovcorSt = (value == '선택') ? null : value;
                  },
                ),
              ),

              // 9. 스마트 안내문
              _buildInfoCard(
                '9. 스마트 안내문',
                DropdownButtonFormField<String>(
                  value: _selectedSmartSign,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: _smartSignOptions.map((status) {
                    return DropdownMenuItem(value: status, child: Text(status));
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedSmartSign = value);
                    viewModel.inspectorDept2 = value;
                  },
                ),
              ),

              // 10. 관정덮개
              _buildInfoCard(
                '10. 관정덮개',
                DropdownButtonFormField<String>(
                  value: _selectedWellCover,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: _wellCoverOptions.map((status) {
                    return DropdownMenuItem(value: status, child: Text(status));
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedWellCover = value);
                    viewModel.boonsu2 = value;
                  },
                ),
              ),

              // 11. 이물질 배출여부
              _buildInfoCard(
                '11. 이물질 배출여부',
                DropdownButtonFormField<String>(
                  value: _selectedForeignSub,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: _foreignSubOptions.map((status) {
                    return DropdownMenuItem(value: status, child: Text(status));
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedForeignSub = value);
                    viewModel.frgSt = value;
                  },
                ),
              ),

              // 12. 균열 (Multi-select)
              _buildInfoCard(
                '12. 균열',
                InkWell(
                  onTap: () {
                    _showMultiSelectDialog(
                      title: '균열 선택',
                      options: _crackOptions,
                      selectedItems: _selectedCracks,
                      onConfirm: (selected) {
                        setState(() => _selectedCracks = selected);
                        viewModel.prtCrkSt = selected.join(',');
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _selectedCracks.isEmpty
                                ? '선택해주세요'
                                : _selectedCracks.join(', '),
                            style: TextStyle(
                              fontSize: 16,
                              color: _selectedCracks.isEmpty ? Colors.grey : Colors.black87,
                            ),
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
              ),

              // 13. 누수 (Multi-select)
              _buildInfoCard(
                '13. 누수',
                InkWell(
                  onTap: () {
                    _showMultiSelectDialog(
                      title: '누수 선택',
                      options: _leakOptions,
                      selectedItems: _selectedLeaks,
                      onConfirm: (selected) {
                        setState(() => _selectedLeaks = selected);
                        viewModel.prtLeakSt = selected.join(',');
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _selectedLeaks.isEmpty
                                ? '선택해주세요'
                                : _selectedLeaks.join(', '),
                            style: TextStyle(
                              fontSize: 16,
                              color: _selectedLeaks.isEmpty ? Colors.grey : Colors.black87,
                            ),
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
              ),

              // 14. 침하 (Multi-select)
              _buildInfoCard(
                '14. 침하',
                InkWell(
                  onTap: () {
                    _showMultiSelectDialog(
                      title: '침하 선택',
                      options: _subsidenceOptions,
                      selectedItems: _selectedSubsidence,
                      onConfirm: (selected) {
                        setState(() => _selectedSubsidence = selected);
                        viewModel.prtSsdSt = selected.join(',');
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _selectedSubsidence.isEmpty
                                ? '선택해주세요'
                                : _selectedSubsidence.join(', '),
                            style: TextStyle(
                              fontSize: 16,
                              color: _selectedSubsidence.isEmpty ? Colors.grey : Colors.black87,
                            ),
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, Widget child) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}
