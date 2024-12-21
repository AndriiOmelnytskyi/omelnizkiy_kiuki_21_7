import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/division.dart';
import '../providers/divisions_provider.dart';

class DivisionsScreen extends ConsumerWidget {
  const DivisionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final divisions = ref.watch(divisionsProvider);

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: divisions.length,
      itemBuilder: (context, index) {
        final division = divisions[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [Colors.blue.shade200, Colors.blue.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                divisionIcons[division.division],
                size: 40,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Text(
                divisionTitles[division.division]!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${division.totalMembers} учасників',
                style: const TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
        );
      },
    );
  }
}
