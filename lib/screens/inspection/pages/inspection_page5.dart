import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../viewmodels/inspection_viewmodel.dart';

/// Page 5: 사진촬영 (18개 사진)
/// 사진을 로컬 스토리지에 저장
class InspectionPage5 extends StatefulWidget {
  const InspectionPage5({super.key});

  @override
  State<InspectionPage5> createState() => _InspectionPage5State();
}

class _InspectionPage5State extends State<InspectionPage5> {
  final ImagePicker _picker = ImagePicker();
  
  // 18개 사진 항목 라벨
  final List<String> _photoLabels = [
    '1. 시설전경',
    '2. 양수시설',
    '3. 문/뚜껑',
    '4. 부식/침하',
    '5. 관측공',
    '6. 표지판',
    '7. 이물질',
    '8. 균열',
    '9. 누수',
    '10. 침하',
    '11. 유량계',
    '12. 양수설비',
    '13. 수중모터',
    '14. 펌프',
    '15. 분전함',
    '16. 계기기',
    '17. 판넬',
    '18. 기타',
  ];

  // 18개 사진 경로 저장
  final List<String?> _photoPaths = List<String?>.filled(18, null);

  @override
  void initState() {
    super.initState();
    _loadViewModelData();
  }

  void _loadViewModelData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<InspectionViewModel>(context, listen: false);
      setState(() {
        _photoPaths[0] = viewModel.photoPath1;
        _photoPaths[1] = viewModel.photoPath2;
        _photoPaths[2] = viewModel.photoPath3;
        _photoPaths[3] = viewModel.photoPath4;
        _photoPaths[4] = viewModel.photoPath5;
        _photoPaths[5] = viewModel.photoPath6;
        _photoPaths[6] = viewModel.photoPath7;
        _photoPaths[7] = viewModel.photoPath8;
        _photoPaths[8] = viewModel.photoPath9;
        _photoPaths[9] = viewModel.photoPath10;
        _photoPaths[10] = viewModel.photoPath11;
        _photoPaths[11] = viewModel.photoPath12;
        _photoPaths[12] = viewModel.photoPath13;
        _photoPaths[13] = viewModel.photoPath14;
        _photoPaths[14] = viewModel.photoPath15;
        _photoPaths[15] = viewModel.photoPath16;
        _photoPaths[16] = viewModel.photoPath17;
        _photoPaths[17] = viewModel.photoPath18;
      });
    });
  }

  /// 사진 촬영 또는 갤러리 선택
  Future<void> _pickImage(int index, ImageSource source) async {
    try {
      // 권한 확인
      if (source == ImageSource.camera) {
        final cameraStatus = await Permission.camera.request();
        if (!cameraStatus.isGranted) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('카메라 권한이 필요합니다')),
          );
          return;
        }
      } else {
        final storageStatus = await Permission.photos.request();
        if (!storageStatus.isGranted) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('저장소 권한이 필요합니다')),
          );
          return;
        }
      }

      // 이미지 선택
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image == null) return;

      // ViewModel에서 시설명 가져오기
      if (!mounted) return;
      final viewModel = Provider.of<InspectionViewModel>(context, listen: false);
      final wellId = viewModel.wellId ?? 'UNKNOWN';
      
      // 앱 전용 디렉토리에 저장
      final directory = await getApplicationDocumentsDirectory();
      final inspectionDir = Directory('${directory.path}/inspections/$wellId');
      if (!await inspectionDir.exists()) {
        await inspectionDir.create(recursive: true);
      }

      // 파일명: {시설명}-{번호}.jpg (예: YI-003-1.jpg)
      final fileName = '$wellId-${index + 1}.jpg';
      final savedPath = '${inspectionDir.path}/$fileName';

      // 파일 복사 (로컬 저장)
      final File imageFile = File(image.path);
      await imageFile.copy(savedPath);

      // 이전 사진 파일 삭제 (저장공간 절약)
      if (_photoPaths[index] != null) {
        final oldFile = File(_photoPaths[index]!);
        if (await oldFile.exists()) {
          await oldFile.delete();
        }
      }

      // ViewModel 업데이트
      setState(() {
        _photoPaths[index] = savedPath;
      });

      // ViewModel 업데이트
      _updateViewModelPhoto(viewModel, index, savedPath);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${_photoLabels[index]} 사진이 저장되었습니다')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('사진 저장 실패: $e')),
      );
    }
  }

  /// ViewModel에 사진 경로 업데이트
  void _updateViewModelPhoto(InspectionViewModel viewModel, int index, String path) {
    switch (index) {
      case 0: viewModel.photoPath1 = path; break;
      case 1: viewModel.photoPath2 = path; break;
      case 2: viewModel.photoPath3 = path; break;
      case 3: viewModel.photoPath4 = path; break;
      case 4: viewModel.photoPath5 = path; break;
      case 5: viewModel.photoPath6 = path; break;
      case 6: viewModel.photoPath7 = path; break;
      case 7: viewModel.photoPath8 = path; break;
      case 8: viewModel.photoPath9 = path; break;
      case 9: viewModel.photoPath10 = path; break;
      case 10: viewModel.photoPath11 = path; break;
      case 11: viewModel.photoPath12 = path; break;
      case 12: viewModel.photoPath13 = path; break;
      case 13: viewModel.photoPath14 = path; break;
      case 14: viewModel.photoPath15 = path; break;
      case 15: viewModel.photoPath16 = path; break;
      case 16: viewModel.photoPath17 = path; break;
      case 17: viewModel.photoPath18 = path; break;
    }
  }

  /// 사진 삭제
  Future<void> _deletePhoto(int index) async {
    if (_photoPaths[index] == null) return;

    try {
      // 파일 삭제
      final file = File(_photoPaths[index]!);
      if (await file.exists()) {
        await file.delete();
      }

      // ViewModel 업데이트
      if (!mounted) return;
      final viewModel = Provider.of<InspectionViewModel>(context, listen: false);
      setState(() {
        _photoPaths[index] = null;
      });
      _updateViewModelPhoto(viewModel, index, '');

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${_photoLabels[index]} 사진이 삭제되었습니다')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('사진 삭제 실패: $e')),
      );
    }
  }

  /// 사진 선택 옵션 다이얼로그
  void _showImageSourceDialog(int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.blue),
              title: const Text('카메라로 촬영'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(index, ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.green),
              title: const Text('갤러리에서 선택'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(index, ImageSource.gallery);
              },
            ),
            if (_photoPaths[index] != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('사진 삭제'),
                onTap: () {
                  Navigator.pop(context);
                  _deletePhoto(index);
                },
              ),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('취소'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  /// 사진 미리보기
  void _showPhotoPreview(String photoPath) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: const Text('사진 미리보기'),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            Expanded(
              child: InteractiveViewer(
                panEnabled: true,
                boundaryMargin: const EdgeInsets.all(20),
                minScale: 0.5,
                maxScale: 4.0,
                child: Image.file(
                  File(photoPath),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
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
              _buildSectionHeader('사진 촬영'),
              const SizedBox(height: 16),

              // 안내 메시지
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.camera_alt, color: Colors.blue[700]),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '각 항목을 클릭하여 사진을 촬영하거나 갤러리에서 선택하세요\n사진은 모바일 기기에 저장됩니다',
                        style: TextStyle(
                          color: Colors.blue[900],
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 사진 촬영 그리드
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _photoLabels.length,
                itemBuilder: (context, index) {
                  final hasPhoto = _photoPaths[index] != null && _photoPaths[index]!.isNotEmpty;
                  
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: () => _showImageSourceDialog(index),
                      onLongPress: hasPhoto ? () => _showPhotoPreview(_photoPaths[index]!) : null,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            // 사진 썸네일 또는 아이콘
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: hasPhoto ? Colors.green : Colors.grey[400]!,
                                  width: 2,
                                ),
                              ),
                              child: hasPhoto
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: Image.file(
                                        File(_photoPaths[index]!),
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Icon(
                                      Icons.add_a_photo,
                                      size: 36,
                                      color: Colors.grey[400],
                                    ),
                            ),
                            
                            const SizedBox(width: 16),
                            
                            // 라벨 및 상태
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _photoLabels[index],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    hasPhoto ? '✓ 촬영 완료 (길게 눌러 미리보기)' : '클릭하여 사진 추가',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: hasPhoto ? Colors.green[700] : Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            // 액션 아이콘
                            Icon(
                              hasPhoto ? Icons.check_circle : Icons.camera_alt,
                              color: hasPhoto ? Colors.green : Colors.blue,
                              size: 28,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // 촬영 완료 개수 표시
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.photo_library, color: Colors.green[700]),
                    const SizedBox(width: 12),
                    Text(
                      '촬영 완료: ${_photoPaths.where((p) => p != null && p.isNotEmpty).length} / 18',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[900],
                      ),
                    ),
                  ],
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
}
