import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/user_model.dart';
import '../../services/firestore_service.dart';
import 'inspection_form_screen.dart';

class InspectionStartScreen extends StatefulWidget {
  const InspectionStartScreen({super.key});

  @override
  State<InspectionStartScreen> createState() => _InspectionStartScreenState();
}

class _InspectionStartScreenState extends State<InspectionStartScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final _formKey = GlobalKey<FormState>();
  
  UserModel? _currentUser;
  String? _selectedRegion;
  final _facilityNumberController = TextEditingController();
  
  bool _isLoading = true;
  bool _isCheckingFacility = false;
  String? _previousMemo;
  
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
  
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }
  
  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    
    try {
      User? firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        _currentUser = await _firestoreService.getUserData(firebaseUser.uid);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('사용자 정보 로드 실패: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
  
  Future<void> _checkPreviousMemo() async {
    if (_selectedRegion == null || _facilityNumberController.text.isEmpty) {
      return;
    }
    
    setState(() {
      _isCheckingFacility = true;
      _previousMemo = null;
    });
    
    try {
      String regionCode = _regionCodes[_selectedRegion]!;
      String fullWellId = '$regionCode-${_facilityNumberController.text}';
      
      // Firestore에서 해당 시설의 가장 최근 점검 데이터 조회
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('inspections')
          .where('facilityId', isEqualTo: fullWellId)
          .where('status', isEqualTo: 'completed')
          .orderBy('inspectDate', descending: true)
          .limit(1)
          .get();
      
      if (querySnapshot.docs.isNotEmpty) {
        var lastInspection = querySnapshot.docs.first.data() as Map<String, dynamic>;
        var assessment = lastInspection['assessment'] as Map<String, dynamic>?;
        
        if (assessment != null && assessment['OTHER'] != null) {
          setState(() {
            _previousMemo = assessment['OTHER'];
          });
        }
      }
    } catch (e) {
      // 에러는 무시 (이전 메모가 없을 수도 있음)
    } finally {
      setState(() => _isCheckingFacility = false);
    }
  }
  
  void _startInspection() {
    // 바로 점검 폼으로 이동 (Page 1에서 시설 정보 입력)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const InspectionFormScreen(),
      ),
    );
  }
  
  @override
  void dispose() {
    _facilityNumberController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    // 사용자 담당 지역 목록
    List<String> availableRegions = _currentUser?.isAdmin ?? false
        ? _regionCodes.keys.toList()
        : _currentUser?.assignedRegions ?? [];
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('점검입력 시작'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // 헤더
            const Icon(
              Icons.assignment_outlined,
              size: 80,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            Text(
              '농업용 공공관정\n정기점검',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            
            // 지역 선택
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '점검 지역',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    DropdownButtonFormField<String>(
                      value: _selectedRegion,
                      decoration: const InputDecoration(
                        labelText: '지역 선택',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_on),
                      ),
                      items: availableRegions.map((region) {
                        return DropdownMenuItem(
                          value: region,
                          child: Text('$region (${_regionCodes[region]})'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedRegion = value;
                          _facilityNumberController.clear();
                          _previousMemo = null;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '지역을 선택해주세요';
                        }
                        return null;
                      },
                    ),
                    
                    if (availableRegions.isEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.orange),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.warning_amber, color: Colors.orange[700]),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '담당 지역이 배정되지 않았습니다.\n관리자에게 문의하세요.',
                                style: TextStyle(color: Colors.orange[900]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // 시설번호 입력
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '시설번호',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 지역 코드 (자동)
                        Container(
                          width: 80,
                          height: 56,
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
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                        
                        // 시설번호 입력
                        Expanded(
                          child: TextFormField(
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
                            onChanged: (value) {
                              if (value.length >= 3) {
                                _checkPreviousMemo();
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '시설번호를 입력해주세요';
                              }
                              if (value.length < 3) {
                                return '최소 3자리 이상 입력해주세요';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 8),
                    Text(
                      '예시: 평택 지역의 경우 001, 002, 003... 형식으로 입력',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // 이전 점검 메모
            if (_isCheckingFacility)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '이전 점검 기록 확인 중...',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              )
            else if (_previousMemo != null)
              Card(
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue[700]),
                          const SizedBox(width: 8),
                          Text(
                            '이전 점검 메모',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[900],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _previousMemo!,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
            const SizedBox(height: 32),
            
            // 점검 시작 버튼
            ElevatedButton(
              onPressed: availableRegions.isEmpty ? null : _startInspection,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                '점검 시작하기',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
