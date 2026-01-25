import '../models/plant_model.dart';

class MockHomeRepository {
  Future<List<Plant>> getRecentlyIdentified() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Plant(
        id: '1',
        name: 'Oleander',
        species: 'Nerium oleander',
        imageUrl: 'assets/images/oleander.png',
        dateIdentified: DateTime.now(),
      ),
      Plant(
        id: '2',
        name: 'Olive Tree',
        species: 'Olea europaea',
        imageUrl: 'assets/images/olive_tree.png',
        dateIdentified: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Plant(
        id: '3',
        name: 'Mentha',
        species: 'Mentha spicata',
        imageUrl: 'assets/images/mentha.png',
        dateIdentified: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }

  Future<List<Plant>> getTrendingPlants() async {
    await Future.delayed(const Duration(milliseconds: 700));
    return [
      const Plant(
        id: '4',
        name: 'Deglet Nour',
        species: 'Phoenix dactylifera',
        imageUrl: 'assets/images/deglet_nour.png',
        category: 'HARVEST',
        description: 'The "Queen of Dates" season is approaching in Biskra...',
      ),
      const Plant(
        id: '5',
        name: 'Barbary Fig',
        species: 'Opuntia ficus-indica',
        imageUrl: 'assets/images/barbary_fig.png',
        category: 'MEDICINAL',
        description:
            'Beyond the fruit: Discover the oil benefits and traditional...',
      ),
      const Plant(
        id: '6',
        name: 'Atlas Cedar',
        species: 'Cedrus atlantica',
        imageUrl: 'assets/images/atlas_cedar.png',
        category: 'ENDANGERED',
        description:
            'Protecting the majestic giants of the Algerian mountains.',
      ),
    ];
  }
}
