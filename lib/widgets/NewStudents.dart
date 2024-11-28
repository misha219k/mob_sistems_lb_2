import 'package:flutter/material.dart';
import '../models/student.dart';

class NewStudent extends StatefulWidget {
  final Student? student; // Якщо null, то це додавання; якщо є - редагування
  final Function(Student) onSave; // Callback для збереження студента

  const NewStudent({Key? key, this.student, required this.onSave}) : super(key: key);

  @override
  State<NewStudent> createState() => _NewStudentState();
}

class _NewStudentState extends State<NewStudent> {
  // Контролери для текстових полів
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  Department? _selectedDepartment; // Вибраний департамент
  Gender? _selectedGender; // Вибрана стать
  int _grade = 0; // Початкова оцінка

  @override
  void initState() {
    super.initState();

    // Якщо редагуємо існуючого студента, заповнюємо поля
    if (widget.student != null) {
      _firstNameController.text = widget.student!.firstName;
      _lastNameController.text = widget.student!.lastName;
      _selectedDepartment = widget.student!.department;
      _selectedGender = widget.student!.gender;
      _grade = widget.student!.grade;
    }
  }

  void _saveStudent() {
    if (_selectedDepartment == null || _selectedGender == null) {
      // Перевірка на заповненість полів
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    // Створюємо нового студента
    final newStudent = Student(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      department: _selectedDepartment!,
      gender: _selectedGender!,
      grade: _grade,
    );

    widget.onSave(newStudent); // Викликаємо callback
    Navigator.of(context).pop(); // Закриваємо модальне вікно
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Робимо вікно компактним
        children: [
          TextField(
            controller: _firstNameController,
            decoration: const InputDecoration(labelText: 'First Name'),
          ),
          TextField(
            controller: _lastNameController,
            decoration: const InputDecoration(labelText: 'Last Name'),
          ),
          DropdownButton<Department>(
            value: _selectedDepartment,
            hint: const Text('Select Department'),
            items: Department.values.map((dept) {
              return DropdownMenuItem(
                value: dept,
                child: Text(dept.toString().split('.').last),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedDepartment = value;
              });
            },
          ),
          DropdownButton<Gender>(
            value: _selectedGender,
            hint: const Text('Select Gender'),
            items: Gender.values.map((gender) {
              return DropdownMenuItem(
                value: gender,
                child: Text(gender.toString().split('.').last),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedGender = value;
              });
            },
          ),
          Slider(
            value: _grade.toDouble(),
            min: 0,
            max: 100,
            divisions: 100,
            label: '$_grade',
            onChanged: (value) {
              setState(() {
                _grade = value.toInt();
              });
            },
          ),
          ElevatedButton(
            onPressed: _saveStudent,
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }
}
