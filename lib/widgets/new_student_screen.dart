import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/faculty.dart';

class NewStudent extends StatefulWidget {
  final Student? student;
  final Function(Student) onSave;

  const NewStudent({super.key, this.student, required this.onSave});

  @override
  State<NewStudent> createState() => _NewStudentState();
}

class _NewStudentState extends State<NewStudent> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  Faculty? _selectedFaculty;
  Gender? _selectedGender;
  int _currentScore = 50;

  @override
  void initState() {
    super.initState();
    if (widget.student != null) {
      _nameController.text = widget.student!.name;
      _surnameController.text = widget.student!.surname;
      _selectedFaculty = widget.student!.faculty;
      _selectedGender = widget.student!.gender;
      _currentScore = widget.student!.score;
    }
  }

  void _submitStudent() {
    if (_nameController.text.isEmpty ||
        _surnameController.text.isEmpty ||
        _selectedFaculty == null ||
        _selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields.')),
      );
      return;
    }

    final newStudent = Student(
      name: _nameController.text.trim(),
      surname: _surnameController.text.trim(),
      faculty: _selectedFaculty!,
      gender: _selectedGender!,
      score: _currentScore,
    );

    widget.onSave(newStudent);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _surnameController,
                decoration: const InputDecoration(labelText: 'Surname'),
              ),
              const SizedBox(height: 8),
              DropdownButton<Faculty>(
                value: _selectedFaculty,
                hint: const Text('Select Faculty'),
                items: Faculty.values.map((faculty) {
                  return DropdownMenuItem(
                    value: faculty,
                    child: Row(
                      children: [
                        Icon(facultyIcons[faculty], color: Colors.grey[700]), // Иконка факультета
                        const SizedBox(width: 8), // Отступ между иконкой и текстом
                        Text(
                          facultyNames[faculty]!,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedFaculty = value),
              ),
              const SizedBox(height: 8),
              DropdownButton<Gender>(
                value: _selectedGender,
                hint: const Text('Select Gender'),
                items: Gender.values.map((gender) {
                  return DropdownMenuItem(
                    value: gender,
                    child: Text(gender.name.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedGender = value),
              ),
              const SizedBox(height: 16),
              Slider(
                value: _currentScore.toDouble(),
                min: 0,
                max: 100,
                divisions: 100,
                label: '$_currentScore',
                onChanged: (value) => setState(() => _currentScore = value.toInt()),
              ),
              ElevatedButton(
                onPressed: _submitStudent,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
