# Smart Physio - Complete Flutter Implementation Plan

## AI-Based Muscle Pain Relief & Exercise Recommendation System

---

## 1. PROJECT ARCHITECTURE OVERVIEW

```
smart_physio/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_colors.dart
│   │   │   ├── app_strings.dart
│   │   │   ├── app_assets.dart
│   │   │   └── api_endpoints.dart
│   │   ├── theme/
│   │   │   ├── app_theme.dart
│   │   │   └── text_styles.dart
│   │   ├── utils/
│   │   │   ├── validators.dart
│   │   │   ├── helpers.dart
│   │   │   └── extensions.dart
│   │   ├── errors/
│   │   │   ├── exceptions.dart
│   │   │   └── failures.dart
│   │   └── network/
│   │       ├── api_client.dart
│   │       ├── api_interceptors.dart
│   │       └── network_info.dart
│   ├── config/
│   │   ├── routes/
│   │   │   ├── app_router.dart
│   │   │   └── route_names.dart
│   │   └── di/
│   │       └── injection_container.dart
│   ├── features/
│   │   ├── auth/
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   ├── datasources/
│   │   │   │   └── repositories/
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   ├── repositories/
│   │   │   │   └── usecases/
│   │   │   └── presentation/
│   │   │       ├── screens/
│   │   │       ├── widgets/
│   │   │       └── providers/
│   │   ├── pain_assessment/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   ├── exercise_recommendation/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   ├── pose_detection/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   ├── progress_tracking/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   └── profile/
│   │       ├── data/
│   │       ├── domain/
│   │       └── presentation/
│   └── shared/
│       ├── widgets/
│       ├── models/
│       └── services/
├── assets/
│   ├── images/
│   ├── animations/
│   ├── icons/
│   └── exercises/  (exercise demo videos/gifs)
├── test/
├── backend/  (Node.js + Express)
│   ├── src/
│   │   ├── controllers/
│   │   ├── models/
│   │   ├── routes/
│   │   ├── middleware/
│   │   ├── services/
│   │   └── config/
│   └── package.json
└── ai_model/  (Python ML + Pose Detection)
    ├── pain_classifier/
    ├── pose_detection/
    ├── dataset/
    └── requirements.txt
```

---

## 2. TECHNOLOGY STACK (Updated for Flutter)

| Layer | Technology |
|-------|-----------|
| **Frontend** | Flutter 3.x (Dart) |
| **State Management** | Riverpod 2.x |
| **Navigation** | GoRouter |
| **Backend** | Node.js + Express.js |
| **Database** | MongoDB + Mongoose |
| **Authentication** | JWT + Firebase Auth |
| **AI/ML Model** | Python (scikit-learn / TensorFlow Lite) |
| **Pose Detection** | Google ML Kit Pose Detection (on-device) |
| **Camera** | camera package + image processing |
| **Local Storage** | SharedPreferences + Hive |
| **HTTP Client** | Dio |
| **API** | RESTful APIs |
| **Real-time Feedback** | Text-to-Speech (flutter_tts) |
| **Animations** | Lottie + Rive |
| **Charts** | fl_chart |

---

## 3. FEATURE-BY-FEATURE IMPLEMENTATION PLAN

---

### PHASE 1: PROJECT SETUP & AUTHENTICATION (Week 1-2)

#### 1.1 Flutter Project Initialization

```yaml
# pubspec.yaml - Key dependencies
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.4.9
  go_router: ^13.0.0
  dio: ^5.4.0
  shared_preferences: ^2.2.2
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  json_annotation: ^4.8.1
  freezed_annotation: ^2.4.1
  flutter_svg: ^2.0.9
  cached_network_image: ^3.3.1
  google_mlkit_pose_detection: ^0.11.0
  camera: ^0.10.5+9
  flutter_tts: ^3.8.5
  fl_chart: ^0.66.0
  lottie: ^3.0.0
  image_picker: ^1.0.7
  permission_handler: ^11.2.0
  connectivity_plus: ^5.0.2
  flutter_animate: ^4.3.0
  
dev_dependencies:
  build_runner: ^2.4.7
  freezed: ^2.4.5
  json_serializable: ^6.7.1
  riverpod_generator: ^2.3.9
  mockito: ^5.4.4
  flutter_test:
    sdk: flutter
```

#### 1.2 Authentication Module

**Screens:**
- Splash Screen (animated logo)
- Onboarding Screen (3 slides explaining app features)
- Login Screen (email/password)
- Register Screen (name, email, password, age, gender)
- Forgot Password Screen

