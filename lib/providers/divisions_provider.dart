import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/division.dart';
import 'participants_provider.dart';

class DivisionData {
  final Division division;
  final int totalMembers;

  DivisionData({required this.division, required this.totalMembers});
}

class DivisionsNotifier extends StateNotifier<List<DivisionData>> {
  DivisionsNotifier(this.participantsNotifier) : super([]) {
    _updateDivisionCounts();
    participantsNotifier.addListener((_) => _updateDivisionCounts());
  }

  final ParticipantsManager participantsNotifier;

  void _updateDivisionCounts() {
    final participants = participantsNotifier.state;

    final counts = Division.values.map((division) {
      final totalMembers = participants
          .where((participant) => participant.division == division)
          .length;
      return DivisionData(division: division, totalMembers: totalMembers);
    }).toList();

    state = counts;
  }
}

final divisionsProvider = StateNotifierProvider<DivisionsNotifier, List<DivisionData>>(
  (ref) => DivisionsNotifier(ref.read(participantsProvider.notifier)),
);
