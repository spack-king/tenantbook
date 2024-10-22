// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TenantAdapter extends TypeAdapter<Tenant> {
  @override
  final int typeId = 1;

  @override
  Tenant read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Tenant(
      tenant_name: fields[0] as String,
      id: fields[1] as String,
      profPics: fields[2] as String,
      occupation: fields[3] as String,
      flat: fields[4] as String,
      lastPayment: fields[5] as dynamic,
      phoneNo: fields[6] as int,
      rentAmount: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Tenant obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.tenant_name)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.profPics)
      ..writeByte(3)
      ..write(obj.occupation)
      ..writeByte(4)
      ..write(obj.flat)
      ..writeByte(5)
      ..write(obj.lastPayment)
      ..writeByte(6)
      ..write(obj.phoneNo)
      ..writeByte(7)
      ..write(obj.rentAmount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TenantAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
