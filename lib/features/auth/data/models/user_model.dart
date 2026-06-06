import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.age,
    required super.gender,
    super.weight,
    super.height,
    super.activityLevel,
    super.healthConditions,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      age: json['age'] ?? 0,
      gender: json['gender'] ?? 'male',
      weight: (json['weight'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
      activityLevel: json['activityLevel'] ?? 'moderate',
      healthConditions: List<String>.from(json['healthConditions'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'age': age,
      'gender': gender,
      'weight': weight,
      'height': height,
      'activityLevel': activityLevel,
      'healthConditions': healthConditions,
    };
  }
}
