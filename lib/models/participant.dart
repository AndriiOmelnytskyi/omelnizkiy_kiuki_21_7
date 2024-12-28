import 'division.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants.dart';


enum GenderType { male, female }

class Participant {
  final String id;
  final String givenName;
  final String surname;
  final Division division;
  final int score;
  final GenderType gender;

  Participant({
    required this.id,
    required this.givenName,
    required this.surname,
    required this.division,
    required this.score,
    required this.gender,
  });

  Participant.withId(
      {required this.id,
      required this.givenName,
      required this.surname,
      required this.division,
      required this.gender,
      required this.score});

  Participant copyWith(firstName, lastName, department, gender, score) {
    return Participant.withId(
        id: id,
        givenName: firstName,
        surname: lastName,
        division: department,
        gender: gender,
        score: score);
  }

  static Division parseDivision(String divisionString) {
    return Division.values.firstWhere(
      (d) => d.toString().split('.').last == divisionString,
      orElse: () => throw ArgumentError('Invalid division: $divisionString'),
    );
  }


  static String divisionToStr(Division division) {
    return division.toString().split('.').last;
  }


  static Future<List<Participant>> remoteGetList() async {
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
    final List<Participant> loadedItems = [];
    for (final item in data.entries) {
      loadedItems.add(
        Participant(
          id: item.key,
          givenName: item.value['givenName']!,
          surname: item.value['surname']!,
          division: parseDivision(item.value['division']!),
          gender: GenderType.values.firstWhere((v) => v.toString() == item.value['gender']!),
          score: item.value['score']!,
        ),
      );
    }
    return loadedItems;
  }

  static Future<Participant> remoteCreate(
    firstName,
    lastName,
    department,
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
          'givenName': firstName!,
          'surname': lastName,
          'division': divisionToStr(department),
          'gender': gender.toString(),
          'score': score,
        },
      ),
    );

    if (response.statusCode >= 400) {
      throw Exception("Couldn't create a student");
    }

    final Map<String, dynamic> resData = json.decode(response.body);

    return Participant(
        id: resData['name'],
        givenName: firstName,
        surname: lastName,
        division: department,
        gender: gender,
        score: score);
  }

  static Future remoteDelete(studentId) async {
    final url = Uri.https(baseUrl, "$studentsPath/$studentId.json");

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      throw Exception("Couldn't delete a student");
    }
  }

  static Future<Participant> remoteUpdate(
    studentId,
    firstName,
    lastName,
    department,
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
          'givenName': firstName!,
          'surname': lastName,
          'division': divisionToStr(department),
          'gender': gender.toString(),
          'score': score,
        },
      ),
    );

    if (response.statusCode >= 400) {
      throw Exception("Couldn't update a student");
    }

    return Participant(
        id: studentId,
        givenName: firstName,
        surname: lastName,
        division: department,
        gender: gender,
        score: score);
  }

  
}
