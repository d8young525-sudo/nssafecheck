import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/inspection_viewmodel.dart';

/// Page 3: 전기설비 (18개 필드)
/// 1번은 전기연결 상태 (연결/단전) - 단전 시 나머지 필드 비활성화
/// 2, 11, 12번은 숫자 입력 + "확인불가" 체크박스 패턴
class InspectionPage3 extends StatefulWidget {
  const InspectionPage3({super.key});

  @override
  State<InspectionPage3> createState() => _InspectionPage3State();
}

class _InspectionPage3State extends State<InspectionPage3> {
  // 숫자 입력 컨트롤러
  final _insulationResistanceController = TextEditingController(); // 1. 절연저항
  final _voltageController = TextEditingController(); // 10. 지시전압
  final _currentController = TextEditingController(); // 11. 지시전류

  // FocusNode for 절연저항 (blur 이벤트 처리용)
  final _insulationResistanceFocusNode = FocusNode();

  // "확인불가" 체크박스 상태
  bool _insulationResistanceUnavailable = false;
  bool _voltageUnavailable = false;
  bool _currentUnavailable = false;

  // Dropdown 선택값
  String? _selectedElectricalConnection; // 1. 전기연결 (최우선 필드)
  String? _selectedNoise; // 3. 소음발생여부
  String? _selectedOperationStatus; // 4. 작동상태
  String? _selectedFlowRate; // 5. 유량
  String? _selectedBoxExterior; // 6. 배전함외형
  String? _selectedInstallation; // 7. 설치
  String? _selectedGroundTerminal; // 8. 접지단자
  String? _selectedInsulationTerminal; // 9. 절연단자
  String? _selectedFuse; // 13. 휴즈
  String? _selectedFloatless; // 14. Floatless
  String? _selectedEOCR; // 15. EOCR
  String? _selectedMagnetic; // 16. 마그네틱
  String? _selectedLamp; // 17. 램프
  String? _selectedPanelOperation; // 18. 배전반동작

  // 단전 상태 추적 (나머지 필드 활성화/비활성화 제어)
  bool get _isDisconnected => _selectedElectricalConnection == '단전';

  // 1. 전기연결 옵션 (최우선 필드)
  final List<String> _connectionOptions = ['선택', '연결', '단전'];

  // 3. 소음발생여부 옵션
  final List<String> _noiseOptions = ['선택', '유', '무', '확인불가'];

  // 4. 작동상태 옵션
  final List<String> _operationOptions = ['선택', '양호', '작동불량', '고장', '일반펌프', '펌프시설없음', '미설치', '확인불가'];

  // 5. 유량 옵션
  final List<String> _flowRateOptions = ['선택', '적정', '수량적음', '확인불가'];

  // 6-10. 배전함 관련 옵션
  final List<String> _boxExteriorOptions = ['선택', '양호', '불량', '노후', '파손', '녹발생', '미설치', '확인불가'];
  final List<String> _installationOptions = ['선택', '양호', '불량', '확인불가'];
  final List<String> _terminalOptions = ['선택', '양호', '불량', '확인불가'];

  // 13-17. 계기기 옵션
  final List<String> _instrumentOptions = ['선택', '정상', '고장', '확인불가'];

  // 18. 배전반동작 옵션
  final List<String> _panelOperationOptions = ['선택', '양호', '고장', '작동불량', '미설치', '계기류고장(V)', '계기류고장(A)', '계기류고장(V,A)', '확인불가'];

  @override
  void initState() {
    super.initState();
    _loadViewModelData();
    
    // 절연저항 FocusNode 리스너 추가 (blur 이벤트)
    _insulationResistanceFocusNode.addListener(() {
      if (!_insulationResistanceFocusNode.hasFocus) {
        _formatInsulationResistance();
      }
    });
  }

  /// 절연저항 자동 포맷팅 (30 → 30/30/30)
  void _formatInsulationResistance() {
    final viewModel = Provider.of<InspectionViewModel>(context, listen: false);
    String value = _insulationResistanceController.text.trim();
    
    if (value.isNotEmpty && !value.contains('/')) {
      // 자동 포맷팅: 30 입력 시 → 30/30/30
      String formatted = '$value/$value/$value';
      setState(() {
        _insulationResistanceController.text = formatted;
      });
      viewModel.pumpIr = "'$formatted"; // CSV용 앞에 ' 추가
    }
  }

