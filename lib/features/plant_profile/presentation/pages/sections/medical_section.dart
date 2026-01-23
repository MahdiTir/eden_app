import 'package:flutter/material.dart';
import '../../../data/models/plant_profile.dart';
import '../../widgets/expandable_text.dart';

class MedicalSection extends StatelessWidget {
  final PlantProfile profile;

  const MedicalSection({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text(
                'Medical Uses',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(
              Icons.medication_liquid,
              color: Color(0xFF13EC6D),
              size: 24,
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Disclaimer Banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info, color: Colors.orange, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: ExpandableText(
                  text: profile.medicalUses.disclaimer,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.orange[200] : Colors.orange[800],
                    height: 1.4,
                  ),
                  color: Colors.orange,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Plant Info Summary in Medical Context
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF13EC6D).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.eco, color: Color(0xFF13EC6D), size: 14),
                        SizedBox(width: 4),
                        Text(
                          'Medicinal Herb',
                          style: TextStyle(
                            color: Color(0xFF13EC6D),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    profile.scientificName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    profile.medicalUses.traditionalName,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Safety Profile
        _buildInfoCard(
          isDark,
          Icons.shield,
          'SAFETY PROFILE',
          profile.medicalUses.safetyProfile,
          Colors.blue,
        ),
        const SizedBox(height: 24),
        const Text(
          'Known Applications',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Container(height: 2, width: 175, color: const Color(0xFF13EC6D)),
        const SizedBox(height: 16),
        ...profile.medicalUses.knownApplications.map(
          (app) => _buildApplicationItem(isDark, app),
        ),
        const SizedBox(height: 24),
        Center(
          child: Column(
            children: [
              Text(
                'Source: ${profile.medicalUses.source}',
                style: TextStyle(
                  fontSize: 10,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'E D E N',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                  color: Color(0xFF13EC6D),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    bool isDark,
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A2F24) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[500],
                  ),
                ),
                ExpandableText(
                  text: value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  color: color,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationItem(bool isDark, MedicalApplication app) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A2F24) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFE7F3EC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.local_drink,
              color: Color(0xFF0EA64D),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  app.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Preparation: ${app.preparation}'.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4C9A6C),
                  ),
                ),
                const SizedBox(height: 8),
                ExpandableText(
                  text: app.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.grey[300] : Colors.grey[700],
                    height: 1.5,
                  ),
                  color: const Color(0xFF13EC6D),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
