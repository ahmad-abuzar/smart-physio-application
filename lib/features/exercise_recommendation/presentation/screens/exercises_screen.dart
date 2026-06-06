import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/exercise_entity.dart';
import '../providers/exercise_provider.dart';

class ExercisesScreen extends ConsumerWidget {
  const ExercisesScreen({super.key});

  static const List<String?> _muscles = [
    null,
    'shoulder',
    'arm',
    'forearm',
    'thigh',
    'leg',
  ];

  static const List<String> _muscleLabels = [
    'All',
    'Shoulder',
    'Arm',
    'Forearm',
    'Thigh',
    'Leg',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFilter = ref.watch(selectedMuscleFilterProvider);
    final exercises = ref.watch(filteredExercisesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercises'),
      ),
      body: Column(
        children: [
          // Muscle filter chips
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _muscles.length,
              itemBuilder: (context, index) {
                final muscle = _muscles[index];
                final isSelected = selectedFilter == muscle;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(_muscleLabels[index]),
                    selected: isSelected,
                    onSelected: (_) {
                      ref.read(selectedMuscleFilterProvider.notifier).state =
                          muscle;
                    },
                    selectedColor: AppColors.primary.withValues(alpha: 0.2),
                    checkmarkColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          // Exercise count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  '${exercises.length} exercises',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Exercise list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                return _ExerciseCard(
                  exercise: exercises[index],
                  onTap: () =>
                      context.push('/exercise-detail/${exercises[index].id}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  final ExerciseEntity exercise;
  final VoidCallback onTap;

  const _ExerciseCard({required this.exercise, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: _muscleColor(exercise.targetMuscle).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _muscleIcon(exercise.targetMuscle),
                color: _muscleColor(exercise.targetMuscle),
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _Tag(
                        label: exercise.targetMuscle,
                        color: _muscleColor(exercise.targetMuscle),
                      ),
                      const SizedBox(width: 6),
                      _Tag(
                        label: exercise.difficulty,
                        color: _difficultyColor(exercise.difficulty),
                      ),
                      const SizedBox(width: 6),
                      _Tag(
                        label: exercise.category,
                        color: AppColors.info,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${exercise.formattedDuration}  |  ${exercise.repetitions} reps  |  ${exercise.sets} sets',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textHint,
            ),
          ],
        ),
      ),
    );
  }

  Color _muscleColor(String muscle) {
    switch (muscle) {
      case 'shoulder':
        return AppColors.primary;
      case 'arm':
        return AppColors.secondary;
      case 'forearm':
        return AppColors.info;
      case 'thigh':
        return AppColors.accent;
      case 'leg':
        return const Color(0xFF9B59B6);
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _muscleIcon(String muscle) {
    switch (muscle) {
      case 'shoulder':
        return Icons.accessibility_new;
      case 'arm':
        return Icons.fitness_center;
      case 'forearm':
        return Icons.pan_tool;
      case 'thigh':
        return Icons.directions_walk;
      case 'leg':
        return Icons.directions_run;
      default:
        return Icons.self_improvement;
    }
  }

  Color _difficultyColor(String difficulty) {
    switch (difficulty) {
      case 'easy':
        return AppColors.success;
      case 'medium':
        return AppColors.warning;
      case 'hard':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;

  const _Tag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
