import 'package:eden_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/settings_bottom_sheet.dart';
import '../../data/models/plant_model.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/home_provider.dart';
import '../../../scan/presentation/providers/scan_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final recentlyIdentifiedAsync = ref.watch(recentlyIdentifiedProvider);
    final trendingAsync = ref.watch(trendingPlantsProvider);

    final currentUser = ref.watch(currentUserProvider);
    final isOnline = ref.watch(scanModeProvider);
    final displayName =
        currentUser?.userMetadata?['full_name'] ?? l10n.defaultUsername;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (currentUser == null) {
                          context.push('/login');
                        }
                        // Maybe navigate to profile if logged in?
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 24,
                              backgroundImage: AssetImage(
                                'assets/images/user_avatar.png',
                              ),
                              backgroundColor: AppColors.accent,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.greeting,
                                    style: AppTextStyles.bodyMedium,
                                  ),
                                  Text(
                                    displayName, // Dynamic username
                                    style: AppTextStyles.h2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      // Mode Toggle
                      IconButton(
                        onPressed: () async {
                          if (!isOnline) {
                            // Switching to Online: Check connectivity
                            final connectivityResult = await Connectivity()
                                .checkConnectivity();
                            if (connectivityResult.contains(
                              ConnectivityResult.none,
                            )) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(l10n.noInternetMessage),
                                    action: SnackBarAction(
                                      label: 'Settings',
                                      onPressed: () {
                                        // Open settings if possible, or just dismiss
                                      },
                                    ),
                                  ),
                                );
                              }
                              return;
                            }
                            // If user clicked, maybe show a confirmation or just switch?
                            // User request: "a message is shown to indicate him to access internet if he want to switch to online mode"
                            // This implies sticking to offline if no internet.
                            ref.read(scanModeProvider.notifier).setMode(true);
                          } else {
                            // Switching to Offline
                            ref.read(scanModeProvider.notifier).setMode(false);
                          }
                        },
                        icon: Icon(
                          isOnline ? Icons.wifi : Icons.wifi_off,
                          size: 26,
                          color: isOnline ? AppColors.primary : Colors.grey,
                        ),
                        tooltip: isOnline ? l10n.onlineMode : l10n.offlineMode,
                      ),
                      IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => const SettingsBottomSheet(),
                          );
                        },
                        icon: const Icon(Icons.settings_outlined, size: 26),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.notifications_outlined,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: l10n.searchPlaceholder,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: Container(
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.filter_list,
                      color: AppColors.primary,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Recently Identified
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l10n.recentlyIdentified, style: AppTextStyles.h3),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      l10n.seeAll,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200, // Increased height slightly
                child: recentlyIdentifiedAsync.when(
                  data: (plants) => ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: plants.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      final plant = plants[index];
                      // Provide different time labels based on index for demo
                      final timeLabel = index == 0
                          ? l10n.today
                          : index == 1
                          ? l10n.yesterday
                          : l10n.daysAgo(2);
                      return _PlantCard(plant: plant, time: timeLabel);
                    },
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text('Error: $err')),
                ),
              ),

              const SizedBox(height: 32),

              // Did you know?
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color(0xFFA5D6A7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lightbulb,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.didYouKnow, style: AppTextStyles.h3),
                          const SizedBox(height: 8),
                          Text(
                            l10n.didYouKnowText,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Trending in Algeria Section
              Text(l10n.trendingInAlgeria, style: AppTextStyles.h3),
              const SizedBox(height: 16),
              trendingAsync.when(
                data: (plants) => ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: plants.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    return _TrendingPlantCard(plant: plants[index]);
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
              // Add some bottom padding
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      // Custom Bottom Nav
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _BottomNavItem(
              icon: Icons.home,
              label: l10n.navHome,
              isActive: true,
              color: AppColors.secondary,
            ),
            _BottomNavItem(
              icon: Icons.local_hospital_outlined,
              label: l10n.navDiseases,
            ),

            // Scan Button (Floating style) - Bigger
            GestureDetector(
              onTap: () => context.push('/scan'),
              child: Container(
                height: 72, // Bigger
                width: 72, // Bigger
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.secondary.withValues(alpha: 0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                ),
                child: const Icon(
                  Icons.qr_code_scanner,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),

            _BottomNavItem(icon: Icons.eco_outlined, label: l10n.navMyGarden),
            _BottomNavItem(icon: Icons.quiz_outlined, label: l10n.navQuiz),
          ],
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final Color? color;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    this.isActive = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final itemColor = isActive ? (color ?? AppColors.secondary) : Colors.grey;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: itemColor),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: itemColor,
            fontSize: 10,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class _PlantCard extends StatelessWidget {
  final Plant plant;
  final String time;

  const _PlantCard({required this.plant, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                image: DecorationImage(
                  image: NetworkImage(plant.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    time,
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  plant.name,
                  style: AppTextStyles.h3.copyWith(fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  plant.species,
                  style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendingPlantCard extends StatelessWidget {
  final Plant plant;

  const _TrendingPlantCard({required this.plant});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Image
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(16),
              ),
              image: DecorationImage(
                image: NetworkImage(plant.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          plant.name,
                          style: AppTextStyles.h3.copyWith(fontSize: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (plant.category != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            plant.category!,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (plant.description != null)
                    Text(
                      plant.description!,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        l10n.readGuide,
                        style: TextStyle(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 14,
                        color: AppColors.secondary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
