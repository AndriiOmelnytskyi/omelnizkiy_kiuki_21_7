import 'division.dart';

enum GenderType { male, female }

class Participant {
  final String givenName;
  final String surname;
  final Division division;
  final int score;
  final GenderType gender;

  Participant({
    required this.givenName,
    required this.surname,
    required this.division,
    required this.score,
    required this.gender,
  });
}