**Backend API Endpoints:**
```
POST /api/auth/register
POST /api/auth/login
POST /api/auth/forgot-password
POST /api/auth/reset-password
GET  /api/auth/profile
PUT  /api/auth/profile
```

**User Model:**
```dart
class User {
  final String id;
  final String name;
  final String email;
  final int age;
  final String gender;
  final double? weight;
  final double? height;
  final List<String> healthConditions;
  final DateTime createdAt;
}
```

---

### PHASE 2: PAIN ASSESSMENT MODULE (Week 3-4)

#### 2.1 Body Part Selection UI

**Interactive Body Map:**
- Display a human body illustration (front/back view)
- Tappable regions: Shoulders, Arms, Forearms, Thighs, Legs
- Highlight selected body part with animation
- Support for multiple selections

**Implementation:**
```dart
// Custom painter for body map with hit-test regions
class BodyMapPainter extends CustomPainter {
  // Draw body outline
  // Define tap regions for each muscle group
  // Highlight active selections
}
```

#### 2.2 Pain Assessment Questionnaire

**Data Collection Flow:**
1. **Body Part Selection** - Which area hurts? (visual selector)
2. **Pain Type** - Sharp, Dull, Burning, Throbbing, Stiffness
3. **Pain Severity** - Scale 1-10 (slider)
4. **Pain Duration** - How long? (hours/days/weeks)
5. **Pain Trigger** - What causes it? (sitting, exercise, lifting, etc.)
6. **Movement Limitations** - Can you raise arm? Bend knee? etc.
7. **User Context** - Age already in profile, activity level

**Pain Assessment Model:**
```dart
class PainAssessment {
  final String id;
  final String userId;
  final List<String> bodyParts;       // ["shoulder", "arm"]
  final String painType;              // "sharp", "dull", etc.
  final int severity;                 // 1-10
  final String duration;              // "2_days", "1_week"
  final List<String> triggers;        // ["sitting", "lifting"]
  final List<String> limitations;     // movement limitations
  final DateTime assessedAt;
}
```

**Backend API:**
```
POST /api/assessment/submit
GET  /api/assessment/history
GET  /api/assessment/:id
```

---

### PHASE 3: AI EXERCISE RECOMMENDATION ENGINE (Week 5-6)

#### 3.1 ML Model (Python Backend)

**Dataset Structure:**
```json
{
  "body_part": "shoulder",
  "pain_type": "stiffness",
  "severity": 6,
  "age_group": "25-40",
  "trigger": "prolonged_sitting",
  "recommended_exercises": ["pendulum_stretch", "wall_climb", "cross_body_stretch"],
  "precautions": ["avoid overhead movements", "stop if sharp pain"],
  "duration_weeks": 2,
  "frequency": "3x_daily"
}
```

**Classification Approach:**
- Decision Tree / Random Forest for pain classification
- Rule-based mapping for exercise recommendations
- Safety rules engine for precautions

#### 3.2 Exercise Recommendation Screen

**Exercise Model:**
```dart
class Exercise {
  final String id;
  final String name;
  final String description;
  final String targetMuscle;        // "shoulder", "thigh", etc.
  final String difficulty;          // "easy", "medium", "hard"
  final int durationSeconds;
  final int repetitions;
  final int sets;
  final String videoUrl;
  final String thumbnailUrl;
  final List<String> instructions;  // Step-by-step
  final List<String> precautions;
  final List<PoseKeypoint> correctForm;  // For pose validation
  final String category;            // "stretch", "mobility", "warmup"
}
```

**UI Components:**
- Exercise list with difficulty badges
- Detailed exercise card (video + instructions)
- Safety warnings banner
- "Start Exercise" button → navigates to pose detection
- Filter by: body part, difficulty, duration

**Backend API:**
```
POST /api/exercises/recommend     (body: pain assessment data)
GET  /api/exercises/:id
GET  /api/exercises/by-muscle/:muscle
GET  /api/exercises/categories
```

---

### PHASE 4: POSE DETECTION & REAL-TIME CORRECTION (Week 7-9)

#### 4.1 Camera Setup & ML Kit Integration

**Core Implementation:**
```dart
class PoseDetectionService {
  late PoseDetector _poseDetector;
  
  // Initialize ML Kit Pose Detector
  void initialize() {
    _poseDetector = PoseDetector(
      options: PoseDetectorOptions(
        mode: PoseDetectionMode.stream,
        model: PoseDetectionModel.accurate,
      ),
    );
  }
  
  // Process camera frames
  Future<Pose?> detectPose(InputImage image) async {
    final poses = await _poseDetector.processImage(image);
    return poses.isNotEmpty ? poses.first : null;
  }
}
```

