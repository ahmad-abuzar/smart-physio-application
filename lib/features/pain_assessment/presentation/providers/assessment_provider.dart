import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/pain_assessment_entity.dart';

class AssessmentState {
  final int currentStep; // 0-4
  final Set<BodyPart> selectedBodyParts;
  final PainType? selectedPainType;
  final int severity;
  final String? duration;
  final List<String> selectedTriggers;
  final List<String> selectedLimitations;
  final bool isSubmitting;
  final bool isCompleted;

  const AssessmentState({
    this.currentStep = 0,
    this.selectedBodyParts = const {},
    this.selectedPainType,
    this.severity = 5,
    this.duration,
    this.selectedTriggers = const [],
    this.selectedLimitations = const [],
    this.isSubmitting = false,
    this.isCompleted = false,
  });

  AssessmentState copyWith({
    int? currentStep,
    Set<BodyPart>? selectedBodyParts,
    PainType? selectedPainType,
    int? severity,
    String? duration,
    List<String>? selectedTriggers,
    List<String>? selectedLimitations,
    bool? isSubmitting,
    bool? isCompleted,
  }) {
    return AssessmentState(
      currentStep: currentStep ?? this.currentStep,
      selectedBodyParts: selectedBodyParts ?? this.selectedBodyParts,
      selectedPainType: selectedPainType ?? this.selectedPainType,
      severity: severity ?? this.severity,
      duration: duration ?? this.duration,
      selectedTriggers: selectedTriggers ?? this.selectedTriggers,
      selectedLimitations: selectedLimitations ?? this.selectedLimitations,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  bool get canProceed {
    switch (currentStep) {
      case 0:
        return selectedBodyParts.isNotEmpty;
      case 1:
        return selectedPainType != null;
      case 2:
        return true; // severity always has a default
      case 3:
        return duration != null;
      case 4:
        return selectedTriggers.isNotEmpty;
      default:
        return false;
    }
  }

  int get totalSteps => 5;
}

class AssessmentNotifier extends StateNotifier<AssessmentState> {
  AssessmentNotifier() : super(const AssessmentState());

  void toggleBodyPart(BodyPart part) {
    final parts = Set<BodyPart>.from(state.selectedBodyParts);
    if (parts.contains(part)) {
      parts.remove(part);
    } else {
      parts.add(part);
    }
    state = state.copyWith(selectedBodyParts: parts);
  }

  void setPainType(PainType type) {
    state = state.copyWith(selectedPainType: type);
  }

  void setSeverity(int severity) {
    state = state.copyWith(severity: severity);
  }

  void setDuration(String duration) {
    state = state.copyWith(duration: duration);
  }

  void toggleTrigger(String trigger) {
    final triggers = List<String>.from(state.selectedTriggers);
    if (triggers.contains(trigger)) {
      triggers.remove(trigger);
    } else {
      triggers.add(trigger);
    }
    state = state.copyWith(selectedTriggers: triggers);
  }

  void toggleLimitation(String limitation) {
    final limitations = List<String>.from(state.selectedLimitations);
    if (limitations.contains(limitation)) {
      limitations.remove(limitation);
    } else {
      limitations.add(limitation);
    }
    state = state.copyWith(selectedLimitations: limitations);
  }

  void nextStep() {
    if (state.currentStep < state.totalSteps - 1) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  Future<void> submitAssessment() async {
    state = state.copyWith(isSubmitting: true);
    // TODO: Send to backend API
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call
    state = state.copyWith(isSubmitting: false, isCompleted: true);
  }

  void reset() {
    state = const AssessmentState();
  }
}

final assessmentProvider =
    StateNotifierProvider<AssessmentNotifier, AssessmentState>((ref) {
  return AssessmentNotifier();
});

// Duration options
const List<Map<String, String>> durationOptions = [
  {'value': 'few_hours', 'label': 'A few hours'},
  {'value': '1_2_days', 'label': '1-2 days'},
  {'value': '3_7_days', 'label': '3-7 days'},
  {'value': '1_2_weeks', 'label': '1-2 weeks'},
  {'value': '2_4_weeks', 'label': '2-4 weeks'},
  {'value': 'more_month', 'label': 'More than a month'},
];

// Trigger options
const List<String> triggerOptions = [
  'Prolonged sitting',
  'Heavy lifting',
  'Sudden movement',
  'Exercise/workout',
  'Sleeping position',
  'Repetitive motion',
  'Stress/tension',
  'No apparent cause',
];

// Limitation options based on body part
Map<BodyPart, List<String>> limitationOptions = {
  BodyPart.shoulder: [
    'Cannot raise arm above head',
    'Difficulty reaching behind back',
    'Pain when rotating arm',
    'Limited arm swing',
  ],
  BodyPart.arm: [
    'Cannot fully extend arm',
    'Difficulty gripping objects',
    'Pain when bending elbow',
    'Weakness in arm',
  ],
  BodyPart.forearm: [
    'Cannot rotate wrist fully',
    'Difficulty typing/writing',
    'Pain when gripping',
    'Numbness in fingers',
  ],
  BodyPart.thigh: [
    'Cannot fully bend knee',
    'Difficulty climbing stairs',
    'Pain when sitting down',
    'Stiffness after rest',
  ],
  BodyPart.leg: [
    'Cannot stand on toes',
    'Difficulty walking',
    'Ankle stiffness',
    'Pain when stretching',
  ],
};
