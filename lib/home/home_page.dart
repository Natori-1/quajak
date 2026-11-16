import 'package:flutter/material.dart';
import '../common/app_theme.dart';
import '../common/app_card.dart';
import 'add_task_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

@override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.brown,
        foregroundColor: Colors.white,
        onPressed: () {}
      )
    );
  }
}
