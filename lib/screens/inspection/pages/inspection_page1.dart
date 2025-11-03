import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
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
  final _gpsLongitude1Controller = TextEditingController(); // 경도 도
  final _gpsLongitude2Controller = TextEditingController(); // 경도 분
  final _gpsLongitude3Controller = TextEditingController(); // 경도 초
  final _gpsLatitude1Controller = TextEditingController(); // 위도 도
  final _gpsLatitude2Controller = TextEditingController(); // 위도 분
  final _gpsLatitude3Controller = TextEditingController(); // 위도 초

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

  bool _isLoadingGps = false;
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

      // GPS 데이터 로드
      if (viewModel.gpsLongitude1 != null) {
        _gpsLongitude1Controller.text = viewModel.gpsLongitude1!;
      }
      if (viewModel.gpsLongitude2 != null) {
        _gpsLongitude2Controller.text = viewModel.gpsLongitude2!;
      }
      if (viewModel.gpsLongitude3 != null) {
        _gpsLongitude3Controller.text = viewModel.gpsLongitude3!;
      }
      if (viewModel.gpsLatitude1 != null) {
        _gpsLatitude1Controller.text = viewModel.gpsLatitude1!;
      }
      if (viewModel.gpsLatitude2 != null) {
        _gpsLatitude2Controller.text = viewModel.gpsLatitude2!;
      }
      if (viewModel.gpsLatitude3 != null) {
        _gpsLatitude3Controller.text = viewModel.gpsLatitude3!;
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

  /// GPS 위치 가져오기
  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingGps = true);

    try {
      // 위치 권한 확인
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('위치 권한이 거부되었습니다');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('위치 권한이 영구적으로 거부되었습니다');
      }

      // 현재 위치 가져오기 (모바일 호환)
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      // 위도/경도를 도분초로 변환
      _convertToDMS(position.latitude, position.longitude);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('GPS 좌표를 가져왔습니다'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('GPS 오류: $e')),
        );
      }
    } finally {
      setState(() => _isLoadingGps = false);
    }
  }

  /// 십진법 좌표를 도분초(DMS)로 변환
  void _convertToDMS(double latitude, double longitude) {
    final viewModel = Provider.of<InspectionViewModel>(context, listen: false);

    // 경도 변환
    int lonDeg = longitude.abs().floor();
    double lonMinDecimal = (longitude.abs() - lonDeg) * 60;
    int lonMin = lonMinDecimal.floor();
    double lonSec = (lonMinDecimal - lonMin) * 60;

    // 위도 변환
    int latDeg = latitude.abs().floor();
    double latMinDecimal = (latitude.abs() - latDeg) * 60;
    int latMin = latMinDecimal.floor();
    double latSec = (latMinDecimal - latMin) * 60;

    setState(() {
      _gpsLongitude1Controller.text = lonDeg.toString();
      _gpsLongitude2Controller.text = lonMin.toString();
      _gpsLongitude3Controller.text = lonSec.toStringAsFixed(2);
      _gpsLatitude1Controller.text = latDeg.toString();
      _gpsLatitude2Controller.text = latMin.toString();
      _gpsLatitude3Controller.text = latSec.toStringAsFixed(2);
    });

    // ViewModel 업데이트
    viewModel.gpsLongitude1 = lonDeg.toString();
    viewModel.gpsLongitude2 = lonMin.toString();
    viewModel.gpsLongitude3 = lonSec.toStringAsFixed(2);
    viewModel.gpsLatitude1 = latDeg.toString();
    viewModel.gpsLatitude2 = latMin.toString();
    viewModel.gpsLatitude3 = latSec.toStringAsFixed(2);
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
    _gpsLongitude1Controller.dispose();
    _gpsLongitude2Controller.dispose();
    _gpsLongitude3Controller.dispose();
    _gpsLatitude1Controller.dispose();
    _gpsLatitude2Controller.dispose();
    _gpsLatitude3Controller.dispose();
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

              // 5. 위치좌표 (GPS 정보)
              _buildSectionHeader('5. 위치좌표 (GPS 정보)'),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _isLoadingGps ? null : _getCurrentLocation,
                              icon: _isLoadingGps
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.gps_fixed),
                              label: Text(_isLoadingGps ? 'GPS 가져오는 중...' : '현재 위치 가져오기'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // 경도 입력
                      Row(
                        children: [
                          const SizedBox(
                            width: 60,
                            child: Text('경도', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _gpsLongitude1Controller,
                              decoration: const InputDecoration(
                                hintText: '도',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(8),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) => viewModel.gpsLongitude1 = value,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _gpsLongitude2Controller,
                              decoration: const InputDecoration(
                                hintText: '분',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(8),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) => viewModel.gpsLongitude2 = value,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _gpsLongitude3Controller,
                              decoration: const InputDecoration(
                                hintText: '초',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(8),
                              ),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              onChanged: (value) => viewModel.gpsLongitude3 = value,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // 위도 입력
                      Row(
                        children: [
                          const SizedBox(
                            width: 60,
                            child: Text('위도', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _gpsLatitude1Controller,
                              decoration: const InputDecoration(
                                hintText: '도',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(8),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) => viewModel.gpsLatitude1 = value,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _gpsLatitude2Controller,
                              decoration: const InputDecoration(
                                hintText: '분',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(8),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) => viewModel.gpsLatitude2 = value,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _gpsLatitude3Controller,
                              decoration: const InputDecoration(
                                hintText: '초',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(8),
                              ),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              onChanged: (value) => viewModel.gpsLatitude3 = value,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 6. 양수장 형태
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

              // 7. 양수장 출입문 (조건부)
              _buildInfoCard(
                '7. 양수장 출입문',
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

              // 8. 양수장 장옥덮개 (조건부)
              _buildInfoCard(
                '8. 양수장 장옥덮개',
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
                    viewModel.constDate2 = value;
                  },
                ),
              ),

              // 9. 장옥덮개 부식도
              _buildInfoCard(
                '9. 장옥덮개 부식도',
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
                    viewModel.polprtCovcorSt = value;
                  },
                ),
              ),

              // 10. 스마트 안내문
              _buildInfoCard(
                '10. 스마트 안내문',
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

              // 11. 관정덮개
              _buildInfoCard(
                '11. 관정덮개',
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

              // 12. 이물질 배출여부
              _buildInfoCard(
                '12. 이물질 배출여부',
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

              // 13. 균열 (Multi-select)
              _buildInfoCard(
                '13. 균열',
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

              // 14. 누수 (Multi-select)
              _buildInfoCard(
                '14. 누수',
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

              // 15. 침하 (Multi-select)
              _buildInfoCard(
                '15. 침하',
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
