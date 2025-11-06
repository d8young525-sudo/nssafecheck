import 'package:flutter/material.dart';

class InspectionViewModel extends ChangeNotifier {
  // === 편집 모드 상태 ===
  bool _isEditMode = true; // 기본값: 편집 가능
  bool get isEditMode => _isEditMode;
  set isEditMode(bool value) {
    _isEditMode = value;
    notifyListeners();
  }

  // === Page 1 필드 (13개) - GPS 제거됨 ===
  String? _wellId;
  String? _inspector;
  String? _inspectDate;
  String? _yangsuType;
  String? _chkSphere2;
  String? _constDate2;
  String? _polprtCovcorSt;
  String? _boonsu2;
  String? _inspectorDept2;
  String? _frgSt;
  String? _prtCrkSt;
  String? _prtLeakSt;
  String? _prtSsdSt;

  // === Page 2 필드 (18개) ===
  String? _flowMeterYn;
  String? _chulsufacYn;
  String? _suwicheckpipeYn;
  String? _wlPondHeight2;
  String? _electricYn;
  String? _weighMeterId;
  String? _weighMeterNum;
  String? _wlPumpDischarge1;
  String? _flowMeterNum;
  String? _watTemp;
  String? _junki;
  String? _ph;
  String? _naturalLevel1;
  String? _facStatus;
  String? _notuseReason;
  String? _alterFac;
  String? _notuse;
  String? _useContinue;

  // === Page 3 필드 (18개) ===
  String? _pumpIr;
  String? _wtPipeCor2;
  String? _pumpOpSt;
  String? _wlGenPumpCount;
  String? _pumpFlow;
  String? _switchboxLook;
  String? _switchboxInst;
  String? _pumpGr2;
  String? _switchboxGr;
  String? _switchboxIr;
  String? _gpumpNoise2;
  String? _gpumpGr2;
  String? _gpumpIr2;
  String? _switchboxLook2;
  String? _switchboxInst2;
  String? _switchboxGr2;
  String? _switchboxIr2;
  String? _switchboxMov;

  // === Page 4 필드 (1개) ===
  String? _other;



  // === Getters (Page 1) ===
  String? get wellId => _wellId;
  String? get inspector => _inspector;
  String? get inspectDate => _inspectDate;
  String? get yangsuType => _yangsuType;
  String? get chkSphere2 => _chkSphere2;
  String? get constDate2 => _constDate2;
  String? get polprtCovcorSt => _polprtCovcorSt;
  String? get boonsu2 => _boonsu2;
  String? get inspectorDept2 => _inspectorDept2;
  String? get frgSt => _frgSt;
  String? get prtCrkSt => _prtCrkSt;
  String? get prtLeakSt => _prtLeakSt;
  String? get prtSsdSt => _prtSsdSt;

  // === Getters (Page 2) ===
  String? get flowMeterYn => _flowMeterYn;
  String? get chulsufacYn => _chulsufacYn;
  String? get suwicheckpipeYn => _suwicheckpipeYn;
  String? get wlPondHeight2 => _wlPondHeight2;
  String? get electricYn => _electricYn;
  String? get weighMeterId => _weighMeterId;
  String? get weighMeterNum => _weighMeterNum;
  String? get wlPumpDischarge1 => _wlPumpDischarge1;
  String? get flowMeterNum => _flowMeterNum;
  String? get watTemp => _watTemp;
  String? get junki => _junki;
  String? get ph => _ph;
  String? get naturalLevel1 => _naturalLevel1;
  String? get facStatus => _facStatus;
  String? get notuseReason => _notuseReason;
  String? get alterFac => _alterFac;
  String? get notuse => _notuse;
  String? get useContinue => _useContinue;

  // === Getters (Page 3) ===
  String? get pumpIr => _pumpIr;
  String? get wtPipeCor2 => _wtPipeCor2;
  String? get pumpOpSt => _pumpOpSt;
  String? get wlGenPumpCount => _wlGenPumpCount;
  String? get pumpFlow => _pumpFlow;
  String? get switchboxLook => _switchboxLook;
  String? get switchboxInst => _switchboxInst;
  String? get pumpGr2 => _pumpGr2;
  String? get switchboxGr => _switchboxGr;
  String? get switchboxIr => _switchboxIr;
  String? get gpumpNoise2 => _gpumpNoise2;
  String? get gpumpGr2 => _gpumpGr2;
  String? get gpumpIr2 => _gpumpIr2;
  String? get switchboxLook2 => _switchboxLook2;
  String? get switchboxInst2 => _switchboxInst2;
  String? get switchboxGr2 => _switchboxGr2;
  String? get switchboxIr2 => _switchboxIr2;
  String? get switchboxMov => _switchboxMov;

  // === Getters (Page 4) ===
  String? get other => _other;



  // === Setters (Page 1) ===
  set wellId(String? value) {
    _wellId = value;
    notifyListeners();
  }

