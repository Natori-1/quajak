
import 'package:flutter/material.dart';
import '../common/app_theme.dart';
import '../common/app_card.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(22),
      children: [
        const Text(
          '설정',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 25),

        AppCard(
          child: const Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.cream,
                child: Icon(
                  Icons.person,
                  size: 35,
                  color: AppColors.brown,
                ),
              ),
              SizedBox(width: 15),
              Expanded(child: SizedBox(height: 55)),
            ],
          ),
        ),

        const SizedBox(height: 20),

        AppCard(
          child: Column(
            children: const [
              SettingItem(icon: Icons.notifications_none),
              SettingItem(icon: Icons.palette_outlined),
              SettingItem(icon: Icons.card_giftcard),
              SettingItem(icon: Icons.campaign_outlined),
              SettingItem(icon: Icons.info_outline),
            ],
          ),
        ),
      ],
    );
  }
}

class SettingItem extends StatelessWidget {
  final IconData icon;

  const SettingItem({
    super.key,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: Row(
        children: [
          Icon(icon, color: AppColors.brown),
          const SizedBox(width: 15),
          const Expanded(child: SizedBox()),
          const Icon(
            Icons.chevron_right,
            color: AppColors.gray,
          ),
        ],
      ),
    );
  }
}
