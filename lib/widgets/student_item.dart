import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/faculty.dart';

class StudentItem extends StatelessWidget {
  final Student student;
  final VoidCallback onTap;

  const StudentItem({super.key, required this.student, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final backgroundColor = student.gender == Gender.male
        ? Colors.lightBlue.shade100
        : Colors.pink.shade100;
    final borderColor = student.gender == Gender.male
        ? Colors.blue.shade900
        : Colors.pink.shade900;

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: borderColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: borderColor.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row for name and icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${student.name} ${student.surname}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: borderColor,
                      ),
                    ),
                  ),
                  Icon(
                    facultyIcons[student.faculty],
                    size: 28,
                    color: borderColor,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Faculty and gender display
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    facultyNames[student.faculty]!,
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: borderColor.withOpacity(0.8),
                    ),
                  ),
                  Text(
                    student.gender == Gender.male ? 'Male' : 'Female',
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: borderColor.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Score display
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Grade: ${student.score}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: borderColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