#### 4.2 Joint Angle Calculation

**Key Angles to Monitor (per exercise):**

| Body Part | Key Joints | Angles to Track |
|-----------|-----------|----------------|
| Shoulder | Shoulder, Elbow, Wrist | Shoulder abduction, flexion |
| Arm | Shoulder, Elbow, Wrist | Elbow flexion/extension |
| Forearm | Elbow, Wrist, Fingers | Wrist rotation |
| Thigh | Hip, Knee, Ankle | Hip flexion, knee bend |
| Leg | Knee, Ankle, Foot | Knee extension, ankle dorsiflexion |

**Angle Calculator:**
```dart
class AngleCalculator {
  // Calculate angle between 3 points
  static double calculateAngle(
    PoseLandmark pointA,
    PoseLandmark pointB,  // vertex
    PoseLandmark pointC,
  ) {
    final radians = atan2(pointC.y - pointB.y, pointC.x - pointB.x) -
                    atan2(pointA.y - pointB.y, pointA.x - pointB.x);
    var angle = radians * 180 / pi;
    if (angle < 0) angle += 360;
    if (angle > 180) angle = 360 - angle;
    return angle;
  }
}
```

#### 4.3 Exercise Form Validator

```dart
class ExerciseFormValidator {
  final Exercise exercise;
  final Map<String, AngleRange> expectedAngles;
  
  FormFeedback validate(Pose currentPose) {
    List<String> corrections = [];
    
    // Check each required angle
    for (var entry in expectedAngles.entries) {
      final currentAngle = _getCurrentAngle(entry.key, currentPose);
      final expected = entry.value;
      
      if (currentAngle < expected.min) {
        corrections.add(expected.tooLowMessage);
      } else if (currentAngle > expected.max) {
        corrections.add(expected.tooHighMessage);
      }
    }
    
    // Check spine alignment
    if (_isSpineMisaligned(currentPose)) {
      corrections.add("Keep your spine straight");
    }
    
    return FormFeedback(
      isCorrect: corrections.isEmpty,
      corrections: corrections,
      score: _calculateFormScore(corrections.length),
    );
  }
}
```

#### 4.4 Real-Time Feedback System

**Feedback Types:**
1. **Visual** - Color overlay on body (green = correct, red = incorrect)
2. **Text** - On-screen correction messages
3. **Audio** - Text-to-speech voice guidance

**Implementation:**
```dart
class FeedbackService {
  final FlutterTts _tts = FlutterTts();
  
  // Throttled voice feedback (avoid spam)
  DateTime? _lastVoiceFeedback;
  
  Future<void> provideFeedback(FormFeedback feedback) async {
    if (!feedback.isCorrect) {
      // Visual: update UI overlay
      _updateVisualFeedback(feedback);
      
      // Voice: throttle to every 3 seconds
      if (_shouldGiveVoiceFeedback()) {
        await _tts.speak(feedback.corrections.first);
        _lastVoiceFeedback = DateTime.now();
      }
    }
  }
}
```

#### 4.5 Exercise Session Screen

**UI Layout:**
```
┌─────────────────────────────┐
│  [Camera Preview - Full]     │
│                              │
│  ┌──────────────────────┐   │
│  │ Pose Overlay (Skeleton)│   │
│  │ + Color Indicators     │   │
│  └──────────────────────┘   │
│                              │
│  ┌─────────────────┐        │
│  │ Rep Counter: 5/10│        │
│  │ Set: 2/3         │        │
│  │ Form Score: 85%  │        │
│  └─────────────────┘        │
│                              │
│  ┌─────────────────────┐    │
│  │ "Lift your arm higher"│    │
│  │ (correction message)  │    │
│  └─────────────────────┘    │
│                              │
│  [Pause]  [Skip]  [End]     │
└─────────────────────────────┘
```

**Rep Counter Logic:**
```dart
class RepCounter {
  int _repCount = 0;
  bool _isInStartPosition = true;
  
  // Track state transitions (start → end → start = 1 rep)
  void update(double primaryAngle, AngleRange range) {
    if (_isInStartPosition && primaryAngle >= range.endPosition) {
      _isInStartPosition = false;
    } else if (!_isInStartPosition && primaryAngle <= range.startPosition) {
      _isInStartPosition = true;
      _repCount++;
    }
  }
}
```

