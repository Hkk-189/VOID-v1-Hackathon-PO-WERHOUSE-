import 'package:hive/hive.dart';

part 'user.g.dart';

enum UserRole { sender, receiver }

@HiveType(typeId: 0)
class AppUser extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String username;
  
  @HiveField(3)
  final String phone;
  
  @HiveField(4)
  final UserRole role;
  
  @HiveField(5)
  final String deviceId;
  
  @HiveField(6)
  final DateTime createdAt;

  AppUser({
    required this.id,
    required this.name,
    required this.username,
    required this.phone,
    required this.role,
    required this.deviceId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'phone': phone,
      'role': role.toString(),
      'deviceId': deviceId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'],
      name: map['name'],
      username: map['username'],
      phone: map['phone'],
      role: UserRole.values.firstWhere((e) => e.toString() == map['role']),
      deviceId: map['deviceId'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
