import 'package:equatable/equatable.dart';

/// Represents a plant unlocked in user's garden
class GardenPlant extends Equatable {
  final String plantId;
  final String scientificName;
  final String commonName;
  final String? family;
  final String? region;
  final String? imageUrl;
  final DateTime unlockedDate;

  const GardenPlant({
    required this.plantId,
    required this.scientificName,
    required this.commonName,
    this.family,
    this.region,
    this.imageUrl,
    required this.unlockedDate,
  });

  factory GardenPlant.fromJson(Map<String, dynamic> json) {
    // Handle joined query from garden_plants + plants
    final plant = json['plants'] as Map<String, dynamic>?;
    return GardenPlant(
      plantId: json['plant_id'].toString(),
      scientificName: plant?['scientific_name'] as String? ?? '',
      commonName: plant?['common_name'] as String? ?? '',
      family: plant?['family'] as String?,
      region: plant?['region'] as String?,
      imageUrl: plant?['occurrence_map_url'] as String?,
      unlockedDate: DateTime.parse(json['unlocked_date'] as String),
    );
  }

  @override
  List<Object?> get props => [
    plantId,
    scientificName,
    commonName,
    family,
    region,
    imageUrl,
    unlockedDate,
  ];
}

/// Represents a user's garden with XP and plants
class UserGarden extends Equatable {
  final String gardenId;
  final String userId;
  final int xpTotal;
  final List<GardenPlant> plants;

  const UserGarden({
    required this.gardenId,
    required this.userId,
    required this.xpTotal,
    required this.plants,
  });

  /// Calculate level from XP (every 500 XP = 1 level)
  int get level => (xpTotal / 500).floor() + 1;

  /// XP needed for next level
  int get xpToNextLevel => (level * 500) - xpTotal;

  /// Progress percentage to next level (0-100)
  int get progressPercent {
    final currentLevelXp = (level - 1) * 500;
    final nextLevelXp = level * 500;
    final progress =
        ((xpTotal - currentLevelXp) / (nextLevelXp - currentLevelXp)) * 100;
    return progress.toInt().clamp(0, 100);
  }

  /// Level title based on level
  String get levelTitle {
    if (level <= 1) return 'Seedling';
    if (level <= 3) return 'Sprout';
    if (level <= 5) return 'Gardener';
    if (level <= 10) return 'Botanist';
    if (level <= 20) return 'Plant Expert';
    return 'Master Botanist';
  }

  @override
  List<Object?> get props => [gardenId, userId, xpTotal, plants];
}

/// Roadmap reward item for display
class RoadmapReward extends Equatable {
  final String name;
  final String subtitle;
  final String iconName;
  final RewardStatus status;
  final int? progressPercent;
  final int requiredLevel;

  const RoadmapReward({
    required this.name,
    required this.subtitle,
    required this.iconName,
    required this.status,
    this.progressPercent,
    required this.requiredLevel,
  });

  @override
  List<Object?> get props => [
    name,
    subtitle,
    iconName,
    status,
    progressPercent,
    requiredLevel,
  ];
}

/// Status of a roadmap reward
enum RewardStatus { unlocked, current, locked }
