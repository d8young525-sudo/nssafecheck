import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import '../../models/facility_model.dart';
import '../../models/user_model.dart';
import '../../services/firestore_service.dart';
import '../../services/excel_service.dart';

class FacilitiesScreen extends StatefulWidget {
  const FacilitiesScreen({super.key});

  @override
  State<FacilitiesScreen> createState() => _FacilitiesScreenState();
}

class _FacilitiesScreenState extends State<FacilitiesScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final ExcelService _excelService = ExcelService();

  List<Facility> _facilities = [];
  List<Facility> _filteredFacilities = [];
  UserModel? _currentUser;
  String? _selectedRegion;
  bool _isLoading = true;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 현재 사용자 정보 가져오기
      User? firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        _currentUser = await _firestoreService.getUserData(firebaseUser.uid);
      }

      // 관정 목록 가져오기
      if (_currentUser != null && _currentUser!.assignedRegions.isNotEmpty) {
        // 담당 지역 관정만 가져오기
        _facilities = await _firestoreService.getFacilitiesByRegions(
          _currentUser!.assignedRegions,
        );
      } else if (_currentUser != null && _currentUser!.isAdmin) {
        // 관리자는 모든 관정 가져오기
        _facilities = await _firestoreService.getAllFacilities();
      } else {
        // 담당 지역이 없는 경우 빈 목록
        _facilities = [];
      }

      _filteredFacilities = List.from(_facilities);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('데이터를 불러오는데 실패했습니다: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _filterByRegion(String? region) {
    setState(() {
      _selectedRegion = region;
      if (region == null || region == '전체') {
        _filteredFacilities = List.from(_facilities);
      } else {
        _filteredFacilities = _facilities
            .where((facility) => facility.region == region)
            .toList();
      }
    });
  }

  Future<void> _uploadExcel() async {
    try {
      // 파일 선택
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );

      if (result == null || result.files.single.path == null) {
        return;
      }

      setState(() {
        _isUploading = true;
      });

      String filePath = result.files.single.path!;

      // 엑셀 파싱
      List<Facility> facilities = await _excelService.parseFacilityExcel(filePath);

      if (facilities.isEmpty) {
        throw Exception('엑셀 파일에서 관정 데이터를 찾을 수 없습니다');
      }

      // Firestore에 일괄 추가
      var uploadResult = await _firestoreService.addFacilitiesBatch(facilities);

      if (!mounted) return;

      if (uploadResult['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '✅ ${uploadResult['successCount']}개 관정이 등록되었습니다',
            ),
            backgroundColor: Colors.green,
          ),
        );

        // 목록 새로고침
        _loadData();
      } else {
        throw Exception('업로드 실패: ${uploadResult['errors']}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('엑셀 업로드 실패: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 지역 목록 추출
    List<String> regions = ['전체', ..._facilities.map((f) => f.region).toSet().toList()];

    return Scaffold(
      appBar: AppBar(
        title: const Text('관정 목록'),
        actions: [
          // 엑셀 업로드 버튼 (관리자만)
          if (_currentUser?.isAdmin ?? false)
            IconButton(
              icon: const Icon(Icons.upload_file),
              onPressed: _isUploading ? null : _uploadExcel,
              tooltip: '엑셀 업로드',
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: '새로고침',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // 지역 필터
                if (regions.length > 2) // '전체' 포함해서 3개 이상일 때만 표시
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: DropdownButtonFormField<String>(
                      value: _selectedRegion ?? '전체',
                      decoration: const InputDecoration(
                        labelText: '지역 선택',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      items: regions.map((region) {
                        return DropdownMenuItem(
                          value: region,
                          child: Text(region),
                        );
                      }).toList(),
                      onChanged: _filterByRegion,
                    ),
                  ),

                // 관정 개수 표시
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Text(
                        '총 ${_filteredFacilities.length}개 관정',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (_currentUser?.assignedRegions.isNotEmpty ?? false) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '담당: ${_currentUser!.assignedRegions.join(", ")}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue[700],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // 관정 목록
                Expanded(
                  child: _filteredFacilities.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _currentUser?.assignedRegions.isEmpty ?? true
                                    ? '담당 지역이 배정되지 않았습니다.\n관리자에게 문의하세요.'
                                    : '등록된 관정이 없습니다.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: _filteredFacilities.length,
                          padding: const EdgeInsets.all(16),
                          itemBuilder: (context, index) {
                            Facility facility = _filteredFacilities[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.blue[100],
                                  child: Text(
                                    facility.facilityId.length > 2
                                        ? facility.facilityId.substring(0, 2)
                                        : facility.facilityId,
                                    style: TextStyle(
                                      color: Colors.blue[900],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  facility.facilityId,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(facility.facilityName),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          size: 14,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          facility.region,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () {
                                  // TODO: 점검 입력 화면으로 이동
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${facility.facilityId} 점검 시작'),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),

      // 업로드 중 표시
      floatingActionButton: _isUploading
          ? const FloatingActionButton(
              onPressed: null,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : null,
    );
  }
}
