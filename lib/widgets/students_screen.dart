import 'package:flutter/material.dart';
import '../models/student.dart';
import 'student_item.dart';

class StudentsScreen extends StatelessWidget {
  StudentsScreen({Key? key}) : super(key: key);

  final List<Student> students = [
    Student(
      firstName: 'Оксана',
      lastName: 'Литвин',
      department: Department.finance,
      grade: 91,
      gender: Gender.female,
    ),
    Student(
      firstName: 'Ігор',
      lastName: 'Шевченко',
      department: Department.law,
      grade: 87,
      gender: Gender.male,
    ),
    Student(
      firstName: 'Олена',
      lastName: 'Ткаченко',
      department: Department.medical,
      grade: 95,
      gender: Gender.female,
    ),
    Student(
      firstName: 'Олексій',
      lastName: 'Богданов',
      department: Department.it,
      grade: 89,
      gender: Gender.male,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Студенти',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: students.length,
          itemBuilder: (context, index) {
            return StudentItem(student: students[index]);
          },
        ),
      ),
    );
  }
}
