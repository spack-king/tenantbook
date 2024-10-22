import 'package:hive/hive.dart';
part 'tenant.g.dart';

@HiveType(typeId: 1)
class Tenant extends HiveObject{
  @HiveField(0)
  late final String tenant_name;
  @HiveField(1)
  late final String id;
  @HiveField(2)
  late final String profPics;
  @HiveField(3)
  late final String occupation;
  @HiveField(4)
  late final String flat;
  @HiveField(5)
  late final lastPayment;
  @HiveField(6)
  late final int phoneNo;
  @HiveField(7)
  late final int rentAmount;

  Tenant({
    required this.tenant_name,
    required this.id,
    required this.profPics,
    required this.occupation,
    required this.flat,
    required this.lastPayment,
    required this.phoneNo,
    required this.rentAmount,
  });
}