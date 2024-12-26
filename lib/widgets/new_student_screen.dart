import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/faculty.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/students_provider.dart';

class NewStudent extends ConsumerStatefulWidget {
  final int? studentIndex;

  const NewStudent({super.key, this.studentIndex});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewStudentState();
}

class _NewStudentState extends ConsumerState<NewStudent> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  Faculty? _selectedFaculty;
  Gender? _selectedGender;
  int _currentScore = 50;

  @override
  void initState() {
    super.initState();
    if (widget.studentIndex != null) {
      final student = ref.read(studentsProvider)![widget.studentIndex!];
      _nameController.text = student.name;
      _surnameController.text = student.surname;
      _selectedFaculty = student.faculty;
      _selectedGender = student.gender;
      _currentScore = student.score;
    }
  }

  void _submitStudent() async {

    if (widget.studentIndex != null) {
      await ref.read(studentsProvider.notifier).editStudent(
            widget.studentIndex!,
            _nameController.text.trim(),
            _surnameController.text.trim(),
            _selectedFaculty,
            _selectedGender,
            _currentScore,
          );
    } else {
      await ref.read(studentsProvider.notifier).addStudent(
            _nameController.text.trim(),
            _surnameController.text.trim(),
            _selectedFaculty,
            _selectedGender,
            _currentScore,
          );
    }

    if (!context.mounted) return;

    Navigator.of(context).pop(); 
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(studentsProvider.notifier);
    Widget screen = const Center(
      child: CircularProgressIndicator(),
    );
    if(!notifier.isLoading) {
      screen = Padding(
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
                        Icon(facultyIcons[faculty], color: Colors.grey[700]), 
                        const SizedBox(width: 8),
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
    return screen;
  }
}