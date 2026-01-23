import 'package:flutter/material.dart';
import '../../../data/models/plant_profile.dart';
import '../../widgets/expandable_text.dart';

class CareSection extends StatelessWidget {
  final PlantProfile profile;

  const CareSection({super.key, required this.profile});

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
                'Care Guide',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF13EC6D).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF13EC6D).withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.speed, color: Color(0xFF13EC6D), size: 16),
                  const SizedBox(width: 4),
                  Text(
                    profile.plantCare.difficulty.toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFF13EC6D),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _QuickStat(
                    icon: Icons.water_drop,
                    label: 'Water',
                    value: profile.plantCare.watering.frequency,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickStat(
                    icon: Icons.wb_sunny,
                    label: 'Light',
                    value: profile.plantCare.light.type,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _QuickStat(
                    icon: Icons.terrain,
                    label: 'Soil',
                    value: profile.plantCare.soil,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickStat(
                    icon: Icons.thermostat,
                    label: 'Temp',
                    value: profile.plantCare.temperature,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildCareCard(
          isDark,
          Icons.water_drop,
          'Watering Advice',
          'Frequency: ${profile.plantCare.watering.frequency}',
          profile.plantCare.watering.details,
          Colors.blue,
        ),
        const SizedBox(height: 12),
        _buildCareCard(
          isDark,
          Icons.wb_sunny,
          'Sunlight Needs',
          'Type: ${profile.plantCare.light.type}',
          profile.plantCare.light.details,
          Colors.orange,
        ),
        const SizedBox(height: 12),
        _buildCareCard(
          isDark,
          Icons.compost,
          'Soil & Fertilizer',
          'Type: ${profile.plantCare.soil}',
          profile.plantCare.fertilizer,
          Colors.amber,
        ),
        const SizedBox(height: 12),
        _buildCareCard(
          isDark,
          Icons.spa,
          'Propagation',
          'Method: ${profile.plantCare.propagation.split(':').first}',
          profile.plantCare.propagation,
          Colors.green,
        ),
      ],
    );
  }

  Widget _buildCareCard(
    bool isDark,
    IconData icon,
    String title,
    String subtitle,
    String content,
    Color color,
  ) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 44),
            child: ExpandableText(
              text: content,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.grey[300] : Colors.grey[700],
                height: 1.5,
              ),
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickStat extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _QuickStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  State<_QuickStat> createState() => _QuickStatState();
}

class _QuickStatState extends State<_QuickStat> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
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
            Icon(widget.icon, color: widget.color, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.label.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.value,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: _isExpanded ? null : 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