  set inspector(String? value) {
    _inspector = value;
    notifyListeners();
  }

  set inspectDate(String? value) {
    _inspectDate = value;
    notifyListeners();
  }

  set yangsuType(String? value) {
    _yangsuType = value;
    notifyListeners();
  }

  set chkSphere2(String? value) {
    _chkSphere2 = value;
    notifyListeners();
  }

  set constDate2(String? value) {
    _constDate2 = value;
    notifyListeners();
  }

  set polprtCovcorSt(String? value) {
    _polprtCovcorSt = value;
    notifyListeners();
  }

  set boonsu2(String? value) {
    _boonsu2 = value;
    notifyListeners();
  }

  set inspectorDept2(String? value) {
    _inspectorDept2 = value;
    notifyListeners();
  }

  set frgSt(String? value) {
    _frgSt = value;
    notifyListeners();
  }

  set prtCrkSt(String? value) {
    _prtCrkSt = value;
    notifyListeners();
  }

  set prtLeakSt(String? value) {
    _prtLeakSt = value;
    notifyListeners();
  }

  set prtSsdSt(String? value) {
    _prtSsdSt = value;
    notifyListeners();
  }

  // === Setters (Page 2) ===
  set flowMeterYn(String? value) {
    _flowMeterYn = value;
    notifyListeners();
  }

  set chulsufacYn(String? value) {
    _chulsufacYn = value;
    notifyListeners();
  }

  set suwicheckpipeYn(String? value) {
    _suwicheckpipeYn = value;
    notifyListeners();
  }

  set wlPondHeight2(String? value) {
    _wlPondHeight2 = value;
    notifyListeners();
  }

  set electricYn(String? value) {
    _electricYn = value;
    notifyListeners();
  }

  set weighMeterId(String? value) {
    _weighMeterId = value;
    notifyListeners();
  }

  set weighMeterNum(String? value) {
    _weighMeterNum = value;
    notifyListeners();
  }

  set wlPumpDischarge1(String? value) {
    _wlPumpDischarge1 = value;
    notifyListeners();
  }

  set flowMeterNum(String? value) {
    _flowMeterNum = value;
    notifyListeners();
  }

  set watTemp(String? value) {
    _watTemp = value;
    notifyListeners();
  }

  set junki(String? value) {
    _junki = value;
    notifyListeners();
  }

  set ph(String? value) {
    _ph = value;
    notifyListeners();
  }

  set naturalLevel1(String? value) {
    _naturalLevel1 = value;
    notifyListeners();
  }

  set facStatus(String? value) {
    _facStatus = value;
    notifyListeners();
  }

  set notuseReason(String? value) {
    _notuseReason = value;
    notifyListeners();
  }

  set alterFac(String? value) {
    _alterFac = value;
    notifyListeners();
  }

  set notuse(String? value) {
    _notuse = value;
    notifyListeners();
  }

  set useContinue(String? value) {
    _useContinue = value;
    notifyListeners();
  }

  // === Setters (Page 3) ===
  set pumpIr(String? value) {
    _pumpIr = value;
    notifyListeners();
  }

  set wtPipeCor2(String? value) {
    _wtPipeCor2 = value;
    notifyListeners();
  }

  set pumpOpSt(String? value) {
    _pumpOpSt = value;
    notifyListeners();
  }

  set wlGenPumpCount(String? value) {
    _wlGenPumpCount = value;
    notifyListeners();
  }

  set pumpFlow(String? value) {
    _pumpFlow = value;
    notifyListeners();
  }

  set switchboxLook(String? value) {
    _switchboxLook = value;
    notifyListeners();
  }

  set switchboxInst(String? value) {
    _switchboxInst = value;
    notifyListeners();
  }

  set pumpGr2(String? value) {
    _pumpGr2 = value;
    notifyListeners();
  }

  set switchboxGr(String? value) {
    _switchboxGr = value;
    notifyListeners();
  }

  set switchboxIr(String? value) {
    _switchboxIr = value;
    notifyListeners();
  }

  set gpumpNoise2(String? value) {
    _gpumpNoise2 = value;
    notifyListeners();
  }

  set gpumpGr2(String? value) {
    _gpumpGr2 = value;
    notifyListeners();
  }

  set gpumpIr2(String? value) {
    _gpumpIr2 = value;
    notifyListeners();
  }

  set switchboxLook2(String? value) {
    _switchboxLook2 = value;
    notifyListeners();
  }

  set switchboxInst2(String? value) {
    _switchboxInst2 = value;
    notifyListeners();
  }

  set switchboxGr2(String? value) {
    _switchboxGr2 = value;
    notifyListeners();
  }

  set switchboxIr2(String? value) {
    _switchboxIr2 = value;
    notifyListeners();
  }

  set switchboxMov(String? value) {
    _switchboxMov = value;
    notifyListeners();
  }

