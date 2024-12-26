import 'faculty.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants.dart';

enum Gender { male, female }

class Student {
  final String id;
  final String name;
  final String surname;
  final Faculty faculty;
  final int score;
  final Gender gender;

  Student({
    required this.id,
    required this.name,
    required this.surname,
    required this.faculty,
    required this.score,
    required this.gender,
  });

  Student.withId(
      {required this.id,
      required this.name,
      required this.surname,
      required this.faculty,
      required this.score,
      required this.gender});

  Student copyWith(name, surname, faculty, gender, score) {
    return Student.withId(
        id: id,
        name: name,
        surname: surname,
        faculty: faculty,
        score: score,
        gender: gender);
  }

  static Future<List<Student>> remoteGetList() async {
    final url = Uri.https(baseUrl, "$studentsPath.json");

    final response = await http.get(
      url,
    );

    if (response.statusCode >= 400) {
      throw Exception("Failed to retrieve the data");
    }

    if (response.body == "null") {
      return [];
    }

    final Map<String, dynamic> data = json.decode(response.body);
    final List<Student> loadedItems = [];
    for (final item in data.entries) {
      loadedItems.add(
        Student(
          id: item.key,
          name: item.value['i_name']!,
          surname: item.value['surname']!,
          faculty: parseFaculty(item.value['faculty']!),
          score: item.value['score']!,
          gender: Gender.values.firstWhere((v) => v.toString() == item.value['gender']!),      
        ),
      );
    }
    return loadedItems;
  }

  static Future<Student> remoteCreate(
    name,
    surname,
    faculty,
    gender,
    score,
  ) async {

    final url = Uri.https(baseUrl, "$studentsPath.json");

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(
        {
          'i_name': name!,
          'surname': surname,
          'faculty': facultyToString(faculty),
          'score': score,
          'gender': gender.toString(),        
        },
      ),
    );

    if (response.statusCode >= 400) {
      throw Exception("Couldn't create a student");
    }

    final Map<String, dynamic> resData = json.decode(response.body);

    return Student(
        id: resData['name'],
        name: name,
        surname: surname,
        faculty: faculty,
        score: score,
        gender: gender);
  }

  static Future remoteDelete(studentId) async {
    final url = Uri.https(baseUrl, "$studentsPath/$studentId.json");

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      throw Exception("Couldn't delete a student");
    }
  }

  static Future<Student> remoteUpdate(
    studentId,
    name,
    surname,
    faculty,
    gender,
    score,
  ) async {
    final url = Uri.https(baseUrl, "$studentsPath/$studentId.json");

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(
        {
          'i_name': name,
          'surname': surname,
          'faculty': facultyToString(faculty),
          'score': score,
          'gender': gender.toString()
        },
      ),
    );

    if (response.statusCode >= 400) {
      throw Exception("Couldn't update a student");
    }

    return Student(
        id: studentId,
        name: name,
        surname: surname,
        faculty: faculty,
        score: score,
        gender: gender);
  }

  static Faculty parseFaculty(String facultyString) {
    return Faculty.values.firstWhere(
      (d) => d.toString().split('.').last == facultyString,
      orElse: () => throw ArgumentError('Invalid department: $facultyString'),
    );
  }

  static String facultyToString(Faculty faculty) {
    return faculty.toString().split('.').last;
  }

}
