import 'package:equatable/equatable.dart';

enum BodyPart { shoulder, arm, forearm, thigh, leg }

enum PainType { sharp, dull, burning, throbbing, stiffness }

class PainAssessmentEntity extends Equatable {
  final String? id;
  final List<BodyPart> bodyParts;
  final PainType painType;
  final int severity; // 1-10
  final String duration;
  final List<String> triggers;
  final List<String> limitations;
  final DateTime? assessedAt;

  const PainAssessmentEntity({
    this.id,
    required this.bodyParts,
    required this.painType,
    required this.severity,
    required this.duration,
    this.triggers = const [],
    this.limitations = const [],
    this.assessedAt,
  });

  @override
  List<Object?> get props => [id, bodyParts, painType, severity];
}

extension BodyPartX on BodyPart {
  String get label {
    switch (this) {
      case BodyPart.shoulder:
        return 'Shoulder';
      case BodyPart.arm:
        return 'Arm';
      case BodyPart.forearm:
        return 'Forearm';
      case BodyPart.thigh:
        return 'Thigh';
      case BodyPart.leg:
        return 'Leg';
    }
  }

  String get apiValue => name;
}

extension PainTypeX on PainType {
  String get label {
    switch (this) {
      case PainType.sharp:
        return 'Sharp';
      case PainType.dull:
        return 'Dull';
      case PainType.burning:
        return 'Burning';
      case PainType.throbbing:
        return 'Throbbing';
      case PainType.stiffness:
        return 'Stiffness';
    }
  }

  IconLabel get iconLabel {
    switch (this) {
      case PainType.sharp:
        return IconLabel('Sharp', 'Sudden, intense pain');
      case PainType.dull:
        return IconLabel('Dull', 'Constant, low-grade ache');
      case PainType.burning:
        return IconLabel('Burning', 'Hot, tingling sensation');
      case PainType.throbbing:
        return IconLabel('Throbbing', 'Pulsing, rhythmic pain');
      case PainType.stiffness:
        return IconLabel('Stiffness', 'Tight, hard to move');
    }
  }
}

class IconLabel {
  final String title;
  final String subtitle;

  IconLabel(this.title, this.subtitle);
}
