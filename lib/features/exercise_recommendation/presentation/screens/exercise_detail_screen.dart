import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/exercise_entity.dart';
import '../providers/exercise_provider.dart';

class ExerciseDetailScreen extends ConsumerWidget {
  final String id;

  const ExerciseDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercise = ref.watch(exerciseByIdProvider(id));

    if (exercise == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Exercise not found')),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App bar with exercise visual
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _muscleColor(exercise.targetMuscle),
                      _muscleColor(exercise.targetMuscle).withValues(alpha: 0.7),
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Icon(
                        _muscleIcon(exercise.targetMuscle),
                        size: 64,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        exercise.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick info row
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: [
                      _InfoChip(
                        icon: Icons.timer_outlined,
                        label: exercise.formattedDuration,
                      ),
                      _InfoChip(
                        icon: Icons.repeat,
                        label: '${exercise.repetitions} reps',
                      ),
                      _InfoChip(
                        icon: Icons.layers_outlined,
                        label: '${exercise.sets} sets',
                      ),
                      _InfoChip(
                        icon: Icons.speed,
                        label: exercise.difficulty,
                        color: _difficultyColor(exercise.difficulty),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Description
                  Text(
                    exercise.description,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _RecommendedVideoCard(exercise: exercise),
                  const SizedBox(height: 24),
                  // Instructions
                  const Text(
                    'How to Perform',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...exercise.instructions.asMap().entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${entry.key + 1}',
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              entry.value,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textPrimary,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 24),
                  // Precautions
                  if (exercise.precautions.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.warning.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.warning_amber,
                                  color: AppColors.warning, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Precautions',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ...exercise.precautions.map((p) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('  - ',
                                        style:
                                            TextStyle(color: AppColors.warning)),
                                    Expanded(
                                      child: Text(
                                        p,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      // Start Exercise button
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: () {
            context.go('/exercise-session/${exercise.id}');
          },
          icon: const Icon(Icons.play_arrow),
          label: const Text('Start Exercise with AI'),
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

class _RecommendedVideoCard extends StatelessWidget {
  final ExerciseEntity exercise;

  const _RecommendedVideoCard({required this.exercise});

  Future<void> _openVideo(BuildContext context) async {
    final query = Uri.encodeQueryComponent(
      '${exercise.name} physiotherapy exercise how to',
    );

    final candidates = <Uri>[
      if (exercise.videoUrl != null && exercise.videoUrl!.isNotEmpty)
        Uri.parse(exercise.videoUrl!),
      Uri.parse('https://www.youtube.com/results?search_query=$query'),
      Uri.parse('https://m.youtube.com/results?search_query=$query'),
      Uri.parse('https://www.google.com/search?q=$query&tbm=vid'),
    ];

    const modes = <LaunchMode>[
      LaunchMode.externalApplication,
      LaunchMode.inAppBrowserView,
      LaunchMode.platformDefault,
    ];

    for (final uri in candidates) {
      for (final mode in modes) {
        try {
          final launched = await launchUrl(uri, mode: mode);
          if (launched) return;
        } catch (_) {
          // try next combination
        }
      }
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('No browser found to open the video.'),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () =>
                ScaffoldMessenger.of(context).hideCurrentSnackBar(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _openVideo(context),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.25),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Flexible(
                        child: Text(
                          'Watch Recommended Video',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'NEW',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'See how to perform "${exercise.name}" step by step.',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.open_in_new,
              size: 18,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const _InfoChip({
    required this.icon,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: c),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: c,
            ),
          ),
        ],
      ),
    );
  }
}
