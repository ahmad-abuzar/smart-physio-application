import '../../domain/entities/exercise_entity.dart';

/// Local exercise database - 30+ physiotherapy exercises
/// mapped to 5 body regions: shoulder, arm, forearm, thigh, leg
class ExerciseLocalData {
  static List<ExerciseEntity> getAllExercises() => [
        // ==================== SHOULDER EXERCISES ====================
        const ExerciseEntity(
          id: 'sh_01',
          name: 'Pendulum Stretch',
          description:
              'A gentle swinging exercise to loosen the shoulder joint and reduce stiffness.',
          targetMuscle: 'shoulder',
          category: 'mobility',
          difficulty: 'easy',
          durationSeconds: 60,
          repetitions: 10,
          sets: 2,
          instructions: [
            'Lean forward and place one hand on a table for support.',
            'Let the other arm hang down freely.',
            'Gently swing the hanging arm in small circles.',
            'Gradually increase the circle size.',
            'Swing clockwise 10 times, then counter-clockwise 10 times.',
            'Switch arms and repeat.',
          ],
          precautions: [
            'Do not swing too fast.',
            'Stop if you feel sharp pain.',
            'Keep your back straight while leaning.',
          ],
        ),
        const ExerciseEntity(
          id: 'sh_02',
          name: 'Wall Climb Stretch',
          description:
              'Walk your fingers up a wall to improve shoulder range of motion.',
          targetMuscle: 'shoulder',
          category: 'stretch',
          difficulty: 'easy',
          durationSeconds: 45,
          repetitions: 8,
          sets: 2,
          instructions: [
            'Stand facing a wall at arm\'s length.',
            'Place your fingertips on the wall at waist level.',
            'Slowly walk your fingers up the wall.',
            'Reach as high as comfortable without pain.',
            'Hold for 5 seconds at the top.',
            'Walk your fingers back down slowly.',
          ],
          precautions: [
            'Do not push past your comfort zone.',
            'Keep your body close to the wall.',
            'Avoid shrugging your shoulder up.',
          ],
        ),
        const ExerciseEntity(
          id: 'sh_03',
          name: 'Cross-Body Stretch',
          description:
              'Stretch the back of the shoulder by pulling your arm across your chest.',
          targetMuscle: 'shoulder',
          category: 'stretch',
          difficulty: 'easy',
          durationSeconds: 30,
          repetitions: 3,
          sets: 2,
          instructions: [
            'Stand or sit upright.',
            'Bring your right arm across your chest.',
            'Use your left hand to gently pull the right arm closer.',
            'Hold for 15-30 seconds.',
            'Release and switch arms.',
          ],
          precautions: [
            'Do not pull too hard.',
            'Keep your shoulder relaxed, not raised.',
          ],
        ),
        const ExerciseEntity(
          id: 'sh_04',
          name: 'Shoulder Shrugs',
          description:
              'Simple shrugging motion to relieve tension in the shoulder and neck area.',
          targetMuscle: 'shoulder',
          category: 'warmup',
          difficulty: 'easy',
          durationSeconds: 30,
          repetitions: 15,
          sets: 2,
          instructions: [
            'Stand with arms at your sides.',
            'Raise both shoulders up toward your ears.',
            'Hold for 2 seconds.',
            'Release and let shoulders drop down.',
            'Repeat 15 times.',
          ],
          precautions: [
            'Move smoothly, avoid jerky motions.',
            'Breathe normally throughout.',
          ],
        ),
        const ExerciseEntity(
          id: 'sh_05',
          name: 'External Rotation',
          description:
              'Strengthen the rotator cuff with controlled rotation movements.',
          targetMuscle: 'shoulder',
          category: 'strengthening',
          difficulty: 'medium',
          durationSeconds: 60,
          repetitions: 12,
          sets: 3,
          instructions: [
            'Stand with elbow bent at 90 degrees, tucked to your side.',
            'Hold a light resistance or just use your hand.',
            'Rotate your forearm outward, keeping elbow fixed.',
            'Slowly return to the starting position.',
            'Repeat 12 times per arm.',
          ],
          precautions: [
            'Keep elbow pressed against your side.',
            'Use slow, controlled movements.',
            'Stop if you feel clicking or sharp pain.',
          ],
        ),
        const ExerciseEntity(
          id: 'sh_06',
          name: 'Doorway Stretch',
          description:
              'Open up the chest and front shoulders using a doorframe for support.',
          targetMuscle: 'shoulder',
          category: 'stretch',
          difficulty: 'easy',
          durationSeconds: 30,
          repetitions: 3,
          sets: 2,
          instructions: [
            'Stand in an open doorway.',
            'Place your arms on the door frame, elbows at shoulder height.',
            'Step one foot forward gently.',
            'Feel the stretch in your chest and shoulders.',
            'Hold for 15-30 seconds.',
          ],
          precautions: [
            'Do not lean too far forward.',
            'Keep your back straight.',
          ],
        ),

        // ==================== ARM EXERCISES ====================
        const ExerciseEntity(
          id: 'ar_01',
          name: 'Bicep Stretch',
          description:
              'Stretch the front of the upper arm to relieve tightness.',
          targetMuscle: 'arm',
          category: 'stretch',
          difficulty: 'easy',
          durationSeconds: 30,
          repetitions: 3,
          sets: 2,
          instructions: [
            'Stand facing a wall.',
            'Place your palm flat on the wall, fingers pointing down.',
            'Slowly turn your body away from the wall.',
            'Feel the stretch in your bicep.',
            'Hold for 15-30 seconds.',
            'Switch arms.',
          ],
          precautions: [
            'Don\'t overstretch.',
            'Keep your arm straight during the stretch.',
          ],
        ),
        const ExerciseEntity(
          id: 'ar_02',
          name: 'Tricep Overhead Stretch',
          description:
              'Stretch the back of the upper arm by reaching behind your head.',
          targetMuscle: 'arm',
          category: 'stretch',
          difficulty: 'easy',
          durationSeconds: 30,
          repetitions: 3,
          sets: 2,
          instructions: [
            'Raise one arm overhead.',
            'Bend the elbow, placing your hand behind your head.',
            'Use the other hand to gently push the elbow back.',
            'Hold for 15-30 seconds.',
            'Switch arms.',
          ],
          precautions: [
            'Don\'t force the stretch.',
            'Keep your head in a neutral position.',
          ],
        ),
        const ExerciseEntity(
          id: 'ar_03',
          name: 'Arm Circles',
          description:
              'Warm up the arm and shoulder joints with circular motions.',
          targetMuscle: 'arm',
          category: 'warmup',
          difficulty: 'easy',
          durationSeconds: 45,
          repetitions: 20,
          sets: 2,
          instructions: [
            'Stand with arms extended to the sides.',
            'Make small circles forward for 20 rotations.',
            'Reverse direction for 20 rotations.',
            'Gradually increase circle size.',
          ],
          precautions: [
            'Start with small circles.',
            'Keep your core engaged.',
          ],
        ),
        const ExerciseEntity(
          id: 'ar_04',
          name: 'Wall Push-Up',
          description:
              'A gentle push-up variation to strengthen arms without floor pressure.',
          targetMuscle: 'arm',
          category: 'strengthening',
          difficulty: 'medium',
          durationSeconds: 60,
          repetitions: 12,
          sets: 3,
          instructions: [
            'Stand arm\'s length from a wall.',
            'Place palms flat on the wall, shoulder-width apart.',
            'Bend your elbows, leaning toward the wall.',
            'Push back to the starting position.',
            'Keep your body straight throughout.',
          ],
          precautions: [
            'Don\'t lock your elbows at the top.',
            'Keep your core tight.',
            'Breathe out as you push away.',
          ],
        ),
        const ExerciseEntity(
          id: 'ar_05',
          name: 'Isometric Bicep Hold',
          description:
              'Build arm strength by holding a position without movement.',
          targetMuscle: 'arm',
          category: 'strengthening',
          difficulty: 'medium',
          durationSeconds: 30,
          repetitions: 5,
          sets: 3,
          instructions: [
            'Stand with arms at your sides.',
            'Bend one elbow to 90 degrees.',
            'Push the palm of that hand against a wall or table.',
            'Hold the push for 5-10 seconds.',
            'Release and repeat.',
          ],
          precautions: [
            'Don\'t hold your breath.',
            'Keep the rest of your body relaxed.',
          ],
        ),

        // ==================== FOREARM EXERCISES ====================
        const ExerciseEntity(
          id: 'fa_01',
          name: 'Wrist Flexor Stretch',
          description:
              'Stretch the inner forearm to relieve typing and gripping strain.',
          targetMuscle: 'forearm',
          category: 'stretch',
          difficulty: 'easy',
          durationSeconds: 30,
          repetitions: 3,
          sets: 2,
          instructions: [
            'Extend your arm forward, palm facing up.',
            'Use the other hand to gently bend the wrist downward.',
            'Feel the stretch along the inner forearm.',
            'Hold for 15-30 seconds.',
            'Switch hands.',
          ],
          precautions: [
            'Apply gentle pressure only.',
            'Stop if you feel numbness.',
          ],
        ),
        const ExerciseEntity(
          id: 'fa_02',
          name: 'Wrist Extensor Stretch',
          description:
              'Stretch the outer forearm to help with wrist pain and tension.',
          targetMuscle: 'forearm',
          category: 'stretch',
          difficulty: 'easy',
          durationSeconds: 30,
          repetitions: 3,
          sets: 2,
          instructions: [
            'Extend your arm forward, palm facing down.',
            'Use the other hand to gently press the fingers downward.',
            'Feel the stretch along the top of your forearm.',
            'Hold for 15-30 seconds.',
            'Switch hands.',
          ],
          precautions: [
            'Do not force the stretch.',
            'Keep your arm straight.',
          ],
        ),
        const ExerciseEntity(
          id: 'fa_03',
          name: 'Wrist Rotations',
          description:
              'Improve wrist mobility with controlled circular movements.',
          targetMuscle: 'forearm',
          category: 'mobility',
          difficulty: 'easy',
          durationSeconds: 30,
          repetitions: 15,
          sets: 2,
          instructions: [
            'Extend your arm forward.',
            'Make a loose fist.',
            'Rotate your wrist clockwise 15 times.',
            'Rotate counter-clockwise 15 times.',
            'Switch hands.',
          ],
          precautions: [
            'Move slowly and smoothly.',
            'Do not grip too tightly.',
          ],
        ),
        const ExerciseEntity(
          id: 'fa_04',
          name: 'Finger Spread',
          description:
              'Open and close the fingers to improve grip and relieve tension.',
          targetMuscle: 'forearm',
          category: 'mobility',
          difficulty: 'easy',
          durationSeconds: 20,
          repetitions: 15,
          sets: 2,
          instructions: [
            'Hold your hand in front of you.',
            'Spread all fingers wide apart.',
            'Hold for 2 seconds.',
            'Make a tight fist.',
            'Hold for 2 seconds.',
            'Repeat 15 times.',
          ],
          precautions: [
            'Avoid squeezing too hard if you have joint pain.',
          ],
        ),
        const ExerciseEntity(
          id: 'fa_05',
          name: 'Forearm Pronation/Supination',
          description:
              'Rotate the forearm to improve range of motion and reduce stiffness.',
          targetMuscle: 'forearm',
          category: 'mobility',
          difficulty: 'easy',
          durationSeconds: 30,
          repetitions: 12,
          sets: 2,
          instructions: [
            'Bend your elbow at 90 degrees, arm at your side.',
            'Turn your palm face up (supination).',
            'Hold for 2 seconds.',
            'Turn your palm face down (pronation).',
            'Hold for 2 seconds.',
            'Repeat slowly.',
          ],
          precautions: [
            'Keep your elbow steady.',
            'Move only the forearm, not the whole arm.',
          ],
        ),

        // ==================== THIGH EXERCISES ====================
        const ExerciseEntity(
          id: 'th_01',
          name: 'Standing Quad Stretch',
          description:
              'Stretch the front of the thigh to relieve tightness and improve flexibility.',
          targetMuscle: 'thigh',
          category: 'stretch',
          difficulty: 'easy',
          durationSeconds: 30,
          repetitions: 3,
          sets: 2,
          instructions: [
            'Stand on one leg (hold a wall for balance).',
            'Bend your other knee and grab your ankle behind you.',
            'Gently pull your heel toward your glutes.',
            'Keep your knees close together.',
            'Hold for 15-30 seconds.',
            'Switch legs.',
          ],
          precautions: [
            'Use a wall for support if needed.',
            'Keep your standing knee slightly bent.',
            'Don\'t arch your back.',
          ],
        ),
        const ExerciseEntity(
          id: 'th_02',
          name: 'Hamstring Stretch',
          description:
              'Stretch the back of the thigh while standing or sitting.',
          targetMuscle: 'thigh',
          category: 'stretch',
          difficulty: 'easy',
          durationSeconds: 30,
          repetitions: 3,
          sets: 2,
          instructions: [
            'Sit on the floor with one leg extended.',
            'Bend the other knee, placing the sole against your inner thigh.',
            'Lean forward from the hips toward the extended leg.',
            'Reach toward your toes.',
            'Hold for 15-30 seconds.',
            'Switch legs.',
          ],
          precautions: [
            'Don\'t round your back.',
            'Lean from the hips, not the waist.',
            'Don\'t bounce.',
          ],
        ),
        const ExerciseEntity(
          id: 'th_03',
          name: 'Leg Swings',
          description:
              'Dynamic warm-up to loosen the hip and thigh muscles.',
          targetMuscle: 'thigh',
          category: 'warmup',
          difficulty: 'easy',
          durationSeconds: 30,
          repetitions: 15,
          sets: 2,
          instructions: [
            'Stand beside a wall for support.',
            'Swing one leg forward and backward like a pendulum.',
            'Keep the movement controlled.',
            'Do 15 swings, then switch legs.',
          ],
          precautions: [
            'Don\'t swing too high.',
            'Keep your upper body stable.',
          ],
        ),
        const ExerciseEntity(
          id: 'th_04',
          name: 'Wall Sit',
          description:
              'Strengthen quadriceps by holding a sitting position against a wall.',
          targetMuscle: 'thigh',
          category: 'strengthening',
          difficulty: 'medium',
          durationSeconds: 30,
          repetitions: 3,
          sets: 3,
          instructions: [
            'Stand with your back against a wall.',
            'Slide down until your thighs are parallel to the floor.',
            'Keep your knees above your ankles.',
            'Hold the position for 15-30 seconds.',
            'Slide back up and rest.',
          ],
          precautions: [
            'Don\'t let your knees go past your toes.',
            'Keep your back flat against the wall.',
            'Reduce depth if it\'s too painful.',
          ],
        ),
        const ExerciseEntity(
          id: 'th_05',
          name: 'Hip Flexor Stretch',
          description:
              'Release tight hip flexors that contribute to thigh and lower back pain.',
          targetMuscle: 'thigh',
          category: 'stretch',
          difficulty: 'medium',
          durationSeconds: 30,
          repetitions: 3,
          sets: 2,
          instructions: [
            'Kneel on one knee (use a cushion if needed).',
            'Place the other foot flat in front, knee at 90 degrees.',
            'Gently shift your weight forward.',
            'Feel the stretch in the front of your hip/thigh.',
            'Hold for 15-30 seconds.',
            'Switch sides.',
          ],
          precautions: [
            'Don\'t lean too far forward.',
            'Keep your back straight.',
          ],
        ),
        const ExerciseEntity(
          id: 'th_06',
          name: 'Lying Quad Stretch',
          description: 'Stretch the quadriceps while lying on your side.',
          targetMuscle: 'thigh',
          category: 'stretch',
          difficulty: 'easy',
          durationSeconds: 30,
          repetitions: 3,
          sets: 2,
          instructions: [
            'Lie on your side with legs stacked.',
            'Bend your top knee and grab your ankle.',
            'Gently pull your heel toward your glutes.',
            'Hold for 15-30 seconds.',
            'Switch sides.',
          ],
          precautions: [
            'Keep your hips aligned.',
            'Don\'t arch your back.',
          ],
        ),

        // ==================== LEG EXERCISES ====================
        const ExerciseEntity(
          id: 'lg_01',
          name: 'Calf Raises',
          description:
              'Strengthen the calf muscles by rising onto your toes.',
          targetMuscle: 'leg',
          category: 'strengthening',
          difficulty: 'easy',
          durationSeconds: 45,
          repetitions: 15,
          sets: 3,
          instructions: [
            'Stand with feet shoulder-width apart.',
            'Hold a wall or chair for balance.',
            'Rise up onto your toes as high as possible.',
            'Hold for 2 seconds at the top.',
            'Slowly lower back down.',
            'Repeat 15 times.',
          ],
          precautions: [
            'Use support if you have balance issues.',
            'Move slowly and controlled.',
          ],
        ),
        const ExerciseEntity(
          id: 'lg_02',
          name: 'Ankle Circles',
          description:
              'Improve ankle mobility and reduce stiffness with rotation.',
          targetMuscle: 'leg',
          category: 'mobility',
          difficulty: 'easy',
          durationSeconds: 30,
          repetitions: 15,
          sets: 2,
          instructions: [
            'Sit or stand on one foot.',
            'Lift the other foot slightly.',
            'Rotate your ankle clockwise 15 times.',
            'Rotate counter-clockwise 15 times.',
            'Switch feet.',
          ],
          precautions: [
            'Move slowly.',
            'Hold something for balance if standing.',
          ],
        ),
        const ExerciseEntity(
          id: 'lg_03',
          name: 'Standing Calf Stretch',
          description:
              'Stretch the calf muscle using a wall for support.',
          targetMuscle: 'leg',
          category: 'stretch',
          difficulty: 'easy',
          durationSeconds: 30,
          repetitions: 3,
          sets: 2,
          instructions: [
            'Face a wall with hands on it.',
            'Step one foot back, keeping it straight.',
            'Bend the front knee while keeping the back heel on the ground.',
            'Feel the stretch in the back calf.',
            'Hold for 15-30 seconds.',
            'Switch legs.',
          ],
          precautions: [
            'Keep the back heel flat on the ground.',
            'Don\'t bounce.',
          ],
        ),
        const ExerciseEntity(
          id: 'lg_04',
          name: 'Toe Raises',
          description:
              'Strengthen the shin muscles by lifting your toes off the ground.',
          targetMuscle: 'leg',
          category: 'strengthening',
          difficulty: 'easy',
          durationSeconds: 30,
          repetitions: 15,
          sets: 2,
          instructions: [
            'Stand with feet flat on the floor.',
            'Keep your heels on the ground.',
            'Lift your toes as high as possible.',
            'Hold for 2 seconds.',
            'Lower them back down.',
            'Repeat 15 times.',
          ],
          precautions: [
            'Use a chair for balance if needed.',
          ],
        ),
        const ExerciseEntity(
          id: 'lg_05',
          name: 'Knee-to-Chest Stretch',
          description:
              'Stretch the lower back and legs by pulling knees to chest.',
          targetMuscle: 'leg',
          category: 'stretch',
          difficulty: 'easy',
          durationSeconds: 30,
          repetitions: 3,
          sets: 2,
          instructions: [
            'Lie on your back with legs extended.',
            'Bring one knee toward your chest.',
            'Hold the knee with both hands.',
            'Gently pull closer for a deeper stretch.',
            'Hold for 15-30 seconds.',
            'Switch legs.',
          ],
          precautions: [
            'Keep the other leg flat or slightly bent.',
            'Don\'t force the knee too close.',
          ],
        ),
        const ExerciseEntity(
          id: 'lg_06',
          name: 'Straight Leg Raise',
          description:
              'Strengthen the leg while lying down - good for knee support.',
          targetMuscle: 'leg',
          category: 'strengthening',
          difficulty: 'medium',
          durationSeconds: 45,
          repetitions: 10,
          sets: 3,
          instructions: [
            'Lie on your back with one leg bent, foot flat.',
            'Keep the other leg straight.',
            'Slowly lift the straight leg to the height of the bent knee.',
            'Hold for 3 seconds.',
            'Slowly lower it back down.',
            'Repeat 10 times, then switch.',
          ],
          precautions: [
            'Don\'t arch your back.',
            'Keep the lifting leg straight.',
            'Move slowly and controlled.',
          ],
        ),
        const ExerciseEntity(
          id: 'lg_07',
          name: 'Step-Ups',
          description:
              'Functional exercise to strengthen legs using a low step.',
          targetMuscle: 'leg',
          category: 'strengthening',
          difficulty: 'medium',
          durationSeconds: 60,
          repetitions: 10,
          sets: 3,
          instructions: [
            'Stand in front of a low step or stair.',
            'Step up with one foot.',
            'Bring the other foot up to stand on the step.',
            'Step back down with the first foot.',
            'Repeat 10 times per leg.',
          ],
          precautions: [
            'Use a railing for support.',
            'Start with a low step height.',
            'Keep your knee aligned over your ankle.',
          ],
        ),
      ];

  static List<ExerciseEntity> getExercisesByMuscle(String muscle) {
    return getAllExercises()
        .where((e) => e.targetMuscle == muscle.toLowerCase())
        .toList();
  }

  static List<ExerciseEntity> getExercisesByDifficulty(String difficulty) {
    return getAllExercises()
        .where((e) => e.difficulty == difficulty.toLowerCase())
        .toList();
  }

  static ExerciseEntity? getExerciseById(String id) {
    final exercises = getAllExercises();
    try {
      return exercises.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }
}
