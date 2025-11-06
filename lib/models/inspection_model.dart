import 'package:hive/hive.dart';

part 'inspection_model.g.dart';

@HiveType(typeId: 0)
class InspectionModel extends HiveObject {
  // Page 1 필드 (13개)
  @HiveField(0)
  String? wellId;

  @HiveField(1)
  String? inspector;

  @HiveField(2)
  String? inspectDate;

  @HiveField(3)
  String? yangsuType;

  @HiveField(4)
  String? chkSphere2;

  @HiveField(5)
  String? constDate2;

  @HiveField(6)
  String? polprtCovcorSt;

  @HiveField(7)
  String? boonsu2;

  @HiveField(8)
  String? inspectorDept2;

  @HiveField(9)
  String? frgSt;

  @HiveField(10)
  String? prtCrkSt;

  @HiveField(11)
  String? prtLeakSt;

  @HiveField(12)
  String? prtSsdSt;

  // Page 2 필드 (18개)
  @HiveField(13)
  String? flowMeterYn;

  @HiveField(14)
  String? chulsufacYn;

  @HiveField(15)
  String? suwicheckpipeYn;

  @HiveField(16)
  String? wlPondHeight2;

  @HiveField(17)
  String? electricYn;

  @HiveField(18)
  String? weighMeterId;

  @HiveField(19)
  String? weighMeterNum;

  @HiveField(20)
  String? wlPumpDischarge1;

  @HiveField(21)
  String? flowMeterNum;

  @HiveField(22)
  String? watTemp;

  @HiveField(23)
  String? junki;

  @HiveField(24)
  String? ph;

  @HiveField(25)
  String? naturalLevel1;

  @HiveField(26)
  String? facStatus;

  @HiveField(27)
  String? notuseReason;

  @HiveField(28)
  String? alterFac;

  @HiveField(29)
  String? notuse;

  @HiveField(30)
  String? useContinue;

  // Page 3 필드 (18개)
  @HiveField(31)
  String? pumpIr;

  @HiveField(32)
  String? wtPipeCor2;

  @HiveField(33)
  String? pumpOpSt;

  @HiveField(34)
  String? wlGenPumpCount;

  @HiveField(35)
  String? pumpFlow;

  @HiveField(36)
  String? switchboxLook;

  @HiveField(37)
  String? switchboxInst;

  @HiveField(38)
  String? pumpGr2;

  @HiveField(39)
  String? switchboxGr;

  @HiveField(40)
  String? switchboxIr;

  @HiveField(41)
  String? gpumpNoise2;

  @HiveField(42)
  String? gpumpGr2;

  @HiveField(43)
  String? gpumpIr2;

  @HiveField(44)
  String? switchboxLook2;

  @HiveField(45)
  String? switchboxInst2;

  @HiveField(46)
  String? switchboxGr2;

  @HiveField(47)
  String? switchboxIr2;

  @HiveField(48)
  String? switchboxMov;

  // Page 4 필드 (1개)
  @HiveField(49)
  String? other;

  // 메타데이터
  @HiveField(50)
  String? id; // 고유 ID (timestamp 기반)

  @HiveField(51)
  DateTime? createdAt;

  @HiveField(52)
  DateTime? updatedAt;

  InspectionModel({
    this.wellId,
    this.inspector,
    this.inspectDate,
    this.yangsuType,
    this.chkSphere2,
    this.constDate2,
    this.polprtCovcorSt,
    this.boonsu2,
    this.inspectorDept2,
    this.frgSt,
    this.prtCrkSt,
    this.prtLeakSt,
    this.prtSsdSt,
    this.flowMeterYn,
    this.chulsufacYn,
    this.suwicheckpipeYn,
    this.wlPondHeight2,
    this.electricYn,
    this.weighMeterId,
    this.weighMeterNum,
    this.wlPumpDischarge1,
    this.flowMeterNum,
    this.watTemp,
    this.junki,
    this.ph,
    this.naturalLevel1,
    this.facStatus,
    this.notuseReason,
    this.alterFac,
    this.notuse,
    this.useContinue,
    this.pumpIr,
    this.wtPipeCor2,
    this.pumpOpSt,
    this.wlGenPumpCount,
    this.pumpFlow,
    this.switchboxLook,
    this.switchboxInst,
    this.pumpGr2,
    this.switchboxGr,
    this.switchboxIr,
    this.gpumpNoise2,
    this.gpumpGr2,
    this.gpumpIr2,
    this.switchboxLook2,
    this.switchboxInst2,
    this.switchboxGr2,
    this.switchboxIr2,
    this.switchboxMov,
    this.other,
    this.id,
    this.createdAt,
    this.updatedAt,
  });

