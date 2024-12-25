import 'package:flutter/material.dart';

enum Faculty { economy, law, engineering, medicine }

final Map<Faculty, IconData> facultyIcons = {
  Faculty.economy: Icons.monetization_on,
  Faculty.law: Icons.balance,
  Faculty.engineering: Icons.construction,
  Faculty.medicine: Icons.healing,
};

final Map<Faculty, String> facultyNames = {
  Faculty.economy: 'Economy',
  Faculty.law: 'Law',
  Faculty.engineering: 'Engineering',
  Faculty.medicine: 'Medicine',
};
