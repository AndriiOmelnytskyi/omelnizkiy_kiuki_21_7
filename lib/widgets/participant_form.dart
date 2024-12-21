import 'package:flutter/material.dart';
import '../models/participant.dart';
import '../models/division.dart';

class ParticipantForm extends StatefulWidget {
  final Function(Participant) onSave;
  final Participant? participant;

  const ParticipantForm({super.key, required this.onSave, this.participant});

  @override
  _ParticipantFormState createState() => _ParticipantFormState();
}

class _ParticipantFormState extends State<ParticipantForm> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  late Division _selectedDivision;
  late GenderType _selectedGender;
  late int _score;

  @override
  void initState() {
    super.initState();
    if (widget.participant != null) {
      _firstNameController.text = widget.participant!.givenName;
      _lastNameController.text = widget.participant!.surname;
      _selectedDivision = widget.participant!.division;
      _selectedGender = widget.participant!.gender;
      _score = widget.participant!.score;
    } else {
      _selectedDivision = Division.tech;
      _selectedGender = GenderType.male;
      _score = 0;
    }
  }

  void _saveParticipant() {
    final newParticipant = Participant(
      givenName: _firstNameController.text.trim(),
      surname: _lastNameController.text.trim(),
      division: _selectedDivision,
      score: _score,
      gender: _selectedGender,
    );
    widget.onSave(newParticipant);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.participant == null ? 'New Participant' : 'Edit Participant',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'Given Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Surname',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Division>(
                value: _selectedDivision,
                decoration: const InputDecoration(
                  labelText: 'Division',
                  border: OutlineInputBorder(),
                ),
                items: Division.values.map((division) {
                  return DropdownMenuItem(
                    value: division,
                    child: Row(
                      children: [
                        Icon(divisionIcons[division], size: 20),
                        const SizedBox(width: 10),
                        Text(divisionTitles[division]!),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (division) =>
                    setState(() => _selectedDivision = division!),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<GenderType>(
                value: _selectedGender,
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
                items: GenderType.values.map((gender) {
                  return DropdownMenuItem(
                    value: gender,
                    child: Text(gender.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (gender) =>
                    setState(() => _selectedGender = gender!),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Score',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final score = int.tryParse(value);
                  if (score != null) _score = score;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveParticipant,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: Text(widget.participant == null ? 'Save' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
