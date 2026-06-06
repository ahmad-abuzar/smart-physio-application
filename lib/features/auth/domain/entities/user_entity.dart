import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final int age;
  final String gender;
  final double? weight;
  final double? height;
  final String activityLevel;
  final List<String> healthConditions;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.gender,
    this.weight,
    this.height,
    this.activityLevel = 'moderate',
    this.healthConditions = const [],
  });

  @override
  List<Object?> get props => [id, name, email, age, gender];
}
