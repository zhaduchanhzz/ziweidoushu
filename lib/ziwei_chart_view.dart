import 'package:flutter/material.dart';

class ZiWeiChartView extends StatelessWidget {
  final List<dynamic> palaces;

  const ZiWeiChartView({super.key, required this.palaces});

  @override
  Widget build(BuildContext context) {
    if (palaces.isEmpty) {
      return const Center(child: Text("Không có dữ liệu lá số"));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Lá số Tử Vi (4x4)",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: palaces.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // 4x4
            mainAxisExtent: 160,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            final p = palaces[index];
            final title = p["name"] ?? '';
            final majorStars = (p["majorStars"] as List<dynamic>?) ?? [];
            final minorStars = (p["minorStars"] as List<dynamic>?) ?? [];
            final adjStars = (p["adjectiveStars"] as List<dynamic>?) ?? [];

            final starsText = [
              if (majorStars.isNotEmpty) "★ ${majorStars.join(", ")}",
              if (minorStars.isNotEmpty) "☆ ${minorStars.join(", ")}",
              if (adjStars.isNotEmpty) "◇ ${adjStars.join(", ")}",
            ].join("\n");

            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Các sao:",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 2),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          starsText,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
