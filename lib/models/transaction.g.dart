// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PaymentTransactionAdapter extends TypeAdapter<PaymentTransaction> {
  @override
  final int typeId = 1;

  @override
  PaymentTransaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PaymentTransaction(
      id: fields[0] as String,
      from: fields[1] as String,
      to: fields[2] as String,
      amount: fields[3] as double,
      timestamp: fields[4] as DateTime,
      status: fields[5] as TxStatus,
      channel: fields[6] as String,
      synced: fields[7] as bool,
      deviceId: fields[8] as String?,
      errorMessage: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PaymentTransaction obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.from)
      ..writeByte(2)
      ..write(obj.to)
      ..writeByte(3)
      ..write(obj.amount)
      ..writeByte(4)
      ..write(obj.timestamp)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.channel)
      ..writeByte(7)
      ..write(obj.synced)
      ..writeByte(8)
      ..write(obj.deviceId)
      ..writeByte(9)
      ..write(obj.errorMessage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentTransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
