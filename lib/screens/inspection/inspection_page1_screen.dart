import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import '../../models/facility_model.dart';
import '../../utils/gps_utils.dart';
import 'package:intl/intl.dart';

class InspectionPage1Screen extends StatefulWidget {
  final Facility facility;
  final String? draftId; // 기존 초안이 있는 경우
  final String? previousMemo; // 이전 점검 메모 (참고용)

  const InspectionPage1Screen({
    Key? key,
    required this.facility,
    this.draftId,
    this.previousMemo,
  }) : super(key: key);

  @override
  State<InspectionPage1Screen> createState() => _InspectionPage1ScreenState();
}

class _InspectionPage1ScreenState extends State<InspectionPage1Screen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isSaving = false;

  // 자동 입력 필드
  late String _wellId;
  late String _inspector;
  late String _inspectDate;
  late String _inspectorDept;

  // GPS 좌표 컨트롤러 (경도)
  final _lonDegController = TextEditingController();
  final _lonMinController = TextEditingController();
  final _lonSecController = TextEditingController();

  // GPS 좌표 컨트롤러 (위도)
  final _latDegController = TextEditingController();
  final _latMinController = TextEditingController();
  final _latSecController = TextEditingController();

  // 양수형태
  String? _yangsuType;
  final List<String> _yangsuTypes = ['양수장', '보호공', '밀폐공', 'L타입', '기타'];

  // 기타 필드 컨트롤러
  final _chkSphere2Controller = TextEditingController();
  final _constDate2Controller = TextEditingController();
  final _polprtCovcorStController = TextEditingController();
  final _boonsu2Controller = TextEditingController();

  // 보호시설 상태
  String? _frgSt; // 프레밍 상태
  String? _prtCrkSt; // 균열 상태
  String? _prtLeakSt; // 누수 상태
  String? _prtSsdSt; // 침하 상태

  final List<String> _statusOptions = ['양호', '불량', '없음'];

  @override
  void initState() {
    super.initState();
    _initializeFields();
    if (widget.draftId != null) {
      _loadDraft();
    }
  }

  void _initializeFields() {
    // 자동 입력 필드 초기화
    _wellId = widget.facility.facilityId;
    
    final user = FirebaseAuth.instance.currentUser;
    _inspector = user?.displayName ?? '점검자';
    
    _inspectDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    
    // 점검자 소속은 사용자 문서에서 가져와야 함 (추후 구현)
    _inspectorDept = ''; // TODO: Firestore에서 가져오기
  }

  Future<void> _loadDraft() async {
    setState(() => _isLoading = true);
    
    try {
      final doc = await FirebaseFirestore.instance
          .collection('inspections')
          .doc(widget.draftId)
          .get();
      
      if (doc.exists) {
        final data = doc.data()!;
        final basicInfo = data['basicInfo'] as Map<String, dynamic>? ?? {};
        
        // GPS 좌표 로드
        _lonDegController.text = basicInfo['GPS_LONGITUDE_1']?.toString() ?? '';
        _lonMinController.text = basicInfo['GPS_LONGITUDE_2']?.toString() ?? '';
        _lonSecController.text = basicInfo['GPS_LONGITUDE_3']?.toString() ?? '';
        
        _latDegController.text = basicInfo['GPS_LATITUDE_1']?.toString() ?? '';
        _latMinController.text = basicInfo['GPS_LATITUDE_2']?.toString() ?? '';
        _latSecController.text = basicInfo['GPS_LATITUDE_3']?.toString() ?? '';
        
        // 기타 필드 로드
        _yangsuType = basicInfo['YANGSU_TYPE'];
        _chkSphere2Controller.text = basicInfo['CHK_SPHERE2'] ?? '';
        _constDate2Controller.text = basicInfo['CONST_DATE2'] ?? '';
        _polprtCovcorStController.text = basicInfo['POLPRT_COVCOR_ST'] ?? '';
        _boonsu2Controller.text = basicInfo['BOONSU2'] ?? '';
        
        // 보호시설 상태 로드
        _frgSt = basicInfo['FRG_ST'];
        _prtCrkSt = basicInfo['PRT_CRK_ST'];
        _prtLeakSt = basicInfo['PRT_LEAK_ST'];
        _prtSsdSt = basicInfo['PRT_SSD_ST'];
        
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('초안 로드 실패: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _captureGPS() async {
    setState(() => _isLoading = true);
    
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
        throw Exception('위치 권한이 영구적으로 거부되었습니다. 설정에서 권한을 허용해주세요.');
      }

      // 현재 위치 가져오기
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // 십진법을 도분초로 변환
      final longitude = GPSCoordinate.fromDecimal(position.longitude);
      final latitude = GPSCoordinate.fromDecimal(position.latitude);

      // 컨트롤러에 값 설정
      _lonDegController.text = longitude.degrees.toString();
      _lonMinController.text = longitude.minutes.toString();
      _lonSecController.text = longitude.seconds.toStringAsFixed(2);

      _latDegController.text = latitude.degrees.toString();
      _latMinController.text = latitude.minutes.toString();
      _latSecController.text = latitude.seconds.toStringAsFixed(2);

      setState(() {});

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('GPS 좌표를 자동 입력했습니다')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('GPS 좌표 가져오기 실패: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveDraft() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      final basicInfo = {
        'WELL_ID': _wellId,
        'INSPECTOR': _inspector,
        'INSPECT_DATE': _inspectDate,
        'INSPECTOR_DEPT2': _inspectorDept,
        
        // GPS 좌표
        'GPS_LONGITUDE_1': _lonDegController.text.isNotEmpty 
            ? int.tryParse(_lonDegController.text) : null,
        'GPS_LONGITUDE_2': _lonMinController.text.isNotEmpty 
            ? int.tryParse(_lonMinController.text) : null,
        'GPS_LONGITUDE_3': _lonSecController.text.isNotEmpty 
            ? double.tryParse(_lonSecController.text) : null,
        
        'GPS_LATITUDE_1': _latDegController.text.isNotEmpty 
            ? int.tryParse(_latDegController.text) : null,
        'GPS_LATITUDE_2': _latMinController.text.isNotEmpty 
            ? int.tryParse(_latMinController.text) : null,
        'GPS_LATITUDE_3': _latSecController.text.isNotEmpty 
            ? double.tryParse(_latSecController.text) : null,
        
        // 기타 필드
        'YANGSU_TYPE': _yangsuType,
        'CHK_SPHERE2': _chkSphere2Controller.text,
        'CONST_DATE2': _constDate2Controller.text,
        'POLPRT_COVCOR_ST': _polprtCovcorStController.text,
        'BOONSU2': _boonsu2Controller.text,
        
        // 보호시설 상태
        'FRG_ST': _frgSt,
        'PRT_CRK_ST': _prtCrkSt,
        'PRT_LEAK_ST': _prtLeakSt,
        'PRT_SSD_ST': _prtSsdSt,
      };

      final inspectionData = {
        'facilityId': widget.facility.facilityId,
        'facilityName': widget.facility.facilityName,
        'region': widget.facility.region,
        'inspectorId': FirebaseAuth.instance.currentUser!.uid,
        'inspectorName': _inspector,
        'inspectDate': _inspectDate,
        'basicInfo': basicInfo,
        'status': 'draft', // 초안 상태
        'currentPage': 1,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (widget.draftId != null) {
        // 기존 초안 업데이트
        await FirebaseFirestore.instance
            .collection('inspections')
            .doc(widget.draftId)
            .update(inspectionData);
      } else {
        // 새 초안 생성
        inspectionData['createdAt'] = FieldValue.serverTimestamp();
        await FirebaseFirestore.instance
            .collection('inspections')
            .add(inspectionData);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('초안이 저장되었습니다')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('저장 실패: $e')),
        );
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _lonDegController.dispose();
    _lonMinController.dispose();
    _lonSecController.dispose();
    _latDegController.dispose();
    _latMinController.dispose();
    _latSecController.dispose();
    _chkSphere2Controller.dispose();
    _constDate2Controller.dispose();
    _polprtCovcorStController.dispose();
    _boonsu2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('점검입력 1/5 - 기본정보'),
        actions: [
          TextButton.icon(
            onPressed: _isSaving ? null : _saveDraft,
            icon: _isSaving 
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save_outlined),
            label: const Text('임시저장'),
            style: TextButton.styleFrom(foregroundColor: Colors.white),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 자동 입력 정보
            _buildInfoCard(
              title: '점검 기본 정보',
              children: [
                _buildReadOnlyField('관정번호', _wellId),
                _buildReadOnlyField('점검자', _inspector),
                _buildReadOnlyField('점검일자', _inspectDate),
              ],
            ),
            const SizedBox(height: 16),

            // GPS 좌표 입력
            _buildInfoCard(
              title: 'GPS 좌표',
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'GPS 좌표를 입력해주세요',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _isLoading ? null : _captureGPS,
                      icon: const Icon(Icons.my_location, size: 18),
                      label: const Text('자동입력'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // 경도 입력
                Text('경도 (Longitude)', 
                  style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _lonDegController,
                        decoration: const InputDecoration(
                          labelText: '도',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) return null;
                          final deg = int.tryParse(value);
                          if (deg == null || deg < 124 || deg > 132) {
                            return '124-132 범위';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _lonMinController,
                        decoration: const InputDecoration(
                          labelText: '분',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) return null;
                          final min = int.tryParse(value);
                          if (min == null || min < 0 || min >= 60) {
                            return '0-59 범위';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _lonSecController,
                        decoration: const InputDecoration(
                          labelText: '초',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) return null;
                          final sec = double.tryParse(value);
                          if (sec == null || sec < 0 || sec >= 60) {
                            return '0-60 범위';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // 위도 입력
                Text('위도 (Latitude)', 
                  style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _latDegController,
                        decoration: const InputDecoration(
                          labelText: '도',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) return null;
                          final deg = int.tryParse(value);
                          if (deg == null || deg < 33 || deg > 39) {
                            return '33-39 범위';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _latMinController,
                        decoration: const InputDecoration(
                          labelText: '분',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) return null;
                          final min = int.tryParse(value);
                          if (min == null || min < 0 || min >= 60) {
                            return '0-59 범위';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _latSecController,
                        decoration: const InputDecoration(
                          labelText: '초',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) return null;
                          final sec = double.tryParse(value);
                          if (sec == null || sec < 0 || sec >= 60) {
                            return '0-60 범위';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 시설 정보
            _buildInfoCard(
              title: '시설 정보',
              children: [
                DropdownButtonFormField<String>(
                  value: _yangsuType,
                  decoration: const InputDecoration(
                    labelText: '양수형태',
                    border: OutlineInputBorder(),
                  ),
                  items: _yangsuTypes.map((type) {
                    return DropdownMenuItem(value: type, child: Text(type));
                  }).toList(),
                  onChanged: (value) => setState(() => _yangsuType = value),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _chkSphere2Controller,
                  decoration: const InputDecoration(
                    labelText: '점검 범위',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _constDate2Controller,
                  decoration: const InputDecoration(
                    labelText: '시공일자',
                    border: OutlineInputBorder(),
                    hintText: 'YYYY-MM-DD',
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _polprtCovcorStController,
                  decoration: const InputDecoration(
                    labelText: '보호공 덮개/코어 상태',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _boonsu2Controller,
                  decoration: const InputDecoration(
                    labelText: '분수',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 보호시설 상태
            _buildInfoCard(
              title: '보호시설 상태',
              children: [
                _buildStatusDropdown('프레밍 상태', _frgSt, (value) {
                  setState(() => _frgSt = value);
                }),
                const SizedBox(height: 12),
                _buildStatusDropdown('균열 상태', _prtCrkSt, (value) {
                  setState(() => _prtCrkSt = value);
                }),
                const SizedBox(height: 12),
                _buildStatusDropdown('누수 상태', _prtLeakSt, (value) {
                  setState(() => _prtLeakSt = value);
                }),
                const SizedBox(height: 12),
                _buildStatusDropdown('침하 상태', _prtSsdSt, (value) {
                  setState(() => _prtSsdSt = value);
                }),
              ],
            ),
            const SizedBox(height: 24),

            // 다음 버튼
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // TODO: Page 2로 이동
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Page 2는 아직 구현 중입니다')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('다음 (2/5 페이지로)', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({required String title, required List<Widget> children}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        readOnly: true,
      ),
    );
  }

  Widget _buildStatusDropdown(
    String label,
    String? value,
    void Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: _statusOptions.map((status) {
        return DropdownMenuItem(value: status, child: Text(status));
      }).toList(),
      onChanged: onChanged,
    );
  }
}