---

### PHASE 5: PROGRESS TRACKING & HISTORY (Week 10-11)

#### 5.1 Session Recording

**Session Model:**
```dart
class ExerciseSession {
  final String id;
  final String oderId;
  final String exerciseId;
  final DateTime startTime;
  final DateTime endTime;
  final int totalReps;
  final int correctReps;
  final double averageFormScore;
  final List<String> commonMistakes;
  final int caloriesBurned;  // estimated
  final String painLevelBefore;
  final String painLevelAfter;
}
```

#### 5.2 Progress Dashboard

**Charts & Visualizations:**
- Weekly exercise frequency (bar chart)
- Form score improvement over time (line chart)
- Pain level trends (line chart)
- Body part exercise distribution (pie chart)
- Streak counter and achievements

**Backend API:**
```
POST /api/sessions/record
GET  /api/sessions/history?from=&to=
GET  /api/progress/summary
GET  /api/progress/pain-trends
GET  /api/progress/weekly-stats
```

#### 5.3 Achievement System

**Badges:**
- First Exercise Completed
- 7-Day Streak
- Perfect Form (100% score)
- Pain Reduced (self-reported improvement)
- 50 Sessions Milestone

---

### PHASE 6: USER PROFILE & SETTINGS (Week 11-12)

#### 6.1 Profile Management

**Features:**
- Edit personal information
- Health conditions management
- Exercise preferences (difficulty, duration)
- Notification settings
- Dark/Light theme toggle
- Language selection
- Camera position preference (front/back)

#### 6.2 Settings

```dart
class UserPreferences {
  final bool voiceFeedbackEnabled;
  final String feedbackLanguage;
  final int exerciseRestDuration;  // seconds between sets
  final bool showSkeletonOverlay;
  final String cameraPosition;     // "front" or "back"
  final bool darkMode;
  final bool dailyReminder;
  final TimeOfDay reminderTime;
}
```

---

## 4. BACKEND IMPLEMENTATION PLAN

### 4.1 Node.js + Express Structure

```
backend/
├── src/
│   ├── app.js                  # Express app setup
│   ├── server.js               # Server entry point
│   ├── config/
│   │   ├── db.js               # MongoDB connection
│   │   ├── env.js              # Environment variables
│   │   └── cors.js             # CORS config
│   ├── models/
│   │   ├── User.js
│   │   ├── Exercise.js
│   │   ├── PainAssessment.js
│   │   ├── ExerciseSession.js
│   │   └── Progress.js
│   ├── controllers/
│   │   ├── authController.js
│   │   ├── exerciseController.js
│   │   ├── assessmentController.js
│   │   ├── sessionController.js
│   │   └── progressController.js
│   ├── routes/
│   │   ├── authRoutes.js
│   │   ├── exerciseRoutes.js
│   │   ├── assessmentRoutes.js
│   │   ├── sessionRoutes.js
│   │   └── progressRoutes.js
│   ├── middleware/
│   │   ├── auth.js             # JWT verification
│   │   ├── errorHandler.js
│   │   └── validation.js
│   ├── services/
│   │   ├── aiService.js        # Calls Python ML API
│   │   ├── emailService.js
│   │   └── recommendationService.js
│   └── utils/
│       ├── token.js
│       └── response.js
├── .env
├── package.json
└── Dockerfile
```

### 4.2 MongoDB Schemas

