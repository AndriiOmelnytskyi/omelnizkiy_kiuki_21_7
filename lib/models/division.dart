import 'package:flutter/material.dart';

enum Division { finance, legal, tech, healthcare }

const divisionIcons = {
  Division.finance: Icons.bar_chart,
  Division.legal: Icons.account_balance,
  Division.tech: Icons.router,
  Division.healthcare: Icons.healing,
};


const divisionTitles = {
  Division.finance: 'Фінансовий',
  Division.legal: 'Юридичний',
  Division.tech: 'Технологічний',
  Division.healthcare: 'Медичний',
};

class DivisionData {
  final Division division;
  final int totalMembers;

  DivisionData({
    required this.division,
    required this.totalMembers,
  });
}
