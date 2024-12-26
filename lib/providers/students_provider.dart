import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/student.dart';

class StudentsState {
  final List<Student> students;
  final bool isLoading;
  StudentsState({required this.students, required this.isLoading});

  StudentsState copyWith({List<Student>? students, bool? isLoading}) {
    return StudentsState(
      students: students ?? this.students,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final studentsProvider =
    StateNotifierProvider<StudentsNotifier, List<Student>?>((ref) {
  final notifier = StudentsNotifier();
  notifier.loadStudents();
  return notifier;
});

class StudentsNotifier extends StateNotifier<List<Student>> {
  StudentsNotifier() : super([]);

  bool isLoading = false;
  Student? _removedStudent;
  int? _removedIndex;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void clearError() {
    _errorMessage = null;
  }

  Future<void> loadStudents() async {
    isLoading = true;
    state = [];
    try {
      state = await Student.remoteGetList();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  Future<void> addStudent(
    String name,
    String surname,
    faculty,
    gender,
    int score,
  ) async {
    isLoading = true;
    try {
      final student = await Student.remoteCreate(
          name, surname, faculty, gender, score);
      state = [...state, student];
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  Future<void> editStudent(
    int index,
    String name,
    String surname,
    faculty,
    gender,
    int score,
  ) async {
    isLoading = true;
    try {
      final student = await Student.remoteUpdate(
        state[index].id,
        name,
        surname,
        faculty,
        gender,
        score,
      );
      final updatedList = [...state];
      updatedList[index] = student;
      state = updatedList;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  void delStudent(int index) {
    _removedStudent = state[index];
    _removedIndex = index;
    state = [...state.sublist(0, index), ...state.sublist(index + 1)];
  }

  void undoStudent() {
    if (_removedStudent != null && _removedIndex != null) {
      final updatedList = [...state];
      updatedList.insert(_removedIndex!, _removedStudent!);
      state = updatedList;
      _removedStudent = null;
      _removedIndex = null;
    }
  }

  Future<void> removePermanent() async {
    isLoading = true;
    try {
      if(_removedStudent != null) {
          await Student.remoteDelete(_removedStudent!.id);
          _removedStudent = null;
          _removedIndex = null;
      }      
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

} 