  /// 전기연결 상태 변경 시 나머지 필드 초기화 (단전 시)
  void _handleElectricalConnectionChanged(String? value, InspectionViewModel viewModel) {
    setState(() => _selectedElectricalConnection = value);
    viewModel.pumpGr2 = (value == '선택') ? null : value;

    // 단전 선택 시: 모든 필드를 "확인불가"로 설정
    if (value == '단전') {
      // 숫자 입력 필드 초기화
      _insulationResistanceController.clear();
      _voltageController.clear();
      _currentController.clear();
      
      setState(() {
        _insulationResistanceUnavailable = true;
        _voltageUnavailable = true;
        _currentUnavailable = true;
        
        // Dropdown 값들도 "확인불가"로 설정
        _selectedNoise = '확인불가';
        _selectedOperationStatus = '확인불가';
        _selectedFlowRate = '확인불가';
        _selectedBoxExterior = '확인불가';
        _selectedInstallation = '확인불가';
        _selectedGroundTerminal = '확인불가';
        _selectedInsulationTerminal = '확인불가';
        _selectedFuse = '확인불가';
        _selectedFloatless = '확인불가';
        _selectedEOCR = '확인불가';
        _selectedMagnetic = '확인불가';
        _selectedLamp = '확인불가';
        _selectedPanelOperation = '확인불가';
      });
      
      // ViewModel 업데이트
      viewModel.pumpIr = '확인불가';
      viewModel.wtPipeCor2 = '확인불가';
      viewModel.pumpOpSt = '확인불가';
      viewModel.pumpFlow = '확인불가';
      viewModel.switchboxLook = '확인불가';
      viewModel.switchboxInst = '확인불가';
      viewModel.switchboxGr = '확인불가';
      viewModel.switchboxIr = '확인불가';
      viewModel.gpumpNoise2 = '확인불가';
      viewModel.gpumpGr2 = '확인불가';
      viewModel.gpumpIr2 = '확인불가';
      viewModel.switchboxLook2 = '확인불가';
      viewModel.switchboxInst2 = '확인불가';
      viewModel.switchboxGr2 = '확인불가';
      viewModel.switchboxIr2 = '확인불가';
      viewModel.switchboxMov = '확인불가';
    } else if (value == '연결') {
      // 연결 선택 시: "확인불가"였던 필드들을 초기화 (입력 전 상태로 복원)
      setState(() {
        _insulationResistanceUnavailable = false;
        _voltageUnavailable = false;
        _currentUnavailable = false;
        
        // Dropdown을 "선택"으로 초기화 (null로 저장됨)
        _selectedNoise = null;
        _selectedOperationStatus = null;
        _selectedFlowRate = null;
        _selectedBoxExterior = null;
        _selectedInstallation = null;
        _selectedGroundTerminal = null;
        _selectedInsulationTerminal = null;
        _selectedFuse = null;
        _selectedFloatless = null;
        _selectedEOCR = null;
        _selectedMagnetic = null;
        _selectedLamp = null;
        _selectedPanelOperation = null;
      });
      
      // ViewModel을 null로 초기화 (입력 전 상태)
      viewModel.pumpIr = null;
      viewModel.wtPipeCor2 = null;
      viewModel.pumpOpSt = null;
      viewModel.pumpFlow = null;
      viewModel.switchboxLook = null;
      viewModel.switchboxInst = null;
      viewModel.switchboxGr = null;
      viewModel.switchboxIr = null;
      viewModel.gpumpNoise2 = null;
      viewModel.gpumpGr2 = null;
      viewModel.gpumpIr2 = null;
      viewModel.switchboxLook2 = null;
      viewModel.switchboxInst2 = null;
      viewModel.switchboxGr2 = null;
      viewModel.switchboxIr2 = null;
      viewModel.switchboxMov = null;
    }
  }

  void _loadViewModelData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<InspectionViewModel>(context, listen: false);

      // Dropdown 값 로드
      setState(() {
        _selectedNoise = viewModel.wtPipeCor2;
        _selectedOperationStatus = viewModel.pumpOpSt;
        _selectedFlowRate = viewModel.pumpFlow;
        _selectedBoxExterior = viewModel.switchboxLook;
        _selectedInstallation = viewModel.switchboxInst;
        _selectedElectricalConnection = viewModel.pumpGr2;
        _selectedGroundTerminal = viewModel.switchboxGr;
        _selectedInsulationTerminal = viewModel.switchboxIr;
        _selectedFuse = viewModel.gpumpIr2;
        _selectedFloatless = viewModel.switchboxLook2;
        _selectedEOCR = viewModel.switchboxInst2;
        _selectedMagnetic = viewModel.switchboxGr2;
        _selectedLamp = viewModel.switchboxIr2;
        _selectedPanelOperation = viewModel.switchboxMov;
      });

