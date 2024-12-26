import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/students_provider.dart';
import '../models/student.dart';
import 'new_student_screen.dart';
import 'student_item.dart';
import '../constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StudentsScreen extends ConsumerWidget {
  const StudentsScreen({super.key});

  void _showNewStudentForm(BuildContext context, WidgetRef ref, {int? index}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => NewStudent(
        studentIndex: index
      ),
    );
  }

  void _deleteStudent(BuildContext context, WidgetRef ref, int studentIndex) {
    final notifier = ref.read(studentsProvider.notifier);
    notifier.delStudent(studentIndex);
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text("Student removed."),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            notifier.undoStudent();
          },
        ),
      ),
    ).closed.then((value) {
      if (value != SnackBarClosedReason.action) {
        ref.read(studentsProvider.notifier)
            .removePermanent();
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final students = ref.watch(studentsProvider);
    final notifier = ref.watch(studentsProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (notifier.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              notifier.errorMessage!,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
        notifier.clearError();
      }
    });

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
      body: () {
        if (notifier.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (students == null || students.isEmpty) {
          return const Center(
            child: Text("No students yet."),
          );
        } else {
          return ListView.builder(
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
                  onDismissed: (_) => _deleteStudent(context, ref, index),
                  child: StudentItem(
                    student: student,
                    onTap: () => _showNewStudentForm(context, ref, index: index),
                  ),
                );
              },
            );
        }
      }(),
    );
  }
}
