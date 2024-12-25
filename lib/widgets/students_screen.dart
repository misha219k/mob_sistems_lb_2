import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/students_provider.dart';
import '../models/student.dart';
import 'new_student_screen.dart';
import 'student_item.dart';

class StudentsScreen extends ConsumerWidget {
  const StudentsScreen({super.key});

  void _showNewStudentForm(BuildContext context, WidgetRef ref, {Student? existingStudent}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => NewStudent(
        student: existingStudent,
        onSave: (newStudent) {
          final notifier = ref.read(studentsProvider.notifier);
          if (existingStudent != null) {
            notifier.editStudent(existingStudent, newStudent);
          } else {
            notifier.addStudent(newStudent);
          }
        },
      ),
    );
  }

  void _deleteStudent(BuildContext context, WidgetRef ref, Student student) {
    final notifier = ref.read(studentsProvider.notifier);
    notifier.deleteStudent(student);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${student.name} ${student.surname} has been deleted.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => notifier.restoreStudent(student),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final students = ref.watch(studentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showNewStudentForm(context, ref),
          ),
        ],
      ),
      body: students.isEmpty
          ? const Center(child: Text('No students yet.'))
          : ListView.builder(
              itemCount: students.length,
              itemBuilder: (ctx, index) {
                final student = students[index];
                return Dismissible(
                  key: ValueKey(student),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red.shade300,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => _deleteStudent(context, ref, student),
                  child: StudentItem(
                    student: student,
                    onTap: () => _showNewStudentForm(context, ref, existingStudent: student),
                  ),
                );
              },
            ),
    );
  }
}
