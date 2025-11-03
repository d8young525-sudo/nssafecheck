import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/inspection_viewmodel.dart';

/// Page 2: 측정장치 (17개 필드)
/// 6-13번은 숫자 입력 + "확인불가" 체크박스 패턴
class InspectionPage2 extends StatefulWidget {
  const InspectionPage2({super.key});

  @override
  State<InspectionPage2> createState() => _InspectionPage2State();
}

class _InspectionPage2State extends State<InspectionPage2> {
  // 숫자 입력 컨트롤러 (6-13번)
  final _meterIdController = TextEditingController(); // 6. 한전계량기
  final _accumulatedUsageController = TextEditingController(); // 7. 누적사용량
  final _collectionController = TextEditingController(); // 8. 채수량
  final _flowMeterReadingController = TextEditingController(); // 9. 유량계수치
  final _waterTempController = TextEditingController(); // 10. 수온
  final _ecController = TextEditingController(); // 11. EC
  final _phController = TextEditingController(); // 12. pH
  final _naturalLevelController = TextEditingController(); // 13. 자연수위

  // "확인불가" 체크박스 상태
  bool _meterIdUnavailable = false;
  bool _accumulatedUsageUnavailable = false;
  bool _collectionUnavailable = false;
  bool _flowMeterReadingUnavailable = false;
  bool _waterTempUnavailable = false;
  bool _ecUnavailable = false;
  bool _phUnavailable = false;
  bool _naturalLevelUnavailable = false;

  // Dropdown 선택값
  String? _selectedFlowMeter; // 1. 유량계
  String? _selectedWaterDischarge; // 2. 출수장치
  String? _selectedWaterLevelPipe; // 3. 수위측정관
  String? _selectedPressureGauge; // 4. 압력계
  String? _selectedElectricity; // 5. 한전전기
  String? _selectedUsageStatus; // 14. 이용상태
  String? _selectedNonUseReason; // 15. 미활용원인
  String? _selectedAlternateFacility; // 16. 대체시설
  String? _selectedNonUsePlan; // 17. 미활용공 처리방안

  // 1-5번 장비 옵션
  final List<String> _equipmentOptions = ['선택', '유(양호)', '유(고장)', '유(파손)', '유(확인불가)', '무', '확인불가'];

  // 5. 한전전기 옵션
  final List<String> _electricityOptions = ['선택', '유(가동)', '유(단전)', '유(휴전)', '무', '무(개인전기)', '확인불가'];

  // 14. 이용상태 옵션
  final List<String> _usageStatusOptions = [
    '선택',
    '정상',
    '고장',
    '미사용(원상복구 요청)',
    '미사용(원상복구 미요청)',
    '미사용(기타)',
    '원상복구완료',
  ];

  // 15. 미활용원인 옵션
  final List<String> _nonUseReasonOptions = [
    '선택',
    '수량감소',
    '수질불량',
    '시설고장',
    '시설노후',
    '전기료과다',
    '타용수원이용',
    '기타',
  ];

  // 16. 대체시설 옵션
  final List<String> _alternateFacilityOptions = [
    '선택',
    '불필요',
    '필요',
  ];

  // 17. 처리방안 옵션
  final List<String> _nonUsePlanOptions = [
    '선택',
    '폐공처리',
    '보수(정수)후 이용',
    '가뮄대비보존',
    '타용도전환',
    '기타',
  ];

  @override
  void initState() {
    super.initState();
    _loadViewModelData();
  }

  void _loadViewModelData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<InspectionViewModel>(context, listen: false);

      // Dropdown 값 로드
      setState(() {
        _selectedFlowMeter = viewModel.flowMeterYn;
        _selectedWaterDischarge = viewModel.chulsufacYn;
        _selectedWaterLevelPipe = viewModel.suwicheckpipeYn;
        _selectedPressureGauge = viewModel.wlPondHeight2;
        _selectedElectricity = viewModel.electricYn;
        _selectedUsageStatus = viewModel.facStatus;
        _selectedNonUseReason = viewModel.notuseReason;
        _selectedAlternateFacility = viewModel.alterFac;
        _selectedNonUsePlan = viewModel.notuse;
      });

