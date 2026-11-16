
import 'package:flutter/material.dart';
import '../common/app_theme.dart';
import '../common/app_card.dart';

class CookiePage extends StatelessWidget {
  const CookiePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(22),
      children: [
        const Text(
          '쿠키함',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 25),

        AppCard(
          color: AppColors.cream,
          child: const Row(
            children: [
              Text('🥠', style: TextStyle(fontSize: 55)),
              SizedBox(width: 20),
              Expanded(child: SizedBox(height: 65)),
            ],
          ),
        ),

        const SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: ['전체', '행운', '위로', '도전']
              .map((e) => Chip(label: Text(e)))
              .toList(),
        ),

        const SizedBox(height: 20),

        AppCard(
          child: Column(
            children: List.generate(
              5,
              (index) => const SizedBox(
                height: 65,
                child: Row(
                  children: [
                    Text('🥠', style: TextStyle(fontSize: 30)),
                    SizedBox(width: 15),
                    Expanded(child: SizedBox()),
                    Icon(Icons.star, color: Colors.amber),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
