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
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Nerium_oleander_2.jpg/800px-Nerium_oleander_2.jpg',
        dateIdentified: DateTime.now(),
      ),
      Plant(
        id: '2',
        name: 'Olive Tree',
        species: 'Olea europaea',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/2/23/Olea_europaea_-_K%C3%B6hler%E2%80%93s_Medizinal-Pflanzen-099.jpg/640px-Olea_europaea_-_K%C3%B6hler%E2%80%93s_Medizinal-Pflanzen-099.jpg',
        dateIdentified: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Plant(
        id: '3',
        name: 'Mentha',
        species: 'Mentha spicata',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/Mentha_spicata_2006.jpg/800px-Mentha_spicata_2006.jpg',
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
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/0/03/Dattes_Deglet_Nour_Biskra.jpg/800px-Dattes_Deglet_Nour_Biskra.jpg',
        category: 'HARVEST',
        description: 'The "Queen of Dates" season is approaching in Biskra...',
      ),
      const Plant(
        id: '5',
        name: 'Barbary Fig',
        species: 'Opuntia ficus-indica',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/f/f6/Opuntia_ficus-indica.jpg',
        category: 'MEDICINAL',
        description:
            'Beyond the fruit: Discover the oil benefits and traditional...',
      ),
      const Plant(
        id: '6',
        name: 'Atlas Cedar',
        species: 'Cedrus atlantica',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Cedrus_atlantica_Man.jpg/800px-Cedrus_atlantica_Man.jpg',
        category: 'ENDANGERED',
        description:
            'Protecting the majestic giants of the Algerian mountains.',
      ),
    ];
  }
}
