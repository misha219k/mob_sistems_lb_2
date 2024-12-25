import 'faculty.dart';

enum Gender { male, female }

class Student {
  final String name;
  final String surname;
  final Faculty faculty;
  final int score;
  final Gender gender;

  Student({
    required this.name,
    required this.surname,
    required this.faculty,
    required this.score,
    required this.gender,
  });
}
