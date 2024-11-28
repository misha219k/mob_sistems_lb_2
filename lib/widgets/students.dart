import 'package:flutter/material.dart';
import '../models/student.dart';
import 'student_item.dart';
import 'newstudents.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
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

  Student? _recentlyDeletedStudent; // Зберігає видаленого студента для Undo
  int? _recentlyDeletedIndex; // Зберігає індекс видаленого студента

  void _addStudent() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return NewStudent(
          onSave: (newStudent) {
            setState(() {
              students.add(newStudent);
            });
          },
        );
      },
    );
  }

  void _editStudent(Student student) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return NewStudent(
          student: student,
          onSave: (updatedStudent) {
            setState(() {
              final index = students.indexOf(student);
              students[index] = updatedStudent;
            });
          },
        );
      },
    );
  }

  void _deleteStudent(int index) {
    setState(() {
      _recentlyDeletedStudent = students[index];
      _recentlyDeletedIndex = index;
      students.removeAt(index); // Видаляємо студента зі списку
    });

    // Показуємо Snackbar із можливістю скасування
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Deleted ${_recentlyDeletedStudent!.firstName} ${_recentlyDeletedStudent!.lastName}',
        ),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: _undoDelete, // Повертаємо видаленого студента
        ),
        duration: const Duration(seconds: 3), // Тривалість показу Snackbar
      ),
    );
  }

  void _undoDelete() {
    if (_recentlyDeletedStudent != null && _recentlyDeletedIndex != null) {
      setState(() {
        students.insert(_recentlyDeletedIndex!, _recentlyDeletedStudent!);
        _recentlyDeletedStudent = null;
        _recentlyDeletedIndex = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addStudent,
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: students.length,
        itemBuilder: (ctx, index) {
          return Dismissible(
            key: ValueKey(students[index]),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) {
              _deleteStudent(index); // Викликаємо метод для видалення з Undo
            },
            child: InkWell(
              onTap: () => _editStudent(students[index]), // Відкриття форми редагування
              child: StudentItem(student: students[index]),
            ),
          );
        },
  separatorBuilder: (ctx, index) =>
      Divider(height: 1, color: Colors.grey[300]),
),

    );
  }
}