```javascript
// User Schema
const userSchema = new Schema({
  name: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  age: { type: Number, required: true },
  gender: { type: String, enum: ['male', 'female', 'other'] },
  weight: Number,
  height: Number,
  healthConditions: [String],
  activityLevel: { type: String, enum: ['sedentary', 'light', 'moderate', 'active'] },
  createdAt: { type: Date, default: Date.now }
});

// Exercise Schema
const exerciseSchema = new Schema({
  name: { type: String, required: true },
  description: String,
  targetMuscle: { type: String, enum: ['shoulder', 'arm', 'forearm', 'thigh', 'leg'] },
  category: { type: String, enum: ['stretch', 'mobility', 'warmup', 'strengthening'] },
  difficulty: { type: String, enum: ['easy', 'medium', 'hard'] },
  durationSeconds: Number,
  repetitions: Number,
  sets: Number,
  videoUrl: String,
  thumbnailUrl: String,
  instructions: [String],
  precautions: [String],
  poseAngles: {  // Expected angles for pose validation
    type: Map,
    of: { min: Number, max: Number, joint: String }
  },
  suitableFor: {
    ageGroups: [String],
    painTypes: [String],
    severityMax: Number
  }
});

// Pain Assessment Schema
const assessmentSchema = new Schema({
  userId: { type: Schema.Types.ObjectId, ref: 'User' },
  bodyParts: [{ type: String, enum: ['shoulder', 'arm', 'forearm', 'thigh', 'leg'] }],
  painType: { type: String, enum: ['sharp', 'dull', 'burning', 'throbbing', 'stiffness'] },
  severity: { type: Number, min: 1, max: 10 },
  duration: String,
  triggers: [String],
  limitations: [String],
  recommendedExercises: [{ type: Schema.Types.ObjectId, ref: 'Exercise' }],
  createdAt: { type: Date, default: Date.now }
});

// Exercise Session Schema
const sessionSchema = new Schema({
  userId: { type: Schema.Types.ObjectId, ref: 'User' },
  exerciseId: { type: Schema.Types.ObjectId, ref: 'Exercise' },
  startTime: Date,
  endTime: Date,
  totalReps: Number,
  correctReps: Number,
  averageFormScore: Number,
  commonMistakes: [String],
  painLevelBefore: Number,
  painLevelAfter: Number,
  createdAt: { type: Date, default: Date.now }
});
```

---

## 5. AI/ML MODEL PLAN

### 5.1 Pain Classification Model (Python)

```python
# pain_classifier/model.py

# Dataset: Custom CSV with columns:
# body_part, pain_type, severity, age, trigger, activity_level → recommended_exercises

# Approach: Multi-label classification
# Input: User symptoms → Output: Exercise category + specific exercises

from sklearn.ensemble import RandomForestClassifier
from sklearn.preprocessing import LabelEncoder
import joblib

class PainClassifier:
    def __init__(self):
        self.model = RandomForestClassifier(n_estimators=100)
        self.encoders = {}
    
    def train(self, dataset_path):
        # Load and preprocess dataset
        # Train model
        # Save model
        pass
    
    def predict(self, symptoms):
        # Encode input
        # Predict exercise category
        # Return top-N exercises with confidence
        pass
```

### 5.2 Exercise-Pain Mapping Dataset

**Create manually curated dataset with physiotherapy knowledge:**

| Body Part | Pain Type | Severity | Age Group | Recommended Exercises | Precautions |
|-----------|-----------|----------|-----------|----------------------|-------------|
| Shoulder | Stiffness | 3-5 | All | Pendulum stretch, Wall walk | Avoid overhead |
| Shoulder | Sharp | 7-9 | Elderly | Gentle rotation, Ice first | See doctor if persists |
| Thigh | Dull | 4-6 | 20-40 | Quad stretch, Hamstring curl | Warm up first |
| Leg | Stiffness | 3-5 | All | Calf raises, Ankle circles | Hold support |
| Arm | Burning | 5-7 | All | Bicep stretch, Wrist flex | Rest between sets |
| Forearm | Stiffness | 3-5 | Office | Wrist rotations, Finger spread | Take breaks |

### 5.3 Python Flask API (for ML model serving)

```python
# api/app.py
from flask import Flask, request, jsonify
from pain_classifier import PainClassifier

app = Flask(__name__)
classifier = PainClassifier()
classifier.load_model('models/pain_classifier.pkl')

@app.route('/api/ml/classify-pain', methods=['POST'])
def classify_pain():
    data = request.json
    result = classifier.predict(data)
    return jsonify(result)

@app.route('/api/ml/recommend-exercises', methods=['POST'])
def recommend_exercises():
    data = request.json
    exercises = classifier.get_recommendations(data)
    return jsonify(exercises)
```

---

## 6. POSE DETECTION - EXERCISE DEFINITIONS

### 6.1 Supported Exercises with Pose Rules

#### SHOULDER EXERCISES:

**1. Pendulum Stretch**
```dart
const pendulumStretchRules = PoseRules(
  name: "Pendulum Stretch",
  keyJoints: [shoulder, elbow, wrist, hip],
  checkpoints: [
    // Body leaning forward
    AngleCheck(joint: "hip", expectedRange: (45, 90), message: "Lean forward more"),
    // Arm hanging loose
    AngleCheck(joint: "shoulder", expectedRange: (160, 180), message: "Let your arm hang naturally"),
    // Gentle swing
    MovementCheck(joint: "wrist", pattern: "circular", radius: (10, 30)),
  ],
  repDetection: RepDetection.circular(joint: "wrist", minRadius: 10),
);
```

