import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/inspection_viewmodel.dart';

/// Page 4: 기타사항 (1개 필드)
/// Kotlin의 InspectionPage4Fragment.kt 구현
class InspectionPage4 extends StatefulWidget {
  const InspectionPage4({super.key});

  @override
  State<InspectionPage4> createState() => _InspectionPage4State();
}

class _InspectionPage4State extends State<InspectionPage4> {
  final TextEditingController _otherController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // ViewModel에서 초기값 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<InspectionViewModel>(context, listen: false);
      if (viewModel.other != null) {
        _otherController.text = viewModel.other!;
      }
    });
  }

  @override
  void dispose() {
    _otherController.dispose();
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
              _buildSectionHeader('기타 사항'),
              const SizedBox(height: 16),

              // 기타사항 입력 (Multiline EditText)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '기타사항',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '점검 중 발견한 특이사항이나 추가 메모를 입력하세요',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 12),

                      TextField(
                        controller: _otherController,
                        maxLines: 10,
                        decoration: InputDecoration(
                          hintText: '예) 펌프 소음이 심함. 다음 점검 시 교체 검토 필요',
                          border: const OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        onChanged: (value) {
                          viewModel.other = value.isEmpty ? null : value;
                        },
                      ),

                      const SizedBox(height: 12),

                      // 이전 점검 메모가 있으면 표시
                      if (viewModel.other != null && viewModel.other!.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue[200]!),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline, 
                                size: 20, 
                                color: Colors.blue[700]
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '작성한 메모는 다음 점검 시 자동으로 표시됩니다',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue[900],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 안내 메시지
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lightbulb_outline, color: Colors.amber[900]),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '다음 페이지에서 현장 사진을 촬영해주세요',
                        style: TextStyle(
                          color: Colors.amber[900],
                          fontWeight: FontWeight.w500,
                        ),
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
