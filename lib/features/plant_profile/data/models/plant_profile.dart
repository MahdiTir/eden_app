// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'plant_profile.g.dart';

@JsonSerializable()
class PlantProfile {
  @JsonKey(name: 'plant_name')
  final String plantName;
  @JsonKey(name: 'scientific_name')
  final String scientificName;
  final String family;
  @JsonKey(name: 'medical_uses')
  final MedicalUses medicalUses;
  @JsonKey(name: 'plant_care')
  final PlantCare plantCare;
  @JsonKey(name: 'ecological_role')
  final EcologicalRole ecologicalRole;
  @JsonKey(name: 'general_info')
  final GeneralInfo generalInfo;

  PlantProfile({
    required this.plantName,
    required this.scientificName,
    required this.family,
    required this.medicalUses,
    required this.plantCare,
    required this.ecologicalRole,
    required this.generalInfo,
  });

  factory PlantProfile.fromJson(Map<String, dynamic> json) =>
      _$PlantProfileFromJson(json);
  Map<String, dynamic> toJson() => _$PlantProfileToJson(this);
}

@JsonSerializable()
class MedicalUses {
  final String disclaimer;
  @JsonKey(name: 'traditional_name')
  final String traditionalName;
  @JsonKey(name: 'safety_profile')
  final String safetyProfile;
  @JsonKey(name: 'known_applications')
  final List<MedicalApplication> knownApplications;
  final String source;

  MedicalUses({
    required this.disclaimer,
    required this.traditionalName,
    required this.safetyProfile,
    required this.knownApplications,
    required this.source,
  });

  factory MedicalUses.fromJson(Map<String, dynamic> json) =>
      _$MedicalUsesFromJson(json);
  Map<String, dynamic> toJson() => _$MedicalUsesToJson(this);
}

@JsonSerializable()
class MedicalApplication {
  final String title;
  final String preparation;
  final String description;

  MedicalApplication({
    required this.title,
    required this.preparation,
    required this.description,
  });

  factory MedicalApplication.fromJson(Map<String, dynamic> json) =>
      _$MedicalApplicationFromJson(json);
  Map<String, dynamic> toJson() => _$MedicalApplicationToJson(this);
}

@JsonSerializable()
class PlantCare {
  final String difficulty;
  final Watering watering;
  final Light light;
  final String soil;
  final String temperature;
  final String fertilizer;
  final String propagation;
  @JsonKey(name: 'native_habitat')
  final String native_habitat;

  PlantCare({
    required this.difficulty,
    required this.watering,
    required this.light,
    required this.soil,
    required this.temperature,
    required this.fertilizer,
    required this.propagation,
    required this.native_habitat,
  });

  factory PlantCare.fromJson(Map<String, dynamic> json) =>
      _$PlantCareFromJson(json);
  Map<String, dynamic> toJson() => _$PlantCareToJson(this);
}

@JsonSerializable()
class Watering {
  final String frequency;
  final String details;

  Watering({required this.frequency, required this.details});

  factory Watering.fromJson(Map<String, dynamic> json) =>
      _$WateringFromJson(json);
  Map<String, dynamic> toJson() => _$WateringToJson(this);
}

@JsonSerializable()
class Light {
  final String type;
  final String details;

  Light({required this.type, required this.details});

  factory Light.fromJson(Map<String, dynamic> json) => _$LightFromJson(json);
  Map<String, dynamic> toJson() => _$LightToJson(this);
}

@JsonSerializable()
class EcologicalRole {
  final List<Role> roles;
  @JsonKey(name: 'did_you_know')
  final String didYouKnow;

  EcologicalRole({required this.roles, required this.didYouKnow});

  factory EcologicalRole.fromJson(Map<String, dynamic> json) =>
      _$EcologicalRoleFromJson(json);
  Map<String, dynamic> toJson() => _$EcologicalRoleToJson(this);
}

@JsonSerializable()
class Role {
  final String title;
  final String description;

  Role({required this.title, required this.description});

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);
  Map<String, dynamic> toJson() => _$RoleToJson(this);
}

@JsonSerializable()
class GeneralInfo {
  @JsonKey(name: 'growth_rate')
  final String growthRate;
  @JsonKey(name: 'sun_exposure')
  final String sunExposure;
  @JsonKey(name: 'water_needs')
  final String waterNeeds;
  @JsonKey(name: 'average_height_cm')
  final String averageHeightCm;
  final String lifespan;
  @JsonKey(name: 'cycle_type')
  final String cycleType;
  @JsonKey(name: 'hardiness_zone')
  final String hardinessZone;
  @JsonKey(name: 'soil_type')
  final String soilType;

  GeneralInfo({
    required this.growthRate,
    required this.sunExposure,
    required this.waterNeeds,
    required this.averageHeightCm,
    required this.lifespan,
    required this.cycleType,
    required this.hardinessZone,
    required this.soilType,
  });

  factory GeneralInfo.fromJson(Map<String, dynamic> json) =>
      _$GeneralInfoFromJson(json);
  Map<String, dynamic> toJson() => _$GeneralInfoToJson(this);
}