      // 숫자 입력값 로드 - 1. 절연저항
      if (viewModel.pumpIr != null) {
        if (viewModel.pumpIr == '확인불가') {
          _insulationResistanceUnavailable = true;
        } else {
          _insulationResistanceController.text = viewModel.pumpIr!;
        }
      }

      // 10. 지시전압
      if (viewModel.gpumpNoise2 != null) {
        if (viewModel.gpumpNoise2 == '확인불가') {
          _voltageUnavailable = true;
        } else {
          _voltageController.text = viewModel.gpumpNoise2!;
        }
      }

      // 11. 지시전류
      if (viewModel.gpumpGr2 != null) {
        if (viewModel.gpumpGr2 == '확인불가') {
          _currentUnavailable = true;
        } else {
          _currentController.text = viewModel.gpumpGr2!;
        }
      }

      setState(() {});
    });
  }

  @override
  void dispose() {
    _insulationResistanceController.dispose();
    _voltageController.dispose();
    _currentController.dispose();
    _insulationResistanceFocusNode.dispose();
    super.dispose();
  }

  /// 숫자 입력 필드 + 확인불가 체크박스 위젯
  Widget _buildNumberFieldWithCheckbox({
    required String label,
    required TextEditingController controller,
    required bool isUnavailable,
    required Function(bool?) onCheckboxChanged,
    required Function(String) onFieldChanged,
    String? unit,
  }) {
    return _buildInfoCard(
      label,
      Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              enabled: !isUnavailable,
              decoration: InputDecoration(
                hintText: isUnavailable ? '확인불가' : '숫자 입력',
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                suffixText: unit,
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: onFieldChanged,
            ),
          ),
          const SizedBox(width: 12),
          Row(
            children: [
              Checkbox(
                value: isUnavailable,
                onChanged: onCheckboxChanged,
              ),
              const Text('확인불가'),
            ],
          ),
        ],
      ),
    );
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
              // ===== 1. 전기연결 (최상단 필드 - 단전 시 나머지 필드 비활성화) =====
              _buildSectionHeader('전원 접속 상태'),
              const SizedBox(height: 16),
              
              _buildInfoCard(
                '1. 전기연결',
                DropdownButtonFormField<String>(
                  value: _selectedElectricalConnection,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    helperText: '단전 선택 시 모든 하위 항목이 "확인불가"로 자동 설정됩니다',
                    helperMaxLines: 2,
                  ),
                  items: _connectionOptions.map((status) {
                    return DropdownMenuItem(value: status, child: Text(status));
                  }).toList(),
                  onChanged: (value) => _handleElectricalConnectionChanged(value, viewModel),
                ),
              ),

              const SizedBox(height: 24),
              _buildSectionHeader('수중모터'),
              const SizedBox(height: 16),

              // 2. 절연저항 (숫자 + 확인불가 + 자동 포맷팅)
              _buildInfoCard(
                '2. 절연저항',
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _insulationResistanceController,
                        focusNode: _insulationResistanceFocusNode,
                        enabled: !_insulationResistanceUnavailable && !_isDisconnected,
                        decoration: InputDecoration(
                          hintText: _insulationResistanceUnavailable ? '확인불가' : '숫자 입력 (포커스 해제 시 자동 포맷: 30 → 30/30/30)',
                          border: const OutlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          suffixText: 'MΩ',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onChanged: (value) {
                          // 포맷되지 않은 값만 저장 (포맷은 blur 시 처리)
                          if (!value.contains('/')) {
                            viewModel.pumpIr = value;
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Row(
                      children: [
                        Checkbox(
                          value: _insulationResistanceUnavailable,
                          onChanged: _isDisconnected ? null : (checked) {
                            setState(() => _insulationResistanceUnavailable = checked ?? false);
                            if (checked == true) {
                              _insulationResistanceController.clear();
                              viewModel.pumpIr = '확인불가';
                            } else {
                              viewModel.pumpIr = null;
                            }
                          },
                        ),
                        const Text('확인불가'),
                      ],
                    ),
                  ],
                ),
              ),

              // 3. 소음발생여부
              _buildInfoCard(
                '3. 소음발생여부',
                DropdownButtonFormField<String>(
                  value: _selectedNoise,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: _noiseOptions.map((option) {
                    return DropdownMenuItem(value: option, child: Text(option));
                  }).toList(),
                  onChanged: _isDisconnected ? null : (value) {
                    setState(() => _selectedNoise = value);
                    viewModel.wtPipeCor2 = (value == '선택') ? null : value;
                  },
                ),
              ),

              // 4. 작동상태
              _buildInfoCard(
                '4. 작동상태',
                DropdownButtonFormField<String>(
                  value: _selectedOperationStatus,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: _operationOptions.map((status) {
                    return DropdownMenuItem(value: status, child: Text(status));
                  }).toList(),
                  onChanged: _isDisconnected ? null : (value) {
                    setState(() => _selectedOperationStatus = value);
                    viewModel.pumpOpSt = (value == '선택') ? null : value;
                  },
                ),
              ),

              // 5. 유량
              _buildInfoCard(
                '5. 유량',
                DropdownButtonFormField<String>(
                  value: _selectedFlowRate,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: _flowRateOptions.map((status) {
                    return DropdownMenuItem(value: status, child: Text(status));
                  }).toList(),
                  onChanged: _isDisconnected ? null : (value) {
                    setState(() => _selectedFlowRate = value);
                    viewModel.pumpFlow = (value == '선택') ? null : value;
                  },
                ),
              ),

              const SizedBox(height: 24),
              _buildSectionHeader('배전함'),
              const SizedBox(height: 16),

              // 6. 배전함외형
              _buildInfoCard(
                '6. 배전함외형',
                DropdownButtonFormField<String>(
                  value: _selectedBoxExterior,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: _boxExteriorOptions.map((status) {
                    return DropdownMenuItem(value: status, child: Text(status));
                  }).toList(),
                  onChanged: _isDisconnected ? null : (value) {
                    setState(() => _selectedBoxExterior = value);
                    viewModel.switchboxLook = (value == '선택') ? null : value;
                  },
                ),
              ),

              // 7. 설치
              _buildInfoCard(
                '7. 설치',
                DropdownButtonFormField<String>(
                  value: _selectedInstallation,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: _installationOptions.map((status) {
                    return DropdownMenuItem(value: status, child: Text(status));
                  }).toList(),
                  onChanged: _isDisconnected ? null : (value) {
                    setState(() => _selectedInstallation = value);
                    viewModel.switchboxInst = (value == '선택') ? null : value;
                  },
                ),
              ),



              // 8. 접지단자
              _buildInfoCard(
                '8. 접지단자',
                DropdownButtonFormField<String>(
                  value: _selectedGroundTerminal,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: _terminalOptions.map((status) {
                    return DropdownMenuItem(value: status, child: Text(status));
                  }).toList(),
                  onChanged: _isDisconnected ? null : (value) {
                    setState(() => _selectedGroundTerminal = value);
                    viewModel.switchboxGr = (value == '선택') ? null : value;
                  },
                ),
              ),

              // 9. 절연단자
              _buildInfoCard(
                '9. 절연단자',
                DropdownButtonFormField<String>(
                  value: _selectedInsulationTerminal,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: _terminalOptions.map((status) {
                    return DropdownMenuItem(value: status, child: Text(status));
                  }).toList(),
                  onChanged: _isDisconnected ? null : (value) {
                    setState(() => _selectedInsulationTerminal = value);
                    viewModel.switchboxIr = (value == '선택') ? null : value;
                  },
                ),
              ),

              // 10. 지시전압 (숫자 + 확인불가)
              _buildInfoCard(
                '10. 지시전압',
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _voltageController,
                        enabled: !_voltageUnavailable && !_isDisconnected,
                        decoration: InputDecoration(
                          hintText: _voltageUnavailable ? '확인불가' : '숫자 입력',
                          border: const OutlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          suffixText: 'V',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onChanged: (value) => viewModel.gpumpNoise2 = value,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Row(
                      children: [
                        Checkbox(
                          value: _voltageUnavailable,
                          onChanged: _isDisconnected ? null : (checked) {
                            setState(() => _voltageUnavailable = checked ?? false);
                            if (checked == true) {
                              _voltageController.clear();
                              viewModel.gpumpNoise2 = '확인불가';
                            } else {
                              viewModel.gpumpNoise2 = null;
                            }
                          },
                        ),
                        const Text('확인불가'),
                      ],
                    ),
                  ],
                ),
              ),

              // 11. 지시전류 (숫자 + 확인불가)
              _buildInfoCard(
                '11. 지시전류',
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _currentController,
                        enabled: !_currentUnavailable && !_isDisconnected,
                        decoration: InputDecoration(
                          hintText: _currentUnavailable ? '확인불가' : '숫자 입력',
                          border: const OutlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          suffixText: 'A',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onChanged: (value) => viewModel.gpumpGr2 = value,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Row(
                      children: [
                        Checkbox(
                          value: _currentUnavailable,
                          onChanged: _isDisconnected ? null : (checked) {
                            setState(() => _currentUnavailable = checked ?? false);
                            if (checked == true) {
                              _currentController.clear();
                              viewModel.gpumpGr2 = '확인불가';
                            } else {
                              viewModel.gpumpGr2 = null;
                            }
                          },
                        ),
                        const Text('확인불가'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              _buildSectionHeader('계기기'),
              const SizedBox(height: 16),

              // 13. 휴즈
              _buildInfoCard(
                '13. 휴즈',
                DropdownButtonFormField<String>(
                  value: _selectedFuse,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: _instrumentOptions.map((status) {
                    return DropdownMenuItem(value: status, child: Text(status));
                  }).toList(),
                  onChanged: _isDisconnected ? null : (value) {
                    setState(() => _selectedFuse = value);
                    viewModel.gpumpIr2 = (value == '선택') ? null : value;
                  },
                ),
              ),

              // 14. Floatless
              _buildInfoCard(
                '14. Floatless',
                DropdownButtonFormField<String>(
                  value: _selectedFloatless,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: _instrumentOptions.map((status) {
                    return DropdownMenuItem(value: status, child: Text(status));
                  }).toList(),
                  onChanged: _isDisconnected ? null : (value) {
                    setState(() => _selectedFloatless = value);
                    viewModel.switchboxLook2 = (value == '선택') ? null : value;
                  },
                ),
              ),

              // 15. EOCR
              _buildInfoCard(
                '15. EOCR',
                DropdownButtonFormField<String>(
                  value: _selectedEOCR,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: _instrumentOptions.map((status) {
                    return DropdownMenuItem(value: status, child: Text(status));
                  }).toList(),
                  onChanged: _isDisconnected ? null : (value) {
                    setState(() => _selectedEOCR = value);
                    viewModel.switchboxInst2 = (value == '선택') ? null : value;
                  },
                ),
              ),

              // 16. 마그네틱
              _buildInfoCard(
                '16. 마그네틱',
                DropdownButtonFormField<String>(
                  value: _selectedMagnetic,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: _instrumentOptions.map((status) {
                    return DropdownMenuItem(value: status, child: Text(status));
                  }).toList(),
                  onChanged: _isDisconnected ? null : (value) {
                    setState(() => _selectedMagnetic = value);
                    viewModel.switchboxGr2 = (value == '선택') ? null : value;
                  },
                ),
              ),

              // 17. 램프
              _buildInfoCard(
                '17. 램프',
                DropdownButtonFormField<String>(
                  value: _selectedLamp,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: _instrumentOptions.map((status) {
                    return DropdownMenuItem(value: status, child: Text(status));
                  }).toList(),
                  onChanged: _isDisconnected ? null : (value) {
                    setState(() => _selectedLamp = value);
                    viewModel.switchboxIr2 = (value == '선택') ? null : value;
                  },
                ),
              ),

              const SizedBox(height: 24),
              _buildSectionHeader('배전반'),
              const SizedBox(height: 16),

              // 18. 배전반동작
              _buildInfoCard(
                '18. 배전반동작',
                DropdownButtonFormField<String>(
                  value: _selectedPanelOperation,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: _panelOperationOptions.map((status) {
                    return DropdownMenuItem(value: status, child: Text(status));
                  }).toList(),
                  onChanged: _isDisconnected ? null : (value) {
                    setState(() => _selectedPanelOperation = value);
                    viewModel.switchboxMov = (value == '선택') ? null : value;
                  },
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
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
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
