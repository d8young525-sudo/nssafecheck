// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InspectionModelAdapter extends TypeAdapter<InspectionModel> {
  @override
  final int typeId = 0;

  @override
  InspectionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InspectionModel(
      wellId: fields[0] as String?,
      inspector: fields[1] as String?,
      inspectDate: fields[2] as String?,
      yangsuType: fields[3] as String?,
      chkSphere2: fields[4] as String?,
      constDate2: fields[5] as String?,
      polprtCovcorSt: fields[6] as String?,
      boonsu2: fields[7] as String?,
      inspectorDept2: fields[8] as String?,
      frgSt: fields[9] as String?,
      prtCrkSt: fields[10] as String?,
      prtLeakSt: fields[11] as String?,
      prtSsdSt: fields[12] as String?,
      flowMeterYn: fields[13] as String?,
      chulsufacYn: fields[14] as String?,
      suwicheckpipeYn: fields[15] as String?,
      wlPondHeight2: fields[16] as String?,
      electricYn: fields[17] as String?,
      weighMeterId: fields[18] as String?,
      weighMeterNum: fields[19] as String?,
      wlPumpDischarge1: fields[20] as String?,
      flowMeterNum: fields[21] as String?,
      watTemp: fields[22] as String?,
      junki: fields[23] as String?,
      ph: fields[24] as String?,
      naturalLevel1: fields[25] as String?,
      facStatus: fields[26] as String?,
      notuseReason: fields[27] as String?,
      alterFac: fields[28] as String?,
      notuse: fields[29] as String?,
      useContinue: fields[30] as String?,
      pumpIr: fields[31] as String?,
      wtPipeCor2: fields[32] as String?,
      pumpOpSt: fields[33] as String?,
      wlGenPumpCount: fields[34] as String?,
      pumpFlow: fields[35] as String?,
      switchboxLook: fields[36] as String?,
      switchboxInst: fields[37] as String?,
      pumpGr2: fields[38] as String?,
      switchboxGr: fields[39] as String?,
      switchboxIr: fields[40] as String?,
      gpumpNoise2: fields[41] as String?,
      gpumpGr2: fields[42] as String?,
      gpumpIr2: fields[43] as String?,
      switchboxLook2: fields[44] as String?,
      switchboxInst2: fields[45] as String?,
      switchboxGr2: fields[46] as String?,
      switchboxIr2: fields[47] as String?,
      switchboxMov: fields[48] as String?,
      other: fields[49] as String?,
      id: fields[50] as String?,
      createdAt: fields[51] as DateTime?,
      updatedAt: fields[52] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, InspectionModel obj) {
    writer
      ..writeByte(53)
      ..writeByte(0)
      ..write(obj.wellId)
      ..writeByte(1)
      ..write(obj.inspector)
      ..writeByte(2)
      ..write(obj.inspectDate)
      ..writeByte(3)
      ..write(obj.yangsuType)
      ..writeByte(4)
      ..write(obj.chkSphere2)
      ..writeByte(5)
      ..write(obj.constDate2)
      ..writeByte(6)
      ..write(obj.polprtCovcorSt)
      ..writeByte(7)
      ..write(obj.boonsu2)
      ..writeByte(8)
      ..write(obj.inspectorDept2)
      ..writeByte(9)
      ..write(obj.frgSt)
      ..writeByte(10)
      ..write(obj.prtCrkSt)
      ..writeByte(11)
      ..write(obj.prtLeakSt)
      ..writeByte(12)
      ..write(obj.prtSsdSt)
      ..writeByte(13)
      ..write(obj.flowMeterYn)
      ..writeByte(14)
      ..write(obj.chulsufacYn)
      ..writeByte(15)
      ..write(obj.suwicheckpipeYn)
      ..writeByte(16)
      ..write(obj.wlPondHeight2)
      ..writeByte(17)
      ..write(obj.electricYn)
      ..writeByte(18)
      ..write(obj.weighMeterId)
      ..writeByte(19)
      ..write(obj.weighMeterNum)
      ..writeByte(20)
      ..write(obj.wlPumpDischarge1)
      ..writeByte(21)
      ..write(obj.flowMeterNum)
      ..writeByte(22)
      ..write(obj.watTemp)
      ..writeByte(23)
      ..write(obj.junki)
      ..writeByte(24)
      ..write(obj.ph)
      ..writeByte(25)
      ..write(obj.naturalLevel1)
      ..writeByte(26)
      ..write(obj.facStatus)
      ..writeByte(27)
      ..write(obj.notuseReason)
      ..writeByte(28)
      ..write(obj.alterFac)
      ..writeByte(29)
      ..write(obj.notuse)
      ..writeByte(30)
      ..write(obj.useContinue)
      ..writeByte(31)
      ..write(obj.pumpIr)
      ..writeByte(32)
      ..write(obj.wtPipeCor2)
      ..writeByte(33)
      ..write(obj.pumpOpSt)
      ..writeByte(34)
      ..write(obj.wlGenPumpCount)
      ..writeByte(35)
      ..write(obj.pumpFlow)
      ..writeByte(36)
      ..write(obj.switchboxLook)
      ..writeByte(37)
      ..write(obj.switchboxInst)
      ..writeByte(38)
      ..write(obj.pumpGr2)
      ..writeByte(39)
      ..write(obj.switchboxGr)
      ..writeByte(40)
      ..write(obj.switchboxIr)
      ..writeByte(41)
      ..write(obj.gpumpNoise2)
      ..writeByte(42)
      ..write(obj.gpumpGr2)
      ..writeByte(43)
      ..write(obj.gpumpIr2)
      ..writeByte(44)
      ..write(obj.switchboxLook2)
      ..writeByte(45)
      ..write(obj.switchboxInst2)
      ..writeByte(46)
      ..write(obj.switchboxGr2)
      ..writeByte(47)
      ..write(obj.switchboxIr2)
      ..writeByte(48)
      ..write(obj.switchboxMov)
      ..writeByte(49)
      ..write(obj.other)
      ..writeByte(50)
      ..write(obj.id)
      ..writeByte(51)
      ..write(obj.createdAt)
      ..writeByte(52)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InspectionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
