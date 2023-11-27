// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AccountInfoAdapter extends TypeAdapter<AccountInfo> {
  @override
  final int typeId = 0;

  @override
  AccountInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AccountInfo(
      userId: fields[0] as String?,
      name: fields[1] as String?,
      onFirstLogin: fields[2] as bool?,
      avatar: fields[3] as String?,
      description: fields[4] as String?,
      dateOfBirth: fields[5] as String?,
      deviceToken: fields[6] as String?,
      follower: (fields[7] as List?)?.cast<String>(),
      following: (fields[8] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, AccountInfo obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.onFirstLogin)
      ..writeByte(3)
      ..write(obj.avatar)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.dateOfBirth)
      ..writeByte(6)
      ..write(obj.deviceToken)
      ..writeByte(7)
      ..write(obj.follower)
      ..writeByte(8)
      ..write(obj.following);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
