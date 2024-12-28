import 'package:flutter/material.dart';
import '../models/participant.dart';
import '../models/division.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/participants_provider.dart';

class ParticipantForm extends ConsumerStatefulWidget {
  final int? participantId;

  const ParticipantForm({
    super.key,
    this.participantId
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ParticipantFormState();
}

class _ParticipantFormState extends ConsumerState<ParticipantForm> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  late Division _selectedDivision = Division.tech;
  late GenderType _selectedGender = GenderType.male;
  late int _score = 0;

  @override
  void initState() {
    super.initState();
    if (widget.participantId != null) {
      final student = ref.read(participantsProvider).partisipants[widget.participantId!];
      _firstNameController.text = student.givenName;
      _lastNameController.text = student.surname;
      _selectedGender = student.gender;
      _selectedDivision = student.division;
      _score = student.score;
    }
  }

  void _saveParticipant() async {
    if (widget.participantId == null)  {
      await ref.read(participantsProvider.notifier).addMember(
            _firstNameController.text.trim(),
            _lastNameController.text.trim(),
            _selectedDivision,
            _selectedGender,
            _score,
          );
    } else {
      await ref.read(participantsProvider.notifier).updateMember(
            widget.participantId!,
            _firstNameController.text.trim(),
            _lastNameController.text.trim(),
            _selectedDivision,
            _selectedGender,
            _score,
          );
    }

    if (!context.mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.participantId == null ? 'New Participant' : 'Edit Participant',
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
                child: Text(widget.participantId == null ? 'Save' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
