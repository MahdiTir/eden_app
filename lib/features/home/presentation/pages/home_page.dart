import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        // backgroundImage: AssetImage('assets/avatar.png'), // Placeholder
                        backgroundColor: AppColors.accent,
                        child: Icon(Icons.person, color: AppColors.primary),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Salam,", style: AppTextStyles.bodyMedium),
                          Text("Yacine 🌿", style: AppTextStyles.h2),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_outlined, size: 28),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: "Search for Algerian plants...",
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
                  Text("Recently Identified", style: AppTextStyles.h3),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "See All",
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 180,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    _PlantCard(
                      name: "Oleander",
                      subtitle: "Nerium oleander",
                      time: "Today",
                    ),
                    SizedBox(width: 16),
                    _PlantCard(
                      name: "Olive Tree",
                      subtitle: "Olea europaea",
                      time: "Yesterday",
                    ),
                    SizedBox(width: 16),
                    _PlantCard(
                      name: "Mint",
                      subtitle: "Mentha",
                      time: "2d ago",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Did you know?
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color(0xFFA5D6A7), // Lighter green
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lightbulb,
                        color: AppColors.primary,
                      ), // Use material icon for now
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Did you know?", style: AppTextStyles.h3),
                          const SizedBox(height: 8),
                          Text(
                            "Algeria has over 3,150 plant species. The Tell Atlas region is a biodiversity hotspot.",
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
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.home, color: AppColors.secondary),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.history, color: Colors.grey),
            ),

            // Scan Button (Floating style)
            Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                color: AppColors.secondary,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.secondary.withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.qr_code_scanner, color: Colors.white),
            ),

            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.bookmark_border, color: Colors.grey),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.person_outline, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlantCard extends StatelessWidget {
  final String name;
  final String subtitle;
  final String time;

  const _PlantCard({
    required this.name,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                image: const DecorationImage(
                  image: NetworkImage(
                    "https://via.placeholder.com/150",
                  ), // Placeholder
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
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    time,
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
                const SizedBox(height: 8),
                Text(name, style: AppTextStyles.h3.copyWith(fontSize: 16)),
                Text(
                  subtitle,
                  style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
