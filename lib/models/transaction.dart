import 'package:hive/hive.dart';

part 'transaction.g.dart';

enum TxStatus { successful, pending, cancelled }

@HiveType(typeId: 1)
class PaymentTransaction extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String from;
  
  @HiveField(2)
  final String to;
  
  @HiveField(3)
  final double amount;
  
  @HiveField(4)
  final DateTime timestamp;
  
  @HiveField(5)
  final TxStatus status;
  
  @HiveField(6)
  final String channel; // Bluetooth/NFC/SMS
  
  @HiveField(7)
  bool synced;
  
  @HiveField(8)
  final String? deviceId;
  
  @HiveField(9)
  final String? errorMessage;

  PaymentTransaction({
    required this.id,
    required this.from,
    required this.to,
    required this.amount,
    required this.timestamp,
    required this.status,
    required this.channel,
    this.synced = false,
    this.deviceId,
    this.errorMessage,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'from': from,
      'to': to,
      'amount': amount,
      'timestamp': timestamp.toIso8601String(),
      'status': status.toString(),
      'channel': channel,
      'synced': synced,
      'deviceId': deviceId,
      'errorMessage': errorMessage,
    };
  }

  factory PaymentTransaction.fromMap(Map<String, dynamic> map) {
    return PaymentTransaction(
      id: map['id'],
      from: map['from'],
      to: map['to'],
      amount: map['amount'].toDouble(),
      timestamp: DateTime.parse(map['timestamp']),
      status: TxStatus.values.firstWhere((e) => e.toString() == map['status']),
      channel: map['channel'],
      synced: map['synced'] ?? false,
      deviceId: map['deviceId'],
      errorMessage: map['errorMessage'],
    );
  }

  PaymentTransaction copyWith({
    String? id,
    String? from,
    String? to,
    double? amount,
    DateTime? timestamp,
    TxStatus? status,
    String? channel,
    bool? synced,
    String? deviceId,
    String? errorMessage,
  }) {
    return PaymentTransaction(
      id: id ?? this.id,
      from: from ?? this.from,
      to: to ?? this.to,
      amount: amount ?? this.amount,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      channel: channel ?? this.channel,
      synced: synced ?? this.synced,
      deviceId: deviceId ?? this.deviceId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
