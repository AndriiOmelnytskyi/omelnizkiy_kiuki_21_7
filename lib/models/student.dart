import 'package:flutter/material.dart';

enum Department { finance, law, it, medical }
enum Gender { male, female }

class Student {
  final String firstName;
  final String lastName;
  final Department department;
  final int grade;
  final Gender gender;

  Student({
    required this.firstName,
    required this.lastName,
    required this.department,
    required this.grade,
    required this.gender,
  });
}

const departmentIcons = {
  Department.finance: Icons.account_balance_wallet_outlined,
  Department.law: Icons.balance_outlined,
  Department.it: Icons.memory_outlined, 
  Department.medical: Icons.health_and_safety_outlined, 
};