**2. Wall Climb Stretch**
```dart
const wallClimbRules = PoseRules(
  name: "Wall Climb",
  keyJoints: [shoulder, elbow, wrist],
  checkpoints: [
    AngleCheck(joint: "shoulder", expectedRange: (90, 170), message: "Raise arm higher along the wall"),
    AngleCheck(joint: "elbow", expectedRange: (160, 180), message: "Keep arm straight"),
  ],
  repDetection: RepDetection.upDown(joint: "wrist", threshold: 50),
);
```

#### THIGH EXERCISES:

**3. Standing Quad Stretch**
```dart
const quadStretchRules = PoseRules(
  name: "Quad Stretch",
  keyJoints: [hip, knee, ankle],
  checkpoints: [
    AngleCheck(joint: "knee", expectedRange: (30, 60), message: "Bend knee more, bring heel to glute"),
    AngleCheck(joint: "hip", expectedRange: (170, 180), message: "Keep hips straight, don't lean"),
    AlignmentCheck(points: [shoulder, hip, standingKnee], tolerance: 10, message: "Stand tall"),
  ],
  holdDuration: Duration(seconds: 30),
);
```

#### LEG EXERCISES:

**4. Calf Raises**
```dart
const calfRaiseRules = PoseRules(
  name: "Calf Raise",
  keyJoints: [knee, ankle, toe],
  checkpoints: [
    AngleCheck(joint: "ankle", expectedRange: (130, 160), message: "Rise higher on your toes"),
    AngleCheck(joint: "knee", expectedRange: (170, 180), message: "Keep knees straight"),
  ],
  repDetection: RepDetection.upDown(joint: "ankle", threshold: 20),
);
```

---

## 7. SCREEN FLOW & NAVIGATION

```
App Launch
    │
    ├── Splash Screen (2s)
    │
    ├── Onboarding (first time only)
    │       │── Slide 1: "Identify Your Pain"
    │       │── Slide 2: "Get Safe Exercises"  
    │       └── Slide 3: "AI Corrects Your Form"
    │
    ├── Auth Flow
    │       ├── Login
    │       └── Register → Profile Setup
    │
    └── Main App (Bottom Navigation)
            │
            ├── 🏠 Home
            │       ├── Daily Exercise Summary
            │       ├── Quick Pain Assessment Button
            │       ├── Recent Exercises
            │       └── Motivational Cards
            │
            ├── 💪 Exercises
            │       ├── By Body Part (tabs)
            │       ├── Exercise Detail → Start Session
            │       └── Favorites
            │
            ├── 📊 Progress  
            │       ├── Weekly Stats
            │       ├── Pain Trends
            │       ├── Form Score History
            │       └── Achievements
            │
            ├── 🎯 Assessment
            │       ├── Body Map Selection
            │       ├── Questionnaire Flow
            │       └── Results + Recommendations
            │
            └── 👤 Profile
                    ├── Personal Info
                    ├── Health Conditions
                    ├── Preferences
                    └── Settings
```

---

## 8. DETAILED SPRINT PLAN

### Sprint 1 (Week 1-2): Foundation
- [x] Flutter project setup with clean architecture
- [ ] Implement theme, colors, typography
- [ ] Setup Dio client with interceptors
- [ ] Implement authentication (login/register/logout)
- [ ] Backend: Auth routes + JWT middleware
- [ ] MongoDB connection + User model
- [ ] Splash + Onboarding screens

### Sprint 2 (Week 3-4): Pain Assessment
- [ ] Interactive body map widget (CustomPainter)
- [ ] Pain questionnaire multi-step form
- [ ] Backend: Assessment API + model
- [ ] Store assessment history
- [ ] Assessment results screen

### Sprint 3 (Week 5-6): Exercise Engine
- [ ] Python ML model training (pain → exercises)
- [ ] Flask API for ML predictions
- [ ] Exercise database seeding (30+ exercises)
- [ ] Exercise list/detail screens
- [ ] Video/animation player for demos
- [ ] Backend: Exercise CRUD + Recommendation API

### Sprint 4 (Week 7-9): Pose Detection (Core Feature)
- [ ] Camera permission + setup
- [ ] ML Kit Pose Detection integration
- [ ] Skeleton overlay on camera feed
- [ ] Joint angle calculation engine
- [ ] Exercise-specific pose validators (5+ exercises)
- [ ] Rep counter logic
- [ ] Real-time visual feedback (color overlay)
- [ ] Voice feedback (flutter_tts)
- [ ] Exercise session screen UI
- [ ] Session recording + scoring