  // === Setters (Page 4) ===
  set other(String? value) {
    _other = value;
    notifyListeners();
  }



  // === 초기화 메서드 ===
  void reset() {
    // Page 1
    _wellId = null;
    _inspector = null;
    _inspectDate = null;
    _yangsuType = null;
    _chkSphere2 = null;
    _constDate2 = null;
    _polprtCovcorSt = null;
    _boonsu2 = null;
    _inspectorDept2 = null;
    _frgSt = null;
    _prtCrkSt = null;
    _prtLeakSt = null;
    _prtSsdSt = null;

    // Page 2
    _flowMeterYn = null;
    _chulsufacYn = null;
    _suwicheckpipeYn = null;
    _wlPondHeight2 = null;
    _electricYn = null;
    _weighMeterId = null;
    _weighMeterNum = null;
    _wlPumpDischarge1 = null;
    _flowMeterNum = null;
    _watTemp = null;
    _junki = null;
    _ph = null;
    _naturalLevel1 = null;
    _facStatus = null;
    _notuseReason = null;
    _alterFac = null;
    _notuse = null;
    _useContinue = null;

    // Page 3
    _pumpIr = null;
    _wtPipeCor2 = null;
    _pumpOpSt = null;
    _wlGenPumpCount = null;
    _pumpFlow = null;
    _switchboxLook = null;
    _switchboxInst = null;
    _pumpGr2 = null;
    _switchboxGr = null;
    _switchboxIr = null;
    _gpumpNoise2 = null;
    _gpumpGr2 = null;
    _gpumpIr2 = null;
    _switchboxLook2 = null;
    _switchboxInst2 = null;
    _switchboxGr2 = null;
    _switchboxIr2 = null;
    _switchboxMov = null;

    // Page 4
    _other = null;

    notifyListeners();
  }

  // === Firestore 저장용 데이터 변환 ===
  Map<String, dynamic> toFirestore() {
    return {
      'basicInfo': {
        'WELL_ID': _wellId,
        'INSPECTOR': _inspector,
        'INSPECT_DATE': _inspectDate,
        'YANGSU_TYPE': _yangsuType,
        'CHK_SPHERE2': _chkSphere2,
        'CONST_DATE2': _constDate2,
        'POLPRT_COVCOR_ST': _polprtCovcorSt,
        'BOONSU2': _boonsu2,
        'INSPECTOR_DEPT2': _inspectorDept2,
        'FRG_ST': _frgSt,
        'PRT_CRK_ST': _prtCrkSt,
        'PRT_LEAK_ST': _prtLeakSt,
        'PRT_SSD_ST': _prtSsdSt,
      },
      'facilities': {
        'FLOW_METER_YN': _flowMeterYn,
        'CHULSUFAC_YN': _chulsufacYn,
        'SUWICHECKPIPE_YN': _suwicheckpipeYn,
        'WL_POND_HEIGHT2': _wlPondHeight2,
        'ELECTRIC_YN': _electricYn,
        'WEIGH_METER_ID': _weighMeterId,
        'WEIGH_METER_NUM': _weighMeterNum,
        'WL_PUMP_DISCHARGE_1': _wlPumpDischarge1,
        'FLOW_METER_NUM': _flowMeterNum,
        'WAT_TEMP': _watTemp,
        'JUNKI': _junki,
        'PH': _ph,
        'NATURAL_LEVEL_1': _naturalLevel1,
        'FAC_STATUS': _facStatus,
        'NOTUSE_REASON': _notuseReason,
        'ALTER_FAC': _alterFac,
        'NOTUSE': _notuse,
        'USE_CONTINUE': _useContinue,
      },
      'electrical': {
        'PUMP_IR': _pumpIr,
        'WT_PIPE_COR2': _wtPipeCor2,
        'PUMP_OP_ST': _pumpOpSt,
        'WL_GEN_PUMP_COUNT': _wlGenPumpCount,
        'PUMP_FLOW': _pumpFlow,
        'SWITCHBOX_LOOK': _switchboxLook,
        'SWITCHBOX_INST': _switchboxInst,
        'PUMP_GR2': _pumpGr2,
        'SWITCHBOX_GR': _switchboxGr,
        'SWITCHBOX_IR': _switchboxIr,
        'GPUMP_NOISE2': _gpumpNoise2,
        'GPUMP_GR2': _gpumpGr2,
        'GPUMP_IR2': _gpumpIr2,
        'SWITCHBOX_LOOK2': _switchboxLook2,
        'SWITCHBOX_INST2': _switchboxInst2,
        'SWITCHBOX_GR2': _switchboxGr2,
        'SWITCHBOX_IR2': _switchboxIr2,
        'SWITCHBOX_MOV': _switchboxMov,
      },
      'assessment': {
        'OTHER': _other,
      },
    };
  }
}
