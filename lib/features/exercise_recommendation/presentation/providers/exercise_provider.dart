import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/exercise_local_data.dart';
import '../../domain/entities/exercise_entity.dart';

// All exercises provider
final allExercisesProvider = Provider<List<ExerciseEntity>>((ref) {
  return ExerciseLocalData.getAllExercises();
});

// Exercises filtered by muscle
final exercisesByMuscleProvider =
    Provider.family<List<ExerciseEntity>, String>((ref, muscle) {
  return ExerciseLocalData.getExercisesByMuscle(muscle);
});

// Single exercise by ID
final exerciseByIdProvider =
    Provider.family<ExerciseEntity?, String>((ref, id) {
  return ExerciseLocalData.getExerciseById(id);
});

// Selected muscle filter
final selectedMuscleFilterProvider = StateProvider<String?>((ref) => null);

// Filtered exercises
final filteredExercisesProvider = Provider<List<ExerciseEntity>>((ref) {
  final filter = ref.watch(selectedMuscleFilterProvider);
  final allExercises = ref.watch(allExercisesProvider);

  if (filter == null) return allExercises;
  return allExercises.where((e) => e.targetMuscle == filter).toList();
});
