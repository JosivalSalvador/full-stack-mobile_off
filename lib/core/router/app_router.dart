import 'package:go_router/go_router.dart';
import 'package:keymory_off/features/unlock/presentation/screens/unlock_screen.dart';

/// The app's single source of truth for navigation.
///
/// Currently exposes only the unlock flow; additional routes are added
/// here as new features are introduced.
final GoRouter appRouter = GoRouter(
  initialLocation: '/unlock',
  routes: [
    GoRoute(
      path: '/unlock',
      builder: (context, state) => const UnlockScreen(),
    ),
  ],
);
