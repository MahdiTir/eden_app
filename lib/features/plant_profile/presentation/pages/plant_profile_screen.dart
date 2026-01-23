import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/plant_profile.dart';
import '../providers/plant_profile_provider.dart';
import 'sections/overview_section.dart';
import 'sections/care_section.dart';
import 'sections/medical_section.dart';
import 'sections/ecology_section.dart';

class PlantProfileScreen extends ConsumerStatefulWidget {
  final String plantName;
  final String? imageUrl; // Optional, can be passed from scan result

  const PlantProfileScreen({super.key, required this.plantName, this.imageUrl});

  @override
  ConsumerState<PlantProfileScreen> createState() => _PlantProfileScreenState();
}

class _PlantProfileScreenState extends ConsumerState<PlantProfileScreen> {
  int _activeTab = 0;

  final List<String> _tabs = ['Overview', 'Care', 'Medical', 'Ecology'];

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(plantProfileProvider(widget.plantName));

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF102218)
          : const Color(0xFFF6F8F7),
      body: profileAsync.when(
        data: (profile) {
          if (profile == null) {
            return const Center(
              child: Text('No details found for this plant.'),
            );
          }
          return _buildContent(profile);
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFF13EC6D)),
        ),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildContent(PlantProfile profile) {
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            _buildSliverAppBar(profile),
            SliverToBoxAdapter(child: _buildTitleAndStats(profile)),
            SliverPersistentHeader(
              pinned: true,
              delegate: _TabHeaderDelegate(
                tabs: _tabs,
                activeIndex: _activeTab,
                onTabTap: (index) {
                  setState(() {
                    _activeTab = index;
                  });
                },
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              sliver: SliverToBoxAdapter(
                child: _buildActiveTabContent(profile),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 100), // Space for bottom button
            ),
          ],
        ),
        _buildBottomCTA(),
      ],
    );
  }

  Widget _buildSliverAppBar(PlantProfile profile) {
    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 8.0),
        child: CircleAvatar(
          backgroundColor: Colors.black26,
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () => context.pop(),
          ),
        ),
      ),
      actions: [
        CircleAvatar(
          backgroundColor: Colors.black26,
          child: IconButton(
            icon: const Icon(Icons.ios_share, color: Colors.white, size: 20),
            onPressed: () {},
          ),
        ),
        const SizedBox(width: 12),
        CircleAvatar(
          backgroundColor: Colors.black26,
          child: IconButton(
            icon: const Icon(
              Icons.bookmark_border,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () {},
          ),
        ),
        const SizedBox(width: 16),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty)
              widget.imageUrl!.startsWith('http')
                  ? Image.network(widget.imageUrl!, fit: BoxFit.cover)
                  : (File(widget.imageUrl!).existsSync()
                        ? Image.file(File(widget.imageUrl!), fit: BoxFit.cover)
                        : Image.network(
                            'https://images.unsplash.com/photo-1520302630591-fd1c66ed11ef?auto=format&fit=crop&q=80',
                            fit: BoxFit.cover,
                          ))
            else
              Image.network(
                'https://images.unsplash.com/photo-1520302630591-fd1c66ed11ef?auto=format&fit=crop&q=80',
                fit: BoxFit.cover,
              ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black45,
                    Colors.transparent,
                    Colors.transparent,
                    Color(0xAA102218),
                  ],
                  stops: [0.0, 0.3, 0.7, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleAndStats(PlantProfile profile) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.plantName,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF0D1B13),
                      ),
                    ),
                    Text(
                      profile.scientificName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        color: Color(0xFF4C9A6C),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildStatCard(
                'Height',
                profile.generalInfo.averageHeightCm,
                Icons.height,
              ),
              const SizedBox(width: 12),
              _buildStatCard(
                'Lifetime',
                profile.generalInfo.cycleType,
                Icons.hourglass_bottom,
              ),
              const SizedBox(width: 12),
              _buildStatCard(
                'Growth',
                profile.generalInfo.growthRate,
                Icons.eco,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return _StatCard(label: label, value: value, icon: icon);
  }

  Widget _buildActiveTabContent(PlantProfile profile) {
    switch (_activeTab) {
      case 0:
        return OverviewSection(profile: profile);
      case 1:
        return CareSection(profile: profile);
      case 2:
        return MedicalSection(profile: profile);
      case 3:
        return EcologySection(profile: profile);
      default:
        return OverviewSection(profile: profile);
    }
  }

  Widget _buildBottomCTA() {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFF13EC6D),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF13EC6D).withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(16),
            child: const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_circle, color: Color(0xFF102218)),
                  SizedBox(width: 8),
                  Text(
                    'Add to My Garden',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF102218),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabHeaderDelegate extends SliverPersistentHeaderDelegate {
  final List<String> tabs;
  final int activeIndex;
  final Function(int) onTabTap;

  _TabHeaderDelegate({
    required this.tabs,
    required this.activeIndex,
    required this.onTabTap,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark
          ? const Color(0xFF102218).withValues(alpha: 0.95)
          : const Color(0xFFF6F8F7).withValues(alpha: 0.95),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(tabs.length, (index) {
                final isActive = activeIndex == index;
                return GestureDetector(
                  onTap: () => onTabTap(index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    child: Column(
                      children: [
                        Text(
                          tabs[index],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isActive
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: isActive
                                ? const Color(0xFF13EC6D)
                                : (isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[600]),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: 6,
                          width: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isActive
                                ? const Color(0xFF13EC6D)
                                : Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          Divider(height: 1, color: Colors.black.withValues(alpha: 0.05)),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 60;

  @override
  double get minExtent => 60;

  @override
  bool shouldRebuild(covariant _TabHeaderDelegate oldDelegate) {
    return oldDelegate.activeIndex != activeIndex;
  }
}

class _StatCard extends StatefulWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A2F24) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF13EC6D).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.icon,
                  color: const Color(0xFF13EC6D),
                  size: 20,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 10,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.value,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0D1B13),
                ),
                textAlign: TextAlign.center,
                maxLines: _isExpanded ? null : 1,
                overflow: _isExpanded
                    ? TextOverflow.visible
                    : TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
