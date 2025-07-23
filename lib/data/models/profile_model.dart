import 'package:hive/hive.dart';

part 'profile_model.g.dart';

@HiveType(typeId: 0)
class ProfileModel extends HiveObject {
  @HiveField(0)
  final String id; // uuid

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  ProfileModel({required this.id, required this.name, required this.email});
}
