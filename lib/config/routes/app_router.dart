import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/home_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/exercise_recommendation/presentation/screens/exercise_detail_screen.dart';
import '../../features/exercise_recommendation/presentation/screens/exercises_screen.dart';
import '../../features/pain_assessment/presentation/screens/assessment_screen.dart';
import '../../features/pose_detection/presentation/screens/exercise_session_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/progress_tracking/presentation/screens/progress_screen.dart';
import '../../shared/widgets/main_shell.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    // Full screen routes (no bottom nav)
    GoRoute(
      path: '/exercise-detail/:id',
      builder: (context, state) => ExerciseDetailScreen(
        id: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/exercise-session/:id',
      builder: (context, state) => ExerciseSessionScreen(
        exerciseId: state.pathParameters['id']!,
      ),
    ),
    // Main app with bottom navigation
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/exercises',
          builder: (context, state) => const ExercisesScreen(),
        ),
        GoRoute(
          path: '/assessment',
          builder: (context, state) => const AssessmentScreen(),
        ),
        GoRoute(
          path: '/progress',
          builder: (context, state) => const ProgressScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);
