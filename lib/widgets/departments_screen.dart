import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/faculty.dart'; 
import '../providers/students_provider.dart';

class DepartmentsScreen extends ConsumerWidget {
  const DepartmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final students = ref.watch(studentsProvider);

    final facultyCounts = {
      for (var faculty in Faculty.values)
        faculty: students == null 
          ? 0 
          : students.where((s) => s.faculty == faculty).length,
    };

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: Faculty.values.length,
      itemBuilder: (context, index) {
        final faculty = Faculty.values[index];
        return Card(
          color: Colors.blue.shade100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(facultyIcons[faculty], size: 48, color: Colors.blue.shade900),
              Text(
                facultyNames[faculty]!,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text('${facultyCounts[faculty]} students'),
            ],
          ),
        );
      },
    );
  }
}
