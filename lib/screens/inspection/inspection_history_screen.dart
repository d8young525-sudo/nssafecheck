import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../../models/inspection_model.dart';
import 'inspection_detail_screen.dart';
import 'inspection_export_service.dart';

/// 점검 이력 조회 화면
class InspectionHistoryScreen extends StatefulWidget {
  const InspectionHistoryScreen({super.key});

  @override
  State<InspectionHistoryScreen> createState() => _InspectionHistoryScreenState();
}

class _InspectionHistoryScreenState extends State<InspectionHistoryScreen> {
  String _sortBy = 'date_desc'; // date_desc, date_asc, name_asc

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('점검 이력', style: TextStyle(fontSize: 18)),
            Text('v1.0.8', style: TextStyle(fontSize: 10, color: Colors.white70)),
          ],
        ),
        centerTitle: true,
        actions: [
          // 저장 버튼 (드롭다운)
          PopupMenuButton<String>(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.save, size: 18),
                  SizedBox(width: 4),
                  Text('저장', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
            onSelected: (value) {
              if (value == 'csv') {
                _exportAllCsv(context);
              } else if (value == 'table') {
                _exportAllTables(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'csv',
                child: Row(
                  children: [
                    Icon(Icons.download, size: 18),
                    SizedBox(width: 8),
                    Text('CSV로 출력'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'table',
                child: Row(
                  children: [
                    Icon(Icons.table_chart, size: 18),
                    SizedBox(width: 8),
                    Text('표형식으로 저장'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 4),
          // 정렬 버튼
          PopupMenuButton<String>(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.sort, size: 18),
                  SizedBox(width: 4),
                  Text('정렬', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
            onSelected: (value) {
              setState(() => _sortBy = value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'date_desc',
                child: Text('최신순'),
              ),
              const PopupMenuItem(
                value: 'date_asc',
                child: Text('오래된순'),
              ),
              const PopupMenuItem(
                value: 'name_asc',
                child: Text('시설명순'),
              ),
            ],
          ),
          const SizedBox(width: 4),
          // 전체삭제 버튼
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: '전체삭제',
            onPressed: () => _deleteAllInspections(context),
          ),
        ],
      ),
      body: ValueListenableBuilder<Box<InspectionModel>>(
        valueListenable: Hive.box<InspectionModel>('inspections').listenable(),
        builder: (context, box, _) {
          if (box.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    '저장된 점검 이력이 없습니다',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          // 정렬
          var inspections = box.values.toList();
          if (_sortBy == 'date_desc') {
            inspections.sort((a, b) => 
              (b.createdAt ?? DateTime.now()).compareTo(a.createdAt ?? DateTime.now()));
          } else if (_sortBy == 'date_asc') {
            inspections.sort((a, b) => 
              (a.createdAt ?? DateTime.now()).compareTo(b.createdAt ?? DateTime.now()));
          } else if (_sortBy == 'name_asc') {
            inspections.sort((a, b) => 
              (a.wellId ?? '').compareTo(b.wellId ?? ''));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: inspections.length,
            itemBuilder: (context, index) {
              final inspection = inspections[index];
              return _buildInspectionCard(context, inspection);
            },
          );
        },
      ),
    );
  }

  Widget _buildInspectionCard(BuildContext context, InspectionModel inspection) {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InspectionDetailScreen(
                inspection: inspection,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 헤더
              Row(
                children: [
                  // 시설명
                  Expanded(
                    child: Text(
                      inspection.wellId ?? '시설명 없음',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // 점검자
              Row(
                children: [
                  const Icon(Icons.person, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    inspection.inspector ?? '점검자 없음',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 4),

              // 점검일자
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    inspection.inspectDate ?? '날짜 없음',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 4),

              // 생성일시
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    inspection.createdAt != null
                        ? '저장: ${dateFormat.format(inspection.createdAt!)}'
                        : '저장 시간 없음',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// CSV 일괄 내보내기 (모든 점검 데이터)
  Future<void> _exportAllCsv(BuildContext context) async {
    try {
      final box = Hive.box<InspectionModel>('inspections');
      
      if (box.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('내보낼 데이터가 없습니다')),
          );
        }
        return;
      }

      final allInspections = box.values.toList();
      await InspectionExportService.exportToCsv(allInspections);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${allInspections.length}건의 점검 데이터를 CSV로 내보냈습니다'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('CSV 내보내기 실패: $e')),
        );
      }
    }
  }

  /// 표 형식 일괄 내보내기 (시설별로 각각 PNG/JPG)
  Future<void> _exportAllTables(BuildContext context) async {
    try {
      final box = Hive.box<InspectionModel>('inspections');
      
      if (box.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('내보낼 데이터가 없습니다')),
          );
        }
        return;
      }

      final allInspections = box.values.toList();
      await InspectionExportService.exportToTable(allInspections);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${allInspections.length}건의 점검 데이터를 표 형식으로 내보냈습니다'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('표 형식 내보내기 실패: $e')),
        );
      }
    }
  }

  /// 전체 점검 데이터 삭제
  Future<void> _deleteAllInspections(BuildContext context) async {
    final box = Hive.box<InspectionModel>('inspections');
    
    if (box.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('삭제할 데이터가 없습니다')),
        );
      }
      return;
    }

    // 텍스트 입력 다이얼로그
    final TextEditingController textController = TextEditingController();
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('전체 데이터 삭제'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '현재 ${box.length}건의 점검 데이터가 저장되어 있습니다.',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '모든 데이터를 삭제하시겠습니까?\n삭제된 데이터는 복구할 수 없습니다.',
            ),
            const SizedBox(height: 16),
            const Text(
              '확인하려면 아래에 "삭제" 를 입력하세요:',
              style: TextStyle(
                fontSize: 12,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: textController,
              decoration: const InputDecoration(
                hintText: '삭제',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              if (textController.text == '삭제') {
                Navigator.pop(context, true);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('"삭제" 를 정확히 입력해주세요'),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('삭제'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await box.clear();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('모든 점검 데이터가 삭제되었습니다'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('삭제 실패: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
