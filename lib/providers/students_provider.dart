import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/student.dart';

class StudentsNotifier extends StateNotifier<List<Student>> {
  StudentsNotifier() : super([]);

  void addStudent(Student student) => state = [...state, student];

  void editStudent(Student oldStudent, Student newStudent) {
    state = [
      for (final student in state)
        if (student == oldStudent) newStudent else student,
    ];
  }

  void deleteStudent(Student student) => state = state.where((s) => s != student).toList();

  void restoreStudent(Student student) => state = [...state, student];
}

final studentsProvider = StateNotifierProvider<StudentsNotifier, List<Student>>(
  (ref) => StudentsNotifier(),
);
