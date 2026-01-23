// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlantProfile _$PlantProfileFromJson(Map<String, dynamic> json) => PlantProfile(
  plantName: json['plant_name'] as String,
  scientificName: json['scientific_name'] as String,
  family: json['family'] as String,
  medicalUses: MedicalUses.fromJson(
    json['medical_uses'] as Map<String, dynamic>,
  ),
  plantCare: PlantCare.fromJson(json['plant_care'] as Map<String, dynamic>),
  ecologicalRole: EcologicalRole.fromJson(
    json['ecological_role'] as Map<String, dynamic>,
  ),
  generalInfo: GeneralInfo.fromJson(
    json['general_info'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$PlantProfileToJson(PlantProfile instance) =>
    <String, dynamic>{
      'plant_name': instance.plantName,
      'scientific_name': instance.scientificName,
      'family': instance.family,
      'medical_uses': instance.medicalUses,
      'plant_care': instance.plantCare,
      'ecological_role': instance.ecologicalRole,
      'general_info': instance.generalInfo,
    };

MedicalUses _$MedicalUsesFromJson(Map<String, dynamic> json) => MedicalUses(
  disclaimer: json['disclaimer'] as String,
  traditionalName: json['traditional_name'] as String,
  safetyProfile: json['safety_profile'] as String,
  knownApplications: (json['known_applications'] as List<dynamic>)
      .map((e) => MedicalApplication.fromJson(e as Map<String, dynamic>))
      .toList(),
  source: json['source'] as String,
);

Map<String, dynamic> _$MedicalUsesToJson(MedicalUses instance) =>
    <String, dynamic>{
      'disclaimer': instance.disclaimer,
      'traditional_name': instance.traditionalName,
      'safety_profile': instance.safetyProfile,
      'known_applications': instance.knownApplications,
      'source': instance.source,
    };

MedicalApplication _$MedicalApplicationFromJson(Map<String, dynamic> json) =>
    MedicalApplication(
      title: json['title'] as String,
      preparation: json['preparation'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$MedicalApplicationToJson(MedicalApplication instance) =>
    <String, dynamic>{
      'title': instance.title,
      'preparation': instance.preparation,
      'description': instance.description,
    };

PlantCare _$PlantCareFromJson(Map<String, dynamic> json) => PlantCare(
  difficulty: json['difficulty'] as String,
  watering: Watering.fromJson(json['watering'] as Map<String, dynamic>),
  light: Light.fromJson(json['light'] as Map<String, dynamic>),
  soil: json['soil'] as String,
  temperature: json['temperature'] as String,
  fertilizer: json['fertilizer'] as String,
  propagation: json['propagation'] as String,
  native_habitat: json['native_habitat'] as String,
);

Map<String, dynamic> _$PlantCareToJson(PlantCare instance) => <String, dynamic>{
  'difficulty': instance.difficulty,
  'watering': instance.watering,
  'light': instance.light,
  'soil': instance.soil,
  'temperature': instance.temperature,
  'fertilizer': instance.fertilizer,
  'propagation': instance.propagation,
  'native_habitat': instance.native_habitat,
};

Watering _$WateringFromJson(Map<String, dynamic> json) => Watering(
  frequency: json['frequency'] as String,
  details: json['details'] as String,
);

Map<String, dynamic> _$WateringToJson(Watering instance) => <String, dynamic>{
  'frequency': instance.frequency,
  'details': instance.details,
};

Light _$LightFromJson(Map<String, dynamic> json) =>
    Light(type: json['type'] as String, details: json['details'] as String);

Map<String, dynamic> _$LightToJson(Light instance) => <String, dynamic>{
  'type': instance.type,
  'details': instance.details,
};

EcologicalRole _$EcologicalRoleFromJson(Map<String, dynamic> json) =>
    EcologicalRole(
      roles: (json['roles'] as List<dynamic>)
          .map((e) => Role.fromJson(e as Map<String, dynamic>))
          .toList(),
      didYouKnow: json['did_you_know'] as String,
    );

Map<String, dynamic> _$EcologicalRoleToJson(EcologicalRole instance) =>
    <String, dynamic>{
      'roles': instance.roles,
      'did_you_know': instance.didYouKnow,
    };

Role _$RoleFromJson(Map<String, dynamic> json) => Role(
  title: json['title'] as String,
  description: json['description'] as String,
);

Map<String, dynamic> _$RoleToJson(Role instance) => <String, dynamic>{
  'title': instance.title,
  'description': instance.description,
};

GeneralInfo _$GeneralInfoFromJson(Map<String, dynamic> json) => GeneralInfo(
  growthRate: json['growth_rate'] as String,
  sunExposure: json['sun_exposure'] as String,
  waterNeeds: json['water_needs'] as String,
  averageHeightCm: json['average_height_cm'] as String,
  lifespan: json['lifespan'] as String,
  cycleType: json['cycle_type'] as String,
  hardinessZone: json['hardiness_zone'] as String,
  soilType: json['soil_type'] as String,
);

Map<String, dynamic> _$GeneralInfoToJson(GeneralInfo instance) =>
    <String, dynamic>{
      'growth_rate': instance.growthRate,
      'sun_exposure': instance.sunExposure,
      'water_needs': instance.waterNeeds,
      'average_height_cm': instance.averageHeightCm,
      'lifespan': instance.lifespan,
      'cycle_type': instance.cycleType,
      'hardiness_zone': instance.hardinessZone,
      'soil_type': instance.soilType,
    };
