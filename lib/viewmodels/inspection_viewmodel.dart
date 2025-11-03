import 'package:flutter/material.dart';

class InspectionViewModel extends ChangeNotifier {
  // === Page 1 필드 (19개) ===
  String? _wellId;
  String? _inspector;
  String? _inspectDate;
  String? _gpsLongitude1;
  String? _gpsLongitude2;
  String? _gpsLongitude3;
  String? _gpsLatitude1;
  String? _gpsLatitude2;
  String? _gpsLatitude3;
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

  // === Page 5 사진 필드 (18개) ===
  String? _photoPath1;
  String? _photoPath2;
  String? _photoPath3;
  String? _photoPath4;
  String? _photoPath5;
  String? _photoPath6;
  String? _photoPath7;
  String? _photoPath8;
  String? _photoPath9;
  String? _photoPath10;
  String? _photoPath11;
  String? _photoPath12;
  String? _photoPath13;
  String? _photoPath14;
  String? _photoPath15;
  String? _photoPath16;
  String? _photoPath17;
  String? _photoPath18;

  // === Getters (Page 1) ===
  String? get wellId => _wellId;
  String? get inspector => _inspector;
  String? get inspectDate => _inspectDate;
  String? get gpsLongitude1 => _gpsLongitude1;
  String? get gpsLongitude2 => _gpsLongitude2;
  String? get gpsLongitude3 => _gpsLongitude3;
  String? get gpsLatitude1 => _gpsLatitude1;
  String? get gpsLatitude2 => _gpsLatitude2;
  String? get gpsLatitude3 => _gpsLatitude3;
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

  // === Getters (Page 5) ===
  String? get photoPath1 => _photoPath1;
  String? get photoPath2 => _photoPath2;
  String? get photoPath3 => _photoPath3;
  String? get photoPath4 => _photoPath4;
  String? get photoPath5 => _photoPath5;
  String? get photoPath6 => _photoPath6;
  String? get photoPath7 => _photoPath7;
  String? get photoPath8 => _photoPath8;
  String? get photoPath9 => _photoPath9;
  String? get photoPath10 => _photoPath10;
  String? get photoPath11 => _photoPath11;
  String? get photoPath12 => _photoPath12;
  String? get photoPath13 => _photoPath13;
  String? get photoPath14 => _photoPath14;
  String? get photoPath15 => _photoPath15;
  String? get photoPath16 => _photoPath16;
  String? get photoPath17 => _photoPath17;
  String? get photoPath18 => _photoPath18;

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

  set gpsLongitude1(String? value) {
    _gpsLongitude1 = value;
    notifyListeners();
  }

  set gpsLongitude2(String? value) {
    _gpsLongitude2 = value;
    notifyListeners();
  }

  set gpsLongitude3(String? value) {
    _gpsLongitude3 = value;
    notifyListeners();
  }

  set gpsLatitude1(String? value) {
    _gpsLatitude1 = value;
    notifyListeners();
  }

  set gpsLatitude2(String? value) {
    _gpsLatitude2 = value;
    notifyListeners();
  }

  set gpsLatitude3(String? value) {
    _gpsLatitude3 = value;
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

  // === Setters (Page 5) ===
  set photoPath1(String? value) {
    _photoPath1 = value;
    notifyListeners();
  }

  set photoPath2(String? value) {
    _photoPath2 = value;
    notifyListeners();
  }

  set photoPath3(String? value) {
    _photoPath3 = value;
    notifyListeners();
  }

  set photoPath4(String? value) {
    _photoPath4 = value;
    notifyListeners();
  }

  set photoPath5(String? value) {
    _photoPath5 = value;
    notifyListeners();
  }

  set photoPath6(String? value) {
    _photoPath6 = value;
    notifyListeners();
  }

  set photoPath7(String? value) {
    _photoPath7 = value;
    notifyListeners();
  }

  set photoPath8(String? value) {
    _photoPath8 = value;
    notifyListeners();
  }

  set photoPath9(String? value) {
    _photoPath9 = value;
    notifyListeners();
  }

  set photoPath10(String? value) {
    _photoPath10 = value;
    notifyListeners();
  }

  set photoPath11(String? value) {
    _photoPath11 = value;
    notifyListeners();
  }

  set photoPath12(String? value) {
    _photoPath12 = value;
    notifyListeners();
  }

  set photoPath13(String? value) {
    _photoPath13 = value;
    notifyListeners();
  }

  set photoPath14(String? value) {
    _photoPath14 = value;
    notifyListeners();
  }

  set photoPath15(String? value) {
    _photoPath15 = value;
    notifyListeners();
  }

  set photoPath16(String? value) {
    _photoPath16 = value;
    notifyListeners();
  }

  set photoPath17(String? value) {
    _photoPath17 = value;
    notifyListeners();
  }

  set photoPath18(String? value) {
    _photoPath18 = value;
    notifyListeners();
  }

  // === 초기화 메서드 ===
  void reset() {
    // Page 1
    _wellId = null;
    _inspector = null;
    _inspectDate = null;
    _gpsLongitude1 = null;
    _gpsLongitude2 = null;
    _gpsLongitude3 = null;
    _gpsLatitude1 = null;
    _gpsLatitude2 = null;
    _gpsLatitude3 = null;
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

    // Page 5
    _photoPath1 = null;
    _photoPath2 = null;
    _photoPath3 = null;
    _photoPath4 = null;
    _photoPath5 = null;
    _photoPath6 = null;
    _photoPath7 = null;
    _photoPath8 = null;
    _photoPath9 = null;
    _photoPath10 = null;
    _photoPath11 = null;
    _photoPath12 = null;
    _photoPath13 = null;
    _photoPath14 = null;
    _photoPath15 = null;
    _photoPath16 = null;
    _photoPath17 = null;
    _photoPath18 = null;

    notifyListeners();
  }

  // === Firestore 저장용 데이터 변환 ===
  Map<String, dynamic> toFirestore() {
    return {
      'basicInfo': {
        'WELL_ID': _wellId,
        'INSPECTOR': _inspector,
        'INSPECT_DATE': _inspectDate,
        'GPS_LONGITUDE_1': _gpsLongitude1,
        'GPS_LONGITUDE_2': _gpsLongitude2,
        'GPS_LONGITUDE_3': _gpsLongitude3,
        'GPS_LATITUDE_1': _gpsLatitude1,
        'GPS_LATITUDE_2': _gpsLatitude2,
        'GPS_LATITUDE_3': _gpsLatitude3,
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
      'photos': {
        'PHOTO_PATH_1': _photoPath1,
        'PHOTO_PATH_2': _photoPath2,
        'PHOTO_PATH_3': _photoPath3,
        'PHOTO_PATH_4': _photoPath4,
        'PHOTO_PATH_5': _photoPath5,
        'PHOTO_PATH_6': _photoPath6,
        'PHOTO_PATH_7': _photoPath7,
        'PHOTO_PATH_8': _photoPath8,
        'PHOTO_PATH_9': _photoPath9,
        'PHOTO_PATH_10': _photoPath10,
        'PHOTO_PATH_11': _photoPath11,
        'PHOTO_PATH_12': _photoPath12,
        'PHOTO_PATH_13': _photoPath13,
        'PHOTO_PATH_14': _photoPath14,
        'PHOTO_PATH_15': _photoPath15,
        'PHOTO_PATH_16': _photoPath16,
        'PHOTO_PATH_17': _photoPath17,
        'PHOTO_PATH_18': _photoPath18,
      },
    };
  }
}