### Sprint 5 (Week 10-11): Progress & Polish
- [ ] Progress dashboard with charts
- [ ] Pain trend tracking
- [ ] Achievement/badge system
- [ ] Session history list
- [ ] Export progress report
- [ ] Push notifications (daily reminders)

### Sprint 6 (Week 12): Testing & Deployment
- [ ] Unit tests for core logic
- [ ] Widget tests for key screens
- [ ] Integration tests for API calls
- [ ] Performance optimization
- [ ] APK build for Android
- [ ] Bug fixes and polish

---

## 9. KEY FLUTTER CODE SNIPPETS

### 9.1 App Router Setup

```dart
final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
    ShellRoute(
      builder: (_, __, child) => MainShell(child: child),
      routes: [
        GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
        GoRoute(path: '/exercises', builder: (_, __) => const ExercisesScreen()),
        GoRoute(path: '/exercises/:id', builder: (_, state) => 
          ExerciseDetailScreen(id: state.pathParameters['id']!)),
        GoRoute(path: '/assessment', builder: (_, __) => const AssessmentScreen()),
        GoRoute(path: '/progress', builder: (_, __) => const ProgressScreen()),
        GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
        GoRoute(path: '/exercise-session/:id', builder: (_, state) =>
          ExerciseSessionScreen(exerciseId: state.pathParameters['id']!)),
      ],
    ),
  ],
);
```

### 9.2 Pose Detection Provider

```dart
@riverpod
class PoseDetectionNotifier extends _$PoseDetectionNotifier {
  late PoseDetector _detector;
  late CameraController _cameraController;
  
  @override
  PoseDetectionState build() {
    _detector = PoseDetector(options: PoseDetectorOptions(
      mode: PoseDetectionMode.stream,
    ));
    return PoseDetectionState.initial();
  }
  
  Future<void> startDetection(Exercise exercise) async {
    _cameraController.startImageStream((image) async {
      final inputImage = _convertToInputImage(image);
      final poses = await _detector.processImage(inputImage);
      
      if (poses.isNotEmpty) {
        final feedback = _validateForm(poses.first, exercise);
        state = state.copyWith(
          currentPose: poses.first,
          feedback: feedback,
          repCount: _updateRepCount(poses.first),
        );
      }
    });
  }
}
```

### 9.3 Body Map Widget

```dart
class BodyMapWidget extends StatelessWidget {
  final Set<BodyPart> selectedParts;
  final ValueChanged<BodyPart> onPartTapped;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        final tappedPart = _hitTest(details.localPosition);
        if (tappedPart != null) onPartTapped(tappedPart);
      },
      child: CustomPaint(
        painter: BodyMapPainter(selectedParts: selectedParts),
        size: const Size(300, 500),
      ),
    );
  }
}
```

---

## 10. EXERCISE DATABASE (Sample - 30+ needed)

### Shoulder Exercises
1. Pendulum Stretch - Easy - Mobility
2. Wall Climb - Easy - Stretch
3. Cross-Body Stretch - Easy - Stretch
4. Shoulder Shrugs - Easy - Warmup
5. External Rotation - Medium - Strengthening
6. Doorway Stretch - Easy - Stretch

### Arm Exercises
7. Bicep Stretch - Easy - Stretch
8. Tricep Overhead Stretch - Easy - Stretch
9. Arm Circles - Easy - Warmup
10. Wall Push-Up - Medium - Strengthening
11. Isometric Bicep Hold - Medium - Strengthening

### Forearm Exercises
12. Wrist Flexor Stretch - Easy - Stretch
13. Wrist Extensor Stretch - Easy - Stretch
14. Wrist Rotations - Easy - Mobility
15. Finger Spread - Easy - Mobility
16. Forearm Pronation/Supination - Easy - Mobility

### Thigh Exercises
17. Standing Quad Stretch - Easy - Stretch
18. Hamstring Stretch - Easy - Stretch
19. Leg Swings - Easy - Warmup
20. Wall Sit - Medium - Strengthening
21. Lying Quad Stretch - Easy - Stretch
22. Hip Flexor Stretch - Medium - Stretch

### Leg Exercises
23. Calf Raises - Easy - Strengthening
24. Ankle Circles - Easy - Mobility
25. Standing Calf Stretch - Easy - Stretch
26. Toe Raises - Easy - Strengthening
27. Seated Leg Extension - Medium - Strengthening
28. Step-Ups - Medium - Strengthening
29. Knee-to-Chest Stretch - Easy - Stretch
30. Straight Leg Raise - Medium - Strengthening

