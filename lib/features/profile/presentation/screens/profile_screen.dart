import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar
            CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: Text(
                (user?.name ?? 'U').substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              user?.name ?? 'User',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              user?.email ?? '',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),

            // Info cards
            _InfoTile(
              icon: Icons.person_outline,
              title: 'Full Name',
              value: user?.name ?? '-',
            ),
            _InfoTile(
              icon: Icons.email_outlined,
              title: 'Email',
              value: user?.email ?? '-',
            ),
            _InfoTile(
              icon: Icons.cake_outlined,
              title: 'Age',
              value: '${user?.age ?? "-"} years',
            ),
            _InfoTile(
              icon: Icons.wc_outlined,
              title: 'Gender',
              value: user?.gender ?? '-',
            ),
            _InfoTile(
              icon: Icons.directions_run_outlined,
              title: 'Activity Level',
              value: user?.activityLevel ?? 'Moderate',
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),

            // Settings options
            _SettingsTile(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.dark_mode_outlined,
              title: 'Dark Mode',
              trailing: Switch(
                value: false,
                onChanged: (val) {},
                activeThumbColor: AppColors.primary,
              ),
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.record_voice_over_outlined,
              title: 'Voice Feedback',
              trailing: Switch(
                value: true,
                onChanged: (val) {},
                activeThumbColor: AppColors.primary,
              ),
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.info_outline,
              title: 'About Smart Physio',
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'Smart Physio',
                  applicationVersion: '1.0.0',
                  applicationLegalese:
                      'AI-Based Muscle Pain Relief & Exercise Recommendation System',
                );
              },
            ),
            const SizedBox(height: 16),

            // Logout
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  await ref.read(authProvider.notifier).logout();
                  if (context.mounted) context.go('/login');
                },
                icon: const Icon(Icons.logout, color: AppColors.error),
                label: const Text(
                  'Logout',
                  style: TextStyle(color: AppColors.error),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.error),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textHint,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Widget? trailing;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondary),
      title: Text(title),
      trailing: trailing ?? const Icon(Icons.chevron_right, color: AppColors.textHint),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}