      // 숫자 입력값 로드
      if (viewModel.weighMeterId != null) {
        if (viewModel.weighMeterId == '확인불가') {
          _meterIdUnavailable = true;
        } else {
          _meterIdController.text = viewModel.weighMeterId!;
        }
      }

      if (viewModel.weighMeterNum != null) {
        if (viewModel.weighMeterNum == '확인불가') {
          _accumulatedUsageUnavailable = true;
        } else {
          _accumulatedUsageController.text = viewModel.weighMeterNum!;
        }
      }

      if (viewModel.wlPumpDischarge1 != null) {
        if (viewModel.wlPumpDischarge1 == '확인불가') {
          _collectionUnavailable = true;
        } else {
          _collectionController.text = viewModel.wlPumpDischarge1!;
        }
      }

      if (viewModel.flowMeterNum != null) {
        if (viewModel.flowMeterNum == '확인불가') {
          _flowMeterReadingUnavailable = true;
        } else {
          _flowMeterReadingController.text = viewModel.flowMeterNum!;
        }
      }

      if (viewModel.watTemp != null) {
        if (viewModel.watTemp == '확인불가') {
          _waterTempUnavailable = true;
        } else {
          _waterTempController.text = viewModel.watTemp!;
        }
      }

      if (viewModel.junki != null) {
        if (viewModel.junki == '확인불가') {
          _ecUnavailable = true;
        } else {
          _ecController.text = viewModel.junki!;
        }
      }

      if (viewModel.ph != null) {
        if (viewModel.ph == '확인불가') {
          _phUnavailable = true;
        } else {
          _phController.text = viewModel.ph!;
        }
      }

      if (viewModel.naturalLevel1 != null) {
        if (viewModel.naturalLevel1 == '확인불가') {
          _naturalLevelUnavailable = true;
        } else {
          _naturalLevelController.text = viewModel.naturalLevel1!;
        }
      }