---

## 11. SAFETY RULES ENGINE

```dart
class SafetyEngine {
  static List<String> getPrecautions({
    required int severity,
    required int age,
    required String painType,
    required List<String> healthConditions,
  }) {
    List<String> precautions = [];
    
    // High severity
    if (severity >= 8) {
      precautions.add("⚠️ Your pain level is high. Consider consulting a doctor before exercising.");
      precautions.add("Only perform gentle stretches. Stop immediately if pain increases.");
    }
    
    // Elderly users
    if (age >= 60) {
      precautions.add("Perform exercises slowly and with support nearby.");
      precautions.add("Avoid high-impact or fast movements.");
    }
    
    // Sharp pain
    if (painType == "sharp") {
      precautions.add("Sharp pain may indicate injury. Do not force movements.");
      precautions.add("Apply ice for 15 minutes before gentle stretching.");
    }
    
    // Health conditions
    if (healthConditions.contains("arthritis")) {
      precautions.add("Avoid repetitive high-load movements on affected joints.");
    }
    if (healthConditions.contains("osteoporosis")) {
      precautions.add("Avoid twisting or bending exercises.");
    }
    
    return precautions;
  }
  
  // Filter exercises based on safety
  static List<Exercise> filterSafeExercises(
    List<Exercise> exercises,
    PainAssessment assessment,
    User user,
  ) {
    return exercises.where((e) {
      if (assessment.severity >= 8 && e.difficulty != 'easy') return false;
      if (user.age >= 60 && e.difficulty == 'hard') return false;
      if (e.suitableFor.severityMax < assessment.severity) return false;
      return true;
    }).toList();
  }
}
```

---

## 12. DEPLOYMENT PLAN

### Android APK Build
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Backend Deployment Options
- **Development**: Local Node.js server
- **Production**: Railway / Render / AWS EC2
- **ML API**: Python Flask on same server or separate container

### Environment Variables
```env
# Backend .env
MONGODB_URI=mongodb://localhost:27017/smart_physio
JWT_SECRET=your_jwt_secret
JWT_EXPIRE=7d
ML_API_URL=http://localhost:5000
PORT=3000
```

---

## 13. TESTING STRATEGY

| Type | Tool | Coverage Target |
|------|------|----------------|
| Unit Tests | flutter_test | Core logic, validators, angle calculations |
| Widget Tests | flutter_test | Key UI components, forms |
| Integration | integration_test | Full flows (assessment → recommendation → session) |
| API Tests | Postman / Jest | All backend endpoints |
| ML Model | pytest | Classification accuracy > 85% |
| Pose Detection | Manual QA | 5 exercises × 3 users |

---

## 14. RISK MITIGATION

| Risk | Mitigation |
|------|-----------|
| Pose detection inaccuracy | Use ML Kit accurate mode + angle tolerance ranges |
| Poor lighting affects camera | Add lighting quality check before session starts |
| User performs dangerous movement | Safety alerts + auto-pause if severe misalignment |
| ML model gives wrong exercise | Rule-based safety filter on top of ML predictions |
| Backend downtime | Cache exercises locally using Hive |
| Large video files | Use compressed GIFs or Lottie animations |

---

## 15. GETTING STARTED - COMMANDS

```bash
# 1. Create Flutter project
flutter create smart_physio
cd smart_physio

# 2. Setup backend
mkdir backend && cd backend
npm init -y
npm install express mongoose bcryptjs jsonwebtoken cors dotenv helmet
npm install -D nodemon

# 3. Setup Python ML
mkdir ai_model && cd ai_model
python -m venv venv
source venv/bin/activate
pip install flask scikit-learn pandas numpy joblib

# 4. Run all services
# Terminal 1: Flutter
flutter run

# Terminal 2: Backend
cd backend && npm run dev

# Terminal 3: ML API
cd ai_model && python api/app.py
```

---

## SUMMARY

This is a **3-tier application**:
1. **Flutter Mobile App** - User interface, camera, pose detection (on-device)
2. **Node.js Backend** - Auth, data management, business logic
3. **Python ML Service** - Pain classification, exercise recommendation

**Total estimated screens:** 15-18
**Total estimated API endpoints:** 20+
**Exercises in database:** 30+
**Pose-validated exercises:** 8-10 (minimum for demo)

The project is ambitious but achievable within 12-16 weeks with focused sprint-based development. The pose detection module (Phase 4) is the most complex and should receive the most development time.
