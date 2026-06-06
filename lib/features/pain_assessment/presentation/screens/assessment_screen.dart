import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/pain_assessment_entity.dart';
import '../providers/assessment_provider.dart';
import '../widgets/body_map_widget.dart';

class AssessmentScreen extends ConsumerWidget {
  const AssessmentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(assessmentProvider);

    ref.listen<AssessmentState>(assessmentProvider, (prev, next) {
      if (next.isCompleted) {
        context.go('/exercises');
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pain Assessment'),
        leading: state.currentStep > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () =>
                    ref.read(assessmentProvider.notifier).previousStep(),
              )
            : null,
      ),
      body: Column(
        children: [
          // Progress bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              children: List.generate(state.totalSteps, (index) {
                return Expanded(
                  child: Container(
                    height: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: index <= state.currentStep
                          ? AppColors.primary
                          : AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 8),
          // Step content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: _buildStep(context, ref, state),
            ),
          ),
          // Continue button
          Padding(
            padding: const EdgeInsets.all(24),
            child: ElevatedButton(
              onPressed: state.canProceed
                  ? () {
                      if (state.currentStep == state.totalSteps - 1) {
                        ref.read(assessmentProvider.notifier).submitAssessment();
                      } else {
                        ref.read(assessmentProvider.notifier).nextStep();
                      }
                    }
                  : null,
              child: state.isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      state.currentStep == state.totalSteps - 1
                          ? 'Get Recommendations'
                          : 'Continue',
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(BuildContext context, WidgetRef ref, AssessmentState state) {
    switch (state.currentStep) {
      case 0:
        return _BodyPartStep(state: state, ref: ref);
      case 1:
        return _PainTypeStep(state: state, ref: ref);
      case 2:
        return _SeverityStep(state: state, ref: ref);
      case 3:
        return _DurationStep(state: state, ref: ref);
      case 4:
        return _TriggerStep(state: state, ref: ref);
      default:
        return const SizedBox();
    }
  }
}

class _BodyPartStep extends StatelessWidget {
  final AssessmentState state;
  final WidgetRef ref;

  const _BodyPartStep({required this.state, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          AppStrings.selectBodyPart,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Tap on the affected areas (select one or more)',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 24),
        Center(
          child: BodyMapWidget(
            selectedParts: state.selectedBodyParts,
            onPartTapped: (part) =>
                ref.read(assessmentProvider.notifier).toggleBodyPart(part),
          ),
        ),
      ],
    );
  }
}

class _PainTypeStep extends StatelessWidget {
  final AssessmentState state;
  final WidgetRef ref;

  const _PainTypeStep({required this.state, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What type of pain?',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Select the option that best describes your pain',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 24),
        ...PainType.values.map((type) {
          final isSelected = state.selectedPainType == type;
          final info = type.iconLabel;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () =>
                  ref.read(assessmentProvider.notifier).setPainType(type),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        isSelected ? AppColors.primary : AppColors.border,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.15)
                            : AppColors.background,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        _painIcon(type),
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            info.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            info.subtitle,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      const Icon(Icons.check_circle, color: AppColors.primary),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  IconData _painIcon(PainType type) {
    switch (type) {
      case PainType.sharp:
        return Icons.flash_on;
      case PainType.dull:
        return Icons.circle;
      case PainType.burning:
        return Icons.local_fire_department;
      case PainType.throbbing:
        return Icons.favorite;
      case PainType.stiffness:
        return Icons.lock;
    }
  }
}

class _SeverityStep extends StatelessWidget {
  final AssessmentState state;
  final WidgetRef ref;

  const _SeverityStep({required this.state, required this.ref});

  @override
  Widget build(BuildContext context) {
    final severity = state.severity;
    Color severityColor;
    String severityLabel;
    if (severity <= 3) {
      severityColor = AppColors.painLow;
      severityLabel = 'Mild';
    } else if (severity <= 6) {
      severityColor = AppColors.painMedium;
      severityLabel = 'Moderate';
    } else {
      severityColor = AppColors.painHigh;
      severityLabel = 'Severe';
    }

    return Column(
      children: [
        const Text(
          'Pain Severity',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Rate your pain on a scale of 1 to 10',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 48),
        // Large number display
        Text(
          '$severity',
          style: TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
            color: severityColor,
          ),
        ),
        Text(
          severityLabel,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: severityColor,
          ),
        ),
        const SizedBox(height: 32),
        // Slider
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: severityColor,
            thumbColor: severityColor,
            inactiveTrackColor: severityColor.withValues(alpha: 0.2),
            overlayColor: severityColor.withValues(alpha: 0.1),
          ),
          child: Slider(
            value: severity.toDouble(),
            min: 1,
            max: 10,
            divisions: 9,
            onChanged: (value) => ref
                .read(assessmentProvider.notifier)
                .setSeverity(value.round()),
          ),
        ),
        const SizedBox(height: 8),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('1 - No pain', style: TextStyle(color: AppColors.textHint, fontSize: 12)),
            Text('10 - Worst pain', style: TextStyle(color: AppColors.textHint, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 32),
        if (severity >= 8)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.warning_amber, color: AppColors.warning),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'High pain levels may require professional medical attention. Our exercises will be gentle.',
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _DurationStep extends StatelessWidget {
  final AssessmentState state;
  final WidgetRef ref;

  const _DurationStep({required this.state, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'How long have you had this pain?',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 24),
        ...durationOptions.map((option) {
          final isSelected = state.duration == option['value'];
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: () => ref
                  .read(assessmentProvider.notifier)
                  .setDuration(option['value']!),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        option['label']!,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                    if (isSelected)
                      const Icon(Icons.check_circle, color: AppColors.primary, size: 22),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _TriggerStep extends StatelessWidget {
  final AssessmentState state;
  final WidgetRef ref;

  const _TriggerStep({required this.state, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What triggers your pain?',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Select all that apply',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: triggerOptions.map((trigger) {
            final isSelected = state.selectedTriggers.contains(trigger);
            return GestureDetector(
              onTap: () =>
                  ref.read(assessmentProvider.notifier).toggleTrigger(trigger),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Text(
                  trigger,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                    color:
                        isSelected ? AppColors.primary : AppColors.textPrimary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
