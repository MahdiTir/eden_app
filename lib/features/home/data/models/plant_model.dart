import 'package:equatable/equatable.dart';

class Plant extends Equatable {
  final String id;
  final String name;
  final String species;
  final String imageUrl;
  final DateTime? dateIdentified;
  final String? category; // 'Medicinal', 'Harvest', etc.
  final String? description;

  const Plant({
    required this.id,
    required this.name,
    required this.species,
    required this.imageUrl,
    this.dateIdentified,
    this.category,
    this.description,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    species,
    imageUrl,
    dateIdentified,
    category,
    description,
  ];
}
