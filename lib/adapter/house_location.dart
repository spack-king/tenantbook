import 'package:hive/hive.dart';
part 'house_location.g.dart';

@HiveType(typeId: 0)
class Location extends HiveObject{
  @HiveField(0)
  late final String name;
  @HiveField(1)
  late final String id;
  @HiveField(2)
  late final String address;

  Location({
    required this.name,
    required this.id,
    required this.address,
  });
}