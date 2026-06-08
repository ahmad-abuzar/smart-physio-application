import 'dart:async';
import 'dart:io' show Platform;
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../exercise_recommendation/data/datasources/exercise_local_data.dart';
import '../../../exercise_recommendation/domain/entities/exercise_entity.dart';

enum _MotionType { rep, hold }

enum _JointGroup {
  shoulderArm,
  elbow,
  hipKnee,
  kneeAnkle,
  hipFlexion,
  shoulderShrug,
}

class _ExerciseConfig {
  final _MotionType type;
  // Logical joint group; resolved to left/right at runtime based on visibility.
  final _JointGroup group;
  // Rep mode: angle must rise above [highAngle] then fall below [lowAngle] = 1 rep.
  final double lowAngle;
  final double highAngle;
  // Hold mode: maintain valid form for [holdSeconds] = 1 rep.
  final int holdSeconds;
  final String tip;

  const _ExerciseConfig({
    required this.type,
    required this.group,
    this.lowAngle = 60,
    this.highAngle = 150,
    this.holdSeconds = 10,
    this.tip = 'Hold the position steady.',
  });
}

/// Returns the 3-joint landmark trio (a, b, c with b as vertex) for the
/// configured joint group on the requested side.
List<PoseLandmarkType> _jointTrio(_JointGroup g, bool useLeft) {
  switch (g) {
    case _JointGroup.shoulderArm:
      return useLeft
          ? const [
              PoseLandmarkType.leftHip,
              PoseLandmarkType.leftShoulder,
              PoseLandmarkType.leftWrist,
            ]
          : const [
              PoseLandmarkType.rightHip,
              PoseLandmarkType.rightShoulder,
              PoseLandmarkType.rightWrist,
            ];
    case _JointGroup.elbow:
      return useLeft
          ? const [
              PoseLandmarkType.leftShoulder,
              PoseLandmarkType.leftElbow,
              PoseLandmarkType.leftWrist,
            ]
          : const [
              PoseLandmarkType.rightShoulder,
              PoseLandmarkType.rightElbow,
              PoseLandmarkType.rightWrist,
            ];
    case _JointGroup.hipKnee:
      return useLeft
          ? const [
              PoseLandmarkType.leftHip,
              PoseLandmarkType.leftKnee,
              PoseLandmarkType.leftAnkle,
            ]
          : const [
              PoseLandmarkType.rightHip,
              PoseLandmarkType.rightKnee,
              PoseLandmarkType.rightAnkle,
            ];
    case _JointGroup.kneeAnkle:
      return useLeft
          ? const [
              PoseLandmarkType.leftKnee,
              PoseLandmarkType.leftAnkle,
              PoseLandmarkType.leftFootIndex,
            ]
          : const [
              PoseLandmarkType.rightKnee,
              PoseLandmarkType.rightAnkle,
              PoseLandmarkType.rightFootIndex,
            ];
    // Hip flexion: shoulder-hip-knee — angle drops when leg lifts (e.g. straight leg raise).
    case _JointGroup.hipFlexion:
      return useLeft
          ? const [
              PoseLandmarkType.leftShoulder,
              PoseLandmarkType.leftHip,
              PoseLandmarkType.leftKnee,
            ]
          : const [
              PoseLandmarkType.rightShoulder,
              PoseLandmarkType.rightHip,
              PoseLandmarkType.rightKnee,
            ];
    // Shoulder shrug: hip-shoulder-ear — angle closes as shoulder rises toward ear.
    case _JointGroup.shoulderShrug:
      return useLeft
          ? const [
              PoseLandmarkType.leftHip,
              PoseLandmarkType.leftShoulder,
              PoseLandmarkType.leftEar,
            ]
          : const [
              PoseLandmarkType.rightHip,
              PoseLandmarkType.rightShoulder,
              PoseLandmarkType.rightEar,
            ];
  }
}

// Defaults by target muscle. Tuned so the angle thresholds actually match
// the motion the user performs.
const _kDefaultsByMuscle = <String, _ExerciseConfig>{
  // hip-shoulder-wrist: arm hanging ~170, arm overhead ~20.
  'shoulder': _ExerciseConfig(
    type: _MotionType.rep,
    group: _JointGroup.shoulderArm,
    lowAngle: 40,
    highAngle: 150,
    tip: 'Raise your arm up, then lower it back down.',
  ),
  // shoulder-elbow-wrist: straight ~170, fully bent ~40.
  'arm': _ExerciseConfig(
    type: _MotionType.rep,
    group: _JointGroup.elbow,
    lowAngle: 80,
    highAngle: 160,
    tip: 'Bend and straighten your elbow fully.',
  ),
  'forearm': _ExerciseConfig(
    type: _MotionType.hold,
    group: _JointGroup.elbow,
    lowAngle: 60,
    highAngle: 170,
    holdSeconds: 8,
    tip: 'Keep your wrist stretched.',
  ),
  'thigh': _ExerciseConfig(
    type: _MotionType.rep,
    group: _JointGroup.hipKnee,
    lowAngle: 90,
    highAngle: 165,
    tip: 'Bend the knee, then straighten the leg.',
  ),
  'leg': _ExerciseConfig(
    type: _MotionType.rep,
    group: _JointGroup.hipKnee,
    lowAngle: 90,
    highAngle: 170,
    tip: 'Move your leg through the full range.',
  ),
};

// Per-exercise overrides. Thresholds picked to match the actual motion.
const _kExerciseOverrides = <String, _ExerciseConfig>{
  // sh_01 Pendulum Stretch — angle doesn't change much (arm hangs constant).
  // Treat as a time-based hold (60s) so the AI still acknowledges effort.
  'sh_01': _ExerciseConfig(
    type: _MotionType.hold,
    group: _JointGroup.shoulderArm,
    lowAngle: 130,
    highAngle: 180,
    holdSeconds: 10,
    tip: 'Lean forward and let your arm swing in circles.',
  ),
  // sh_02 Wall Climb — full overhead reach (arm goes from ~170 down to ~30).
  'sh_02': _ExerciseConfig(
    type: _MotionType.rep,
    group: _JointGroup.shoulderArm,
    lowAngle: 50,
    highAngle: 150,
    tip: 'Walk your fingers up the wall as high as you can.',
  ),
  // sh_03 Cross-body stretch: hold.
  'sh_03': _ExerciseConfig(
    type: _MotionType.hold,
    group: _JointGroup.shoulderArm,
    lowAngle: 30,
    highAngle: 110,
    holdSeconds: 15,
    tip: 'Hold your arm across your chest.',
  ),
  // sh_04 Shoulder Shrugs — hip-shoulder-ear closes from ~165 to ~135.
  'sh_04': _ExerciseConfig(
    type: _MotionType.rep,
    group: _JointGroup.shoulderShrug,
    lowAngle: 140,
    highAngle: 162,
    tip: 'Lift your shoulders up toward your ears.',
  ),
  // sh_05 External Rotation — primarily depth-axis rotation; treat as a hold.
  'sh_05': _ExerciseConfig(
    type: _MotionType.hold,
    group: _JointGroup.elbow,
    lowAngle: 75,
    highAngle: 105,
    holdSeconds: 10,
    tip: 'Keep elbow at 90° tucked to your side.',
  ),
  // sh_06 Doorway stretch: hold.
  'sh_06': _ExerciseConfig(
    type: _MotionType.hold,
    group: _JointGroup.shoulderArm,
    lowAngle: 70,
    highAngle: 130,
    holdSeconds: 15,
    tip: 'Hold the stretch in the doorway.',
  ),
  // ar_01 Bicep Stretch: arm straight, hold.
  'ar_01': _ExerciseConfig(
    type: _MotionType.hold,
    group: _JointGroup.elbow,
    lowAngle: 150,
    highAngle: 180,
    holdSeconds: 15,
    tip: 'Keep your arm straight and feel the stretch.',
  ),
  // ar_02 Tricep Overhead: elbow bent, hand behind head — hold.
  'ar_02': _ExerciseConfig(
    type: _MotionType.hold,
    group: _JointGroup.elbow,
    lowAngle: 20,
    highAngle: 75,
    holdSeconds: 15,
    tip: 'Hold elbow bent behind your head.',
  ),
  // ar_03 Arm Circles — circular motion; use shoulder-arm full range so any
  // big arm movement counts. Sensitive but acknowledges effort.
  'ar_03': _ExerciseConfig(
    type: _MotionType.rep,
    group: _JointGroup.shoulderArm,
    lowAngle: 60,
    highAngle: 130,
    tip: 'Make full arm circles.',
  ),
  // ar_04 Wall Push-Up — elbow bends ~170 -> ~90.
  'ar_04': _ExerciseConfig(
    type: _MotionType.rep,
    group: _JointGroup.elbow,
    lowAngle: 100,
    highAngle: 160,
    tip: 'Bend your elbows toward the wall, then push back.',
  ),
  // ar_05 Isometric Bicep Hold — elbow at 90°.
  'ar_05': _ExerciseConfig(
    type: _MotionType.hold,
    group: _JointGroup.elbow,
    lowAngle: 70,
    highAngle: 110,
    holdSeconds: 8,
    tip: 'Hold elbow at 90 degrees.',
  ),
  // th_01 Standing Quad — heel to glute (knee tightly flexed): hold.
  'th_01': _ExerciseConfig(
    type: _MotionType.hold,
    group: _JointGroup.hipKnee,
    lowAngle: 20,
    highAngle: 70,
    holdSeconds: 15,
    tip: 'Hold heel close to your glute.',
  ),
  // th_02 Hamstring stretch — leg extended (~170), hold.
  'th_02': _ExerciseConfig(
    type: _MotionType.hold,
    group: _JointGroup.hipKnee,
    lowAngle: 140,
    highAngle: 180,
    holdSeconds: 15,
    tip: 'Reach toward your toes and hold.',
  ),
  // th_03 Leg Swings — leg swings forward and back; hip flexion oscillates.
  'th_03': _ExerciseConfig(
    type: _MotionType.rep,
    group: _JointGroup.hipFlexion,
    lowAngle: 110,
    highAngle: 165,
    tip: 'Swing your leg forward and back.',
  ),
  // th_04 Wall Sit — knee at ~90.
  'th_04': _ExerciseConfig(
    type: _MotionType.hold,
    group: _JointGroup.hipKnee,
    lowAngle: 75,
    highAngle: 115,
    holdSeconds: 15,
    tip: 'Hold knees bent at 90 degrees.',
  ),
  // th_05 Hip Flexor lunge — front knee at ~90.
  'th_05': _ExerciseConfig(
    type: _MotionType.hold,
    group: _JointGroup.hipKnee,
    lowAngle: 75,
    highAngle: 115,
    holdSeconds: 15,
    tip: 'Hold the lunge stretch.',
  ),
  // th_06 Lying Quad — side-lying with knee bent.
  'th_06': _ExerciseConfig(
    type: _MotionType.hold,
    group: _JointGroup.hipKnee,
    lowAngle: 20,
    highAngle: 80,
    holdSeconds: 15,
    tip: 'Hold heel close to glute.',
  ),
  // lg_01 Calf Raises — ankle dorsiflexion barely visible. Treat as a hold
  // (any standing position counts) for 3 sets x 15 reps -> ~45s engagement.
  'lg_01': _ExerciseConfig(
    type: _MotionType.hold,
    group: _JointGroup.hipKnee,
    lowAngle: 150,
    highAngle: 180,
    holdSeconds: 3,
    tip: 'Rise onto your toes, then lower down.',
  ),
  // lg_02 Ankle Circles — too small for body pose; hold-based.
  'lg_02': _ExerciseConfig(
    type: _MotionType.hold,
    group: _JointGroup.hipKnee,
    lowAngle: 150,
    highAngle: 180,
    holdSeconds: 3,
    tip: 'Rotate your ankle in circles.',
  ),
  // lg_03 Standing Calf — back leg extended: hold.
  'lg_03': _ExerciseConfig(
    type: _MotionType.hold,
    group: _JointGroup.hipKnee,
    lowAngle: 140,
    highAngle: 180,
    holdSeconds: 15,
    tip: 'Keep back heel down and hold.',
  ),
  // lg_04 Toe Raises — hold.
  'lg_04': _ExerciseConfig(
    type: _MotionType.hold,
    group: _JointGroup.hipKnee,
    lowAngle: 150,
    highAngle: 180,
    holdSeconds: 3,
    tip: 'Lift your toes off the floor.',
  ),
  // lg_05 Knee-to-Chest — knee tightly flexed: hold.
  'lg_05': _ExerciseConfig(
    type: _MotionType.hold,
    group: _JointGroup.hipKnee,
    lowAngle: 20,
    highAngle: 80,
    holdSeconds: 15,
    tip: 'Pull knee gently to your chest.',
  ),
  // lg_06 Straight Leg Raise — hip flexes while knee stays straight.
  // Use shoulder-hip-knee (hip flexion angle).
  'lg_06': _ExerciseConfig(
    type: _MotionType.rep,
    group: _JointGroup.hipFlexion,
    lowAngle: 110,
    highAngle: 160,
    tip: 'Lift your straight leg, then lower it slowly.',
  ),
  // lg_07 Step-Ups — knee bends ~90 then straightens ~170.
  'lg_07': _ExerciseConfig(
    type: _MotionType.rep,
    group: _JointGroup.hipKnee,
    lowAngle: 100,
    highAngle: 160,
    tip: 'Step up, then back down.',
  ),
};

const Map<DeviceOrientation, int> _orientationToDegrees = {
  DeviceOrientation.portraitUp: 0,
  DeviceOrientation.landscapeLeft: 90,
  DeviceOrientation.portraitDown: 180,
  DeviceOrientation.landscapeRight: 270,
};

class ExerciseSessionScreen extends ConsumerStatefulWidget {
  final String exerciseId;

  const ExerciseSessionScreen({super.key, required this.exerciseId});

  @override
  ConsumerState<ExerciseSessionScreen> createState() =>
      _ExerciseSessionScreenState();
}

class _ExerciseSessionScreenState extends ConsumerState<ExerciseSessionScreen> {
  CameraController? _cameraController;
  PoseDetector? _poseDetector;
  FlutterTts? _tts;
  bool _isDetecting = false;
  bool _isPaused = false;
  bool _isInitialized = false;

  // Session state
  int _repCount = 0;
  int _currentSet = 1;
  double _formScore = 100.0;
  String _feedbackMessage = 'Position yourself in the camera frame';
  Color _feedbackColor = AppColors.info;
  List<Pose> _currentPoses = [];
  int _totalCorrectFrames = 0;
  int _totalFrames = 0;

  // For rep counting (state machine)
  // 'low' = at start position; 'high' = past peak threshold, waiting to return.
  String _repPhase = 'low';
  DateTime? _lastRepAt;
  // Per-message TTS throttle so different messages aren't blocked by one global timer.
  final Map<String, DateTime> _lastVoiceFeedbackByMessage = {};

  // For hold-based exercises
  DateTime? _holdStartedAt;
  double _holdProgress = 0.0;

  // Diagnostics
  int _framesProcessed = 0;
  int _posesDetected = 0;

  ExerciseEntity? _exercise;
  _ExerciseConfig? _config;
  Timer? _sessionTimer;
  int _elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    _exercise = ExerciseLocalData.getExerciseById(widget.exerciseId);
    _config = _resolveConfig(_exercise);
    _initializeCamera();
    _initializeTts();
  }

  _ExerciseConfig? _resolveConfig(ExerciseEntity? exercise) {
    if (exercise == null) return null;
    return _kExerciseOverrides[exercise.id] ??
        _kDefaultsByMuscle[exercise.targetMuscle];
  }

  Future<void> _initializeTts() async {
    _tts = FlutterTts();
    await _tts?.setLanguage('en-US');
    await _tts?.setSpeechRate(0.5);
    await _tts?.setVolume(1.0);
  }

  Future<void> _initializeCamera() async {
    try {
      // 1) Camera permission must be granted before opening the camera.
      final status = await Permission.camera.request();
      if (!status.isGranted) {
        if (mounted) {
          setState(() {
            _feedbackMessage =
                'Camera permission denied. Enable it in settings.';
            _feedbackColor = AppColors.error;
          });
        }
        return;
      }

      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (mounted) {
          setState(() {
            _feedbackMessage = 'No cameras found on this device.';
            _feedbackColor = AppColors.error;
          });
        }
        return;
      }

      // Prefer front camera
      final camera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888,
      );

      await _cameraController!.initialize();

      _poseDetector = PoseDetector(
        options: PoseDetectorOptions(mode: PoseDetectionMode.stream),
      );

      if (mounted) {
        setState(() => _isInitialized = true);
        _startSession();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _feedbackMessage = 'Camera error: $e';
          _feedbackColor = AppColors.error;
        });
      }
    }
  }

  void _startSession() {
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_isPaused && mounted) {
        setState(() => _elapsedSeconds++);
      }
    });

    _startPoseDetection();
    _speak(
      'Starting ${_exercise?.name ?? "exercise"}. Position yourself in the frame.',
    );
  }

  void _startPoseDetection() {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    _cameraController!.startImageStream((image) {
      if (_isDetecting || _isPaused) return;
      _isDetecting = true;
      _processImage(image).then((_) {
        _isDetecting = false;
      });
    });
  }

  Future<void> _processImage(CameraImage image) async {
    if (_poseDetector == null) return;

    try {
      final inputImage = _convertCameraImage(image);
      if (inputImage == null) return;

      _framesProcessed++;
      final poses = await _poseDetector!.processImage(inputImage);

      if (!mounted) return;

      if (poses.isEmpty) {
        // Reset hold timer if user leaves frame entirely.
        _holdStartedAt = null;
        _holdProgress = 0.0;
        setState(() {
          _currentPoses = [];
          _feedbackMessage =
              'Step back so your whole ${_bodyHint(_exercise?.targetMuscle ?? "")} is in the frame';
          _feedbackColor = AppColors.poseWarning;
        });
        _giveVoiceFeedback(_feedbackMessage);
      } else {
        _posesDetected++;
        setState(() {
          _currentPoses = poses;
        });
        _analyzePose(poses.first);
      }
    } catch (_) {
      // Silently handle detection errors in stream
    }
  }

  InputImage? _convertCameraImage(CameraImage image) {
    if (_cameraController == null) return null;
    final camera = _cameraController!.description;
    final sensorOrientation = camera.sensorOrientation;

    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else {
      final deviceRot =
          _orientationToDegrees[_cameraController!.value.deviceOrientation];
      if (deviceRot == null) return null;
      final compensated = camera.lensDirection == CameraLensDirection.front
          ? (sensorOrientation + deviceRot) % 360
          : (sensorOrientation - deviceRot + 360) % 360;
      rotation = InputImageRotationValue.fromRawValue(compensated);
    }
    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(image.format.raw);

    if (Platform.isIOS) {
      if (format != InputImageFormat.bgra8888) return null;
      return InputImage.fromBytes(
        bytes: image.planes.first.bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: rotation,
          format: format!,
          bytesPerRow: image.planes.first.bytesPerRow,
        ),
      );
    }

    // Android: ML Kit only accepts NV21. If the camera HAL gave us NV21
    // directly, send it. Otherwise (e.g. YUV_420_888) convert in Dart so
    // detection still works.
    if (format == InputImageFormat.nv21 && image.planes.length == 1) {
      return InputImage.fromBytes(
        bytes: image.planes.first.bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: rotation,
          format: InputImageFormat.nv21,
          bytesPerRow: image.planes.first.bytesPerRow,
        ),
      );
    }

    final nv21 = _yuv420ToNv21(image);
    if (nv21 == null) return null;
    return InputImage.fromBytes(
      bytes: nv21,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: InputImageFormat.nv21,
        bytesPerRow: image.width,
      ),
    );
  }

  /// Converts a CameraImage in YUV_420_888 (or split-plane NV21) into a
  /// tightly-packed NV21 buffer that ML Kit accepts. Handles row stride
  /// padding and U/V pixel strides that vary by device.
  Uint8List? _yuv420ToNv21(CameraImage image) {
    if (image.planes.length < 3) return null;
    final width = image.width;
    final height = image.height;
    final ySize = width * height;
    final uvSize = (width ~/ 2) * (height ~/ 2) * 2;
    final out = Uint8List(ySize + uvSize);

    // Y plane (strip any row padding).
    final yPlane = image.planes[0];
    final yBytes = yPlane.bytes;
    final yRowStride = yPlane.bytesPerRow;
    int dst = 0;
    if (yRowStride == width) {
      out.setRange(0, ySize, yBytes);
      dst = ySize;
    } else {
      for (int row = 0; row < height; row++) {
        final start = row * yRowStride;
        out.setRange(dst, dst + width, yBytes, start);
        dst += width;
      }
    }

    // UV planes — NV21 is V then U interleaved.
    final uPlane = image.planes[1];
    final vPlane = image.planes[2];
    final uvRowStride = uPlane.bytesPerRow;
    final uvPixelStride = uPlane.bytesPerPixel ?? 1;
    final uBytes = uPlane.bytes;
    final vBytes = vPlane.bytes;

    final halfHeight = height ~/ 2;
    final halfWidth = width ~/ 2;
    for (int row = 0; row < halfHeight; row++) {
      for (int col = 0; col < halfWidth; col++) {
        final uvIdx = row * uvRowStride + col * uvPixelStride;
        if (uvIdx >= uBytes.length || uvIdx >= vBytes.length) continue;
        out[dst++] = vBytes[uvIdx];
        out[dst++] = uBytes[uvIdx];
      }
    }
    return out;
  }

  void _analyzePose(Pose pose) {
    _totalFrames++;
    final config = _config;
    final landmarks = pose.landmarks;
    if (config == null || landmarks.isEmpty) return;

    const minLikelihood = 0.3;

    // Score both sides; pick the side whose three relevant joints are more
    // visible. This lets the user do unilateral exercises with either limb.
    final leftTrio = _jointTrio(config.group, true);
    final rightTrio = _jointTrio(config.group, false);

    double scoreSide(List<PoseLandmarkType> trio) {
      double s = 0;
      for (final t in trio) {
        final lm = landmarks[t];
        if (lm == null) return -1;
        s += lm.likelihood;
      }
      return s;
    }

    final leftScore = scoreSide(leftTrio);
    final rightScore = scoreSide(rightTrio);
    final useLeft = leftScore >= rightScore;
    final trio = useLeft ? leftTrio : rightTrio;

    final a = landmarks[trio[0]];
    final b = landmarks[trio[1]];
    final c = landmarks[trio[2]];

    final visible =
        a != null &&
        b != null &&
        c != null &&
        a.likelihood >= minLikelihood &&
        b.likelihood >= minLikelihood &&
        c.likelihood >= minLikelihood;

    if (!visible) {
      // Reset hold timer if user leaves frame
      _holdStartedAt = null;
      _holdProgress = 0.0;
      if (mounted) {
        setState(() {
          _feedbackMessage =
              'Position your ${_bodyHint(_exercise!.targetMuscle)} fully in the frame';
          _feedbackColor = AppColors.poseWarning;
        });
        _giveVoiceFeedback(_feedbackMessage);
      }
      return;
    }

    final angle = _calculateAngle(a, b, c);

    if (config.type == _MotionType.rep) {
      _handleRepMotion(angle, config);
    } else {
      _handleHoldMotion(angle, config);
    }
  }

  void _handleRepMotion(double angle, _ExerciseConfig config) {
    final inRange =
        angle >= (config.lowAngle - 15) && angle <= (config.highAngle + 15);

    if (inRange) _totalCorrectFrames++;
    final score = (_totalCorrectFrames / max(1, _totalFrames) * 100).clamp(
      0.0,
      100.0,
    );

    final prevPhase = _repPhase;
    if (_repPhase == 'low' && angle >= config.highAngle) {
      _repPhase = 'high';
    } else if (_repPhase == 'high' && angle <= config.lowAngle) {
      _repPhase = 'low';
      _registerRep();
    }

    if (mounted) {
      setState(() {
        _formScore = score;
        if (prevPhase != _repPhase) {
          _feedbackMessage = _repPhase == 'high'
              ? 'Now return to start position'
              : 'Now move into the peak position';
          _feedbackColor = AppColors.info;
        } else if (inRange) {
          _feedbackMessage = 'Good form — keep going!';
          _feedbackColor = AppColors.poseCorrect;
        } else {
          _feedbackMessage = config.tip;
          _feedbackColor = AppColors.poseIncorrect;
          _giveVoiceFeedback(config.tip);
        }
      });
    }
  }

  void _handleHoldMotion(double angle, _ExerciseConfig config) {
    final inHoldRange = angle >= config.lowAngle && angle <= config.highAngle;

    if (inHoldRange) {
      _totalCorrectFrames++;
      _holdStartedAt ??= DateTime.now();
      final elapsed = DateTime.now().difference(_holdStartedAt!).inMilliseconds;
      _holdProgress = (elapsed / (config.holdSeconds * 1000)).clamp(0.0, 1.0);
      if (_holdProgress >= 1.0) {
        _holdStartedAt = null;
        _holdProgress = 0.0;
        _registerRep();
      }
    } else {
      _holdStartedAt = null;
      _holdProgress = 0.0;
    }

    final score = (_totalCorrectFrames / max(1, _totalFrames) * 100).clamp(
      0.0,
      100.0,
    );

    if (mounted) {
      setState(() {
        _formScore = score;
        if (inHoldRange) {
          final secsLeft =
              (config.holdSeconds - (config.holdSeconds * _holdProgress))
                  .ceil();
          _feedbackMessage = 'Hold — $secsLeft s left';
          _feedbackColor = AppColors.poseCorrect;
        } else {
          _feedbackMessage = config.tip;
          _feedbackColor = AppColors.poseIncorrect;
          _giveVoiceFeedback(config.tip);
        }
      });
    }
  }

  void _registerRep() {
    final now = DateTime.now();
    if (_lastRepAt != null &&
        now.difference(_lastRepAt!).inMilliseconds < 600) {
      // debounce — ignore double-trips
      return;
    }
    _lastRepAt = now;

    HapticFeedback.mediumImpact();
    setState(() {
      _repCount++;
      _speak('$_repCount');
      if (_repCount >= (_exercise?.repetitions ?? 10)) {
        if (_currentSet < (_exercise?.sets ?? 3)) {
          _currentSet++;
          _repCount = 0;
          _repPhase = 'low';
          _speak('Set $_currentSet starting. Rest a moment.');
        } else {
          _completeSession();
        }
      }
    });
  }

  String _bodyHint(String muscle) {
    switch (muscle) {
      case 'shoulder':
      case 'arm':
      case 'forearm':
        return 'upper body';
      case 'thigh':
      case 'leg':
        return 'legs';
      default:
        return 'body';
    }
  }

  double _calculateAngle(PoseLandmark a, PoseLandmark b, PoseLandmark c) {
    final radians = atan2(c.y - b.y, c.x - b.x) - atan2(a.y - b.y, a.x - b.x);
    var angle = radians * 180 / pi;
    if (angle < 0) angle += 360;
    if (angle > 180) angle = 360 - angle;
    return angle;
  }

  void _giveVoiceFeedback(String message) {
    final now = DateTime.now();
    final last = _lastVoiceFeedbackByMessage[message];
    if (last == null || now.difference(last).inSeconds >= 4) {
      _speak(message);
      _lastVoiceFeedbackByMessage[message] = now;
    }
  }

  Future<void> _speak(String text) async {
    await _tts?.speak(text);
  }

  void _togglePause() {
    setState(() => _isPaused = !_isPaused);
    if (_isPaused) {
      _speak('Exercise paused');
    } else {
      _speak('Resuming exercise');
    }
  }

  void _completeSession() {
    _cameraController?.stopImageStream();
    _sessionTimer?.cancel();
    _speak('Excellent! Exercise session completed!');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.success, size: 28),
            SizedBox(width: 8),
            Text('Session Complete!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ResultRow(label: 'Exercise', value: _exercise?.name ?? ''),
            _ResultRow(
              label: 'Total Reps',
              value:
                  '${(_exercise?.repetitions ?? 0) * (_exercise?.sets ?? 0)}',
            ),
            _ResultRow(label: 'Sets Completed', value: '$_currentSet'),
            _ResultRow(
              label: 'Form Score',
              value: '${_formScore.toStringAsFixed(0)}%',
            ),
            _ResultRow(label: 'Duration', value: _formatTime(_elapsedSeconds)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.go('/exercises');
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _poseDetector?.close();
    _tts?.stop();
    _sessionTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_exercise == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Exercise not found')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Camera preview
            if (_isInitialized && _cameraController != null)
              SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _cameraController!.value.previewSize?.height ?? 1,
                    height: _cameraController!.value.previewSize?.width ?? 1,
                    child: CameraPreview(_cameraController!),
                  ),
                ),
              )
            else
              const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),

            // Pose skeleton overlay
            if (_currentPoses.isNotEmpty && _isInitialized)
              CustomPaint(
                size: MediaQuery.of(context).size,
                painter: _PoseOverlayPainter(
                  poses: _currentPoses,
                  isCorrect: _feedbackColor == AppColors.poseCorrect,
                  imageSize: Size(
                    _cameraController!.value.previewSize?.height ?? 1,
                    _cameraController!.value.previewSize?.width ?? 1,
                  ),
                  screenSize: MediaQuery.of(context).size,
                  mirror:
                      _cameraController!.description.lensDirection ==
                      CameraLensDirection.front,
                ),
              ),

            // Top bar - Exercise info
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go('/exercise-detail/${_exercise!.id}');
                        }
                      },
                    ),
                    Expanded(
                      child: Text(
                        _exercise!.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Text(
                      _formatTime(_elapsedSeconds),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Stats overlay
            Positioned(
              top: 80,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _config?.type == _MotionType.hold
                          ? 'Hold: $_repCount/${_exercise!.repetitions}'
                          : 'Rep: $_repCount/${_exercise!.repetitions}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Set: $_currentSet/${_exercise!.sets}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                    if (_config?.type == _MotionType.hold) ...[
                      const SizedBox(height: 6),
                      SizedBox(
                        width: 96,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: _holdProgress,
                            minHeight: 6,
                            backgroundColor: Colors.white24,
                            valueColor: const AlwaysStoppedAnimation(
                              AppColors.poseCorrect,
                            ),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Text(
                      'AI: $_posesDetected/$_framesProcessed',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Score: ${_formScore.toStringAsFixed(0)}%',
                      style: TextStyle(
                        color: _formScore >= 70
                            ? AppColors.poseCorrect
                            : AppColors.poseWarning,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom feedback bar
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    // Feedback message
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: _feedbackColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _feedbackColor.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Text(
                        _feedbackMessage,
                        style: TextStyle(
                          color: _feedbackColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Control buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _ControlButton(
                          icon: _isPaused ? Icons.play_arrow : Icons.pause,
                          label: _isPaused ? 'Resume' : 'Pause',
                          onTap: _togglePause,
                        ),
                        _ControlButton(
                          icon: Icons.skip_next,
                          label: 'Skip Set',
                          onTap: () {
                            setState(() {
                              if (_currentSet < (_exercise?.sets ?? 3)) {
                                _currentSet++;
                                _repCount = 0;
                                _repPhase = 'low';
                                _holdStartedAt = null;
                                _holdProgress = 0.0;
                              } else {
                                _completeSession();
                              }
                            });
                          },
                        ),
                        _ControlButton(
                          icon: Icons.stop,
                          label: 'End',
                          onTap: _completeSession,
                          color: AppColors.error,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PoseOverlayPainter extends CustomPainter {
  final List<Pose> poses;
  final bool isCorrect;
  final Size imageSize;
  final Size screenSize;
  final bool mirror;

  _PoseOverlayPainter({
    required this.poses,
    required this.isCorrect,
    required this.imageSize,
    required this.screenSize,
    this.mirror = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = isCorrect ? AppColors.poseCorrect : AppColors.poseIncorrect;

    final dotPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = isCorrect ? AppColors.poseCorrect : AppColors.poseIncorrect;

    for (final pose in poses) {
      // Draw connections
      _drawLine(
        canvas,
        pose,
        PoseLandmarkType.leftShoulder,
        PoseLandmarkType.leftElbow,
        paint,
      );
      _drawLine(
        canvas,
        pose,
        PoseLandmarkType.leftElbow,
        PoseLandmarkType.leftWrist,
        paint,
      );
      _drawLine(
        canvas,
        pose,
        PoseLandmarkType.rightShoulder,
        PoseLandmarkType.rightElbow,
        paint,
      );
      _drawLine(
        canvas,
        pose,
        PoseLandmarkType.rightElbow,
        PoseLandmarkType.rightWrist,
        paint,
      );
      _drawLine(
        canvas,
        pose,
        PoseLandmarkType.leftShoulder,
        PoseLandmarkType.rightShoulder,
        paint,
      );
      _drawLine(
        canvas,
        pose,
        PoseLandmarkType.leftShoulder,
        PoseLandmarkType.leftHip,
        paint,
      );
      _drawLine(
        canvas,
        pose,
        PoseLandmarkType.rightShoulder,
        PoseLandmarkType.rightHip,
        paint,
      );
      _drawLine(
        canvas,
        pose,
        PoseLandmarkType.leftHip,
        PoseLandmarkType.rightHip,
        paint,
      );
      _drawLine(
        canvas,
        pose,
        PoseLandmarkType.leftHip,
        PoseLandmarkType.leftKnee,
        paint,
      );
      _drawLine(
        canvas,
        pose,
        PoseLandmarkType.leftKnee,
        PoseLandmarkType.leftAnkle,
        paint,
      );
      _drawLine(
        canvas,
        pose,
        PoseLandmarkType.rightHip,
        PoseLandmarkType.rightKnee,
        paint,
      );
      _drawLine(
        canvas,
        pose,
        PoseLandmarkType.rightKnee,
        PoseLandmarkType.rightAnkle,
        paint,
      );

      // Draw dots
      for (final landmark in pose.landmarks.values) {
        final point = _scale(landmark);
        canvas.drawCircle(point, 5, dotPaint);
      }
    }
  }

  void _drawLine(
    Canvas canvas,
    Pose pose,
    PoseLandmarkType type1,
    PoseLandmarkType type2,
    Paint paint,
  ) {
    final lm1 = pose.landmarks[type1];
    final lm2 = pose.landmarks[type2];
    if (lm1 != null && lm2 != null) {
      canvas.drawLine(_scale(lm1), _scale(lm2), paint);
    }
  }

  Offset _scale(PoseLandmark landmark) {
    var x = landmark.x * screenSize.width / imageSize.width;
    final y = landmark.y * screenSize.height / imageSize.height;
    if (mirror) x = screenSize.width - x;
    return Offset(x, y);
  }

  @override
  bool shouldRepaint(covariant _PoseOverlayPainter oldDelegate) => true;
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: (color ?? Colors.white).withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: (color ?? Colors.white).withValues(alpha: 0.5),
              ),
            ),
            child: Icon(icon, color: color ?? Colors.white, size: 24),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(color: color ?? Colors.white70, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;

  const _ResultRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
