import 'package:flutter/material.dart';
import '../models/student.dart';
import 'student_item.dart';

class StudentsScreen extends StatelessWidget {
  StudentsScreen({super.key});

  // Список студентів
  final List<Student> students = [
    Student(
      firstName: 'Олексiй ',
      lastName: 'Артеменко ',
      department: Department.it,
      grade: 87,
      gender: Gender.male,
    ),
    Student(
      firstName: 'Рамазан ',
      lastName: 'Будаков ',
      department: Department.finance,
      grade: 85,
      gender: Gender.male,
    ),
    Student(
      firstName: 'Гурєєва ',
      lastName: 'Вікторія ',
      department: Department.law,
      grade: 73,
      gender: Gender.female,
    ),
    Student(
      firstName: 'Михайло ',
      lastName: 'Дорошин ',
      department: Department.law,
      grade: 100,
      gender: Gender.male,
    ),
    Student(
      firstName: 'Ігор ',
      lastName: 'Змієвський',
      department: Department.law,
      grade: 90,
      gender: Gender.male,
    ),
    // Додайте більше студентів 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Логіка для додавання студента, наприклад, відкриття форми
            },
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: students.length,
        itemBuilder: (ctx, index) {
          return StudentItem(student: students[index]);
        },
        separatorBuilder: (ctx, index) => Divider(height: 1, color: Colors.grey[300]),
      ),
    );
  }
}
