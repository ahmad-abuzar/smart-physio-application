import 'package:equatable/equatable.dart';

class ExerciseEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String targetMuscle;
  final String category; // stretch, mobility, warmup, strengthening
  final String difficulty; // easy, medium, hard
  final int durationSeconds;
  final int repetitions;
  final int sets;
  final String? videoUrl;
  final String? thumbnailUrl;
  final List<String> instructions;
  final List<String> precautions;

  const ExerciseEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.targetMuscle,
    required this.category,
    required this.difficulty,
    required this.durationSeconds,
    required this.repetitions,
    required this.sets,
    this.videoUrl,
    this.thumbnailUrl,
    required this.instructions,
    required this.precautions,
  });

  @override
  List<Object?> get props => [id, name, targetMuscle];

  String get formattedDuration {
    final minutes = durationSeconds ~/ 60;
    final seconds = durationSeconds % 60;
    if (minutes > 0 && seconds > 0) return '${minutes}m ${seconds}s';
    if (minutes > 0) return '$minutes min';
    return '${seconds}s';
  }
}