      setState(() {});
    });
  }

  @override
  void dispose() {
    _meterIdController.dispose();
    _accumulatedUsageController.dispose();
    _collectionController.dispose();
    _flowMeterReadingController.dispose();
    _waterTempController.dispose();
    _ecController.dispose();
    _phController.dispose();
    _naturalLevelController.dispose();
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
              _buildSectionHeader('측정 장치'),
              const SizedBox(height: 16),

              // 1. 유량계
              _buildInfoCard(
                '1. 유량계',
                DropdownButtonFormField<String>(
                  value: _selectedFlowMeter,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: _equipmentOptions.map((status) {
                    return DropdownMenuItem(value: status, child: Text(status));
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedFlowMeter = value);
                    viewModel.flowMeterYn = value;
                  },
                ),
              ),

              // 2. 출수장치
              _buildInfoCard(
                '2. 출수장치',
                DropdownButtonFormField<String>(
                  value: _selectedWaterDischarge,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: _equipmentOptions.map((status) {
                    return DropdownMenuItem(value: status, child: Text(status));
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedWaterDischarge = value);
                    viewModel.chulsufacYn = value;
                  },
                ),
              ),

              // 3. 수위측정관
              _buildInfoCard(
                '3. 수위측정관',
                DropdownButtonFormField<String>(
                  value: _selectedWaterLevelPipe,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: _equipmentOptions.map((status) {
                    return DropdownMenuItem(value: status, child: Text(status));
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedWaterLevelPipe = value);
                    viewModel.suwicheckpipeYn = value;
                  },
                ),
              ),

              // 4. 압력계
              _buildInfoCard(
                '4. 압력계',
                DropdownButtonFormField<String>(
                  value: _selectedPressureGauge,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: _equipmentOptions.map((status) {
                    return DropdownMenuItem(value: status, child: Text(status));
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedPressureGauge = value);
                    viewModel.wlPondHeight2 = value;
                  },
                ),
              ),

              // 5. 한전전기
              _buildInfoCard(
                '5. 한전전기',
                DropdownButtonFormField<String>(
                  value: _selectedElectricity,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: _electricityOptions.map((status) {
                    return DropdownMenuItem(value: status, child: Text(status));
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedElectricity = value);
                    viewModel.electricYn = value;
                  },
                ),
              ),

              // 6. 한전계량기 (숫자 + 확인불가)
              _buildNumberFieldWithCheckbox(
                label: '6. 한전계량기',
                controller: _meterIdController,
                isUnavailable: _meterIdUnavailable,
                onCheckboxChanged: (checked) {
                  setState(() => _meterIdUnavailable = checked ?? false);
                  if (checked == true) {
                    _meterIdController.clear();
                    viewModel.weighMeterId = '확인불가';
                  } else {
                    viewModel.weighMeterId = null;
                  }
                },
                onFieldChanged: (value) => viewModel.weighMeterId = value,
              ),

              // 7. 누적사용량 (숫자 + 확인불가)
              _buildNumberFieldWithCheckbox(
                label: '7. 누적사용량',
                controller: _accumulatedUsageController,
                isUnavailable: _accumulatedUsageUnavailable,
                unit: 'kWh',
                onCheckboxChanged: (checked) {
                  setState(() => _accumulatedUsageUnavailable = checked ?? false);
                  if (checked == true) {
                    _accumulatedUsageController.clear();
                    viewModel.weighMeterNum = '확인불가';
                  } else {
                    viewModel.weighMeterNum = null;
                  }
                },
                onFieldChanged: (value) => viewModel.weighMeterNum = value,
              ),

              // 8. 채수량 (숫자 + 확인불가)
              _buildNumberFieldWithCheckbox(
                label: '8. 채수량',
                controller: _collectionController,
                isUnavailable: _collectionUnavailable,
                unit: 'm³',
                onCheckboxChanged: (checked) {
                  setState(() => _collectionUnavailable = checked ?? false);
                  if (checked == true) {
                    _collectionController.clear();
                    viewModel.wlPumpDischarge1 = '확인불가';
                  } else {
                    viewModel.wlPumpDischarge1 = null;
                  }
                },
                onFieldChanged: (value) => viewModel.wlPumpDischarge1 = value,
              ),

              // 9. 유량계수치 (숫자 + 확인불가)
              _buildNumberFieldWithCheckbox(
                label: '9. 유량계수치',
                controller: _flowMeterReadingController,
                isUnavailable: _flowMeterReadingUnavailable,
                unit: 'm³/h',
                onCheckboxChanged: (checked) {
                  setState(() => _flowMeterReadingUnavailable = checked ?? false);
                  if (checked == true) {
                    _flowMeterReadingController.clear();
                    viewModel.flowMeterNum = '확인불가';
                  } else {
                    viewModel.flowMeterNum = null;
                  }
                },
                onFieldChanged: (value) => viewModel.flowMeterNum = value,
              ),

              // 10. 수온 (숫자 + 확인불가)
              _buildNumberFieldWithCheckbox(
                label: '10. 수온',
                controller: _waterTempController,
                isUnavailable: _waterTempUnavailable,
                unit: '℃',
                onCheckboxChanged: (checked) {
                  setState(() => _waterTempUnavailable = checked ?? false);
                  if (checked == true) {
                    _waterTempController.clear();
                    viewModel.watTemp = '확인불가';
                  } else {
                    viewModel.watTemp = null;
                  }
                },
                onFieldChanged: (value) => viewModel.watTemp = value,
              ),

              // 11. EC (숫자 + 확인불가)
              _buildNumberFieldWithCheckbox(
                label: '11. EC',
                controller: _ecController,
                isUnavailable: _ecUnavailable,
                unit: 'μS/cm',
                onCheckboxChanged: (checked) {
                  setState(() => _ecUnavailable = checked ?? false);
                  if (checked == true) {
                    _ecController.clear();
                    viewModel.junki = '확인불가';
                  } else {
                    viewModel.junki = null;
                  }
                },
                onFieldChanged: (value) => viewModel.junki = value,
              ),

              // 12. pH (숫자 + 확인불가)
              _buildNumberFieldWithCheckbox(
                label: '12. pH',
                controller: _phController,
                isUnavailable: _phUnavailable,
                onCheckboxChanged: (checked) {
                  setState(() => _phUnavailable = checked ?? false);
                  if (checked == true) {
                    _phController.clear();
                    viewModel.ph = '확인불가';
                  } else {
                    viewModel.ph = null;
                  }
                },
                onFieldChanged: (value) => viewModel.ph = value,
              ),

              // 13. 자연수위 (숫자 + 확인불가)
              _buildNumberFieldWithCheckbox(
                label: '13. 자연수위',
                controller: _naturalLevelController,
                isUnavailable: _naturalLevelUnavailable,
                unit: 'm',
                onCheckboxChanged: (checked) {
                  setState(() => _naturalLevelUnavailable = checked ?? false);
                  if (checked == true) {
                    _naturalLevelController.clear();
                    viewModel.naturalLevel1 = '확인불가';
                  } else {
                    viewModel.naturalLevel1 = null;
                  }
                },
                onFieldChanged: (value) => viewModel.naturalLevel1 = value,
              ),

              const SizedBox(height: 24),
              _buildSectionHeader('이용 현황'),
              const SizedBox(height: 16),

              // 14. 이용상태
              _buildInfoCard(
                '14. 이용상태',
                DropdownButtonFormField<String>(
                  value: _selectedUsageStatus,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: _usageStatusOptions.map((status) {
                    return DropdownMenuItem(value: status, child: Text(status));
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedUsageStatus = value);
                    viewModel.facStatus = value;
                  },
                ),
              ),

              // 15. 미활용원인 (조건부: 이용상태가 '정상'이 아닐 때만 활성화)
              _buildInfoCard(
                '15. 미활용원인',
                DropdownButtonFormField<String>(
                  value: _selectedNonUseReason,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    filled: _selectedUsageStatus == '정상',
                    fillColor: _selectedUsageStatus == '정상' ? Colors.grey[200] : null,
                  ),
                  items: _nonUseReasonOptions.map((reason) {
                    return DropdownMenuItem(value: reason, child: Text(reason));
                  }).toList(),
                  onChanged: _selectedUsageStatus == '정상' ? null : (value) {
                    setState(() => _selectedNonUseReason = value);
                    viewModel.notuseReason = value;
                  },
                ),
              ),

              // 16. 대체시설
              _buildInfoCard(
                '16. 대체시설',
                DropdownButtonFormField<String>(
                  value: _selectedAlternateFacility,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: _alternateFacilityOptions.map((facility) {
                    return DropdownMenuItem(value: facility, child: Text(facility));
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedAlternateFacility = value);
                    viewModel.alterFac = value;
                  },
                ),
              ),

              // 17. 미활용공 처리방안 (조건부: 대체시설이 '필요'일 때만 활성화)
              _buildInfoCard(
                '17. 미활용공 처리방안',
                DropdownButtonFormField<String>(
                  value: _selectedNonUsePlan,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    filled: _selectedAlternateFacility != '필요',
                    fillColor: _selectedAlternateFacility != '필요' ? Colors.grey[200] : null,
                  ),
                  items: _nonUsePlanOptions.map((plan) {
                    return DropdownMenuItem(value: plan, child: Text(plan));
                  }).toList(),
                  onChanged: _selectedAlternateFacility != '필요' ? null : (value) {
                    setState(() => _selectedNonUsePlan = value);
                    viewModel.notuse = value;
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