  // ViewModel로부터 생성
  factory InspectionModel.fromViewModel(dynamic viewModel) {
    final now = DateTime.now();
    return InspectionModel(
      id: now.millisecondsSinceEpoch.toString(),
      createdAt: now,
      updatedAt: now,
      // Page 1
      wellId: viewModel.wellId,
      inspector: viewModel.inspector,
      inspectDate: viewModel.inspectDate,
      yangsuType: viewModel.yangsuType,
      chkSphere2: viewModel.chkSphere2,
      constDate2: viewModel.constDate2,
      polprtCovcorSt: viewModel.polprtCovcorSt,
      boonsu2: viewModel.boonsu2,
      inspectorDept2: viewModel.inspectorDept2,
      frgSt: viewModel.frgSt,
      prtCrkSt: viewModel.prtCrkSt,
      prtLeakSt: viewModel.prtLeakSt,
      prtSsdSt: viewModel.prtSsdSt,
      // Page 2
      flowMeterYn: viewModel.flowMeterYn,
      chulsufacYn: viewModel.chulsufacYn,
      suwicheckpipeYn: viewModel.suwicheckpipeYn,
      wlPondHeight2: viewModel.wlPondHeight2,
      electricYn: viewModel.electricYn,
      weighMeterId: viewModel.weighMeterId,
      weighMeterNum: viewModel.weighMeterNum,
      wlPumpDischarge1: viewModel.wlPumpDischarge1,
      flowMeterNum: viewModel.flowMeterNum,
      watTemp: viewModel.watTemp,
      junki: viewModel.junki,
      ph: viewModel.ph,
      naturalLevel1: viewModel.naturalLevel1,
      facStatus: viewModel.facStatus,
      notuseReason: viewModel.notuseReason,
      alterFac: viewModel.alterFac,
      notuse: viewModel.notuse,
      useContinue: viewModel.useContinue,
      // Page 3
      pumpIr: viewModel.pumpIr,
      wtPipeCor2: viewModel.wtPipeCor2,
      pumpOpSt: viewModel.pumpOpSt,
      wlGenPumpCount: viewModel.wlGenPumpCount,
      pumpFlow: viewModel.pumpFlow,
      switchboxLook: viewModel.switchboxLook,
      switchboxInst: viewModel.switchboxInst,
      pumpGr2: viewModel.pumpGr2,
      switchboxGr: viewModel.switchboxGr,
      switchboxIr: viewModel.switchboxIr,
      gpumpNoise2: viewModel.gpumpNoise2,
      gpumpGr2: viewModel.gpumpGr2,
      gpumpIr2: viewModel.gpumpIr2,
      switchboxLook2: viewModel.switchboxLook2,
      switchboxInst2: viewModel.switchboxInst2,
      switchboxGr2: viewModel.switchboxGr2,
      switchboxIr2: viewModel.switchboxIr2,
      switchboxMov: viewModel.switchboxMov,
      // Page 4
      other: viewModel.other,
    );
  }

  // CSV 변환용
  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      '생성일시': createdAt?.toIso8601String(),
      '수정일시': updatedAt?.toIso8601String(),
      // Page 1
      '시설명': wellId,
      '점검자': inspector,
      '점검일자': inspectDate,
      '양수장형태': yangsuType,
      '출입문': chkSphere2,
      '장옥덮개': constDate2,
      '부식도': polprtCovcorSt,
      '관정덮개': boonsu2,
      '스마트안내문': inspectorDept2,
      '이물질': frgSt,
      '균열': prtCrkSt,
      '누수': prtLeakSt,
      '침하': prtSsdSt,
      // Page 2
      '유량계유무': flowMeterYn,
      '출수구유무': chulsufacYn,
      '수위확인관유무': suwicheckpipeYn,
      '수위': wlPondHeight2,
      '전기유무': electricYn,
      '계량기ID': weighMeterId,
      '계량기번호': weighMeterNum,
      '토출량': wlPumpDischarge1,
      '유량계번호': flowMeterNum,
      '수온': watTemp,
      '전기전도도': junki,
      'pH': ph,
      '자연수위': naturalLevel1,
      '시설상태': facStatus,
      '미사용사유': notuseReason,
      '대체시설': alterFac,
      '미사용': notuse,
      '사용계속': useContinue,
      // Page 3
      '펌프절연': pumpIr,
      '배관부식': wtPipeCor2,
      '펌프작동상태': pumpOpSt,
      '펌프대수': wlGenPumpCount,
      '펌프유량': pumpFlow,
      '개폐기외관': switchboxLook,
      '개폐기설치': switchboxInst,
      '펌프접지': pumpGr2,
      '개폐기접지': switchboxGr,
      '개폐기절연': switchboxIr,
      '발전기소음': gpumpNoise2,
      '발전기접지': gpumpGr2,
      '발전기절연': gpumpIr2,
      '제어반외관': switchboxLook2,
      '제어반설치': switchboxInst2,
      '제어반접지': switchboxGr2,
      '제어반절연': switchboxIr2,
      '제어반동작': switchboxMov,
      // Page 4
      '기타사항': other,
    };
  }
}
