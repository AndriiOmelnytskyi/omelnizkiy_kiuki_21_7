import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/participant.dart';
import '../models/division.dart';

class ParticipantsManager extends StateNotifier<List<Participant>> {
  ParticipantsManager() : super([]);

  Participant? _lastRemovedParticipant;
  int? _lastRemovedIndex;

  void addMember(Participant participant) {
    state = [...state, participant];
  }

  void updateMember(int index, Participant updatedParticipant) {
    final updatedList = [...state];
    updatedList[index] = updatedParticipant;
    state = updatedList;
  }

  void removeMember(int index) {
    _lastRemovedParticipant = state[index];
    _lastRemovedIndex = index;

    state = [...state.sublist(0, index), ...state.sublist(index + 1)];
  }

  void undoRemove() {
    if (_lastRemovedParticipant != null && _lastRemovedIndex != null) {
      state = [
        ...state.sublist(0, _lastRemovedIndex!),
        _lastRemovedParticipant!,
        ...state.sublist(_lastRemovedIndex!)
      ];
      _lastRemovedParticipant = null;
      _lastRemovedIndex = null;
    }
  }

  int getDivisionCount(Division division) {
    return state.where((member) => member.division == division).length;
  }
}

final participantsProvider =
    StateNotifierProvider<ParticipantsManager, List<Participant>>((ref) {
  return ParticipantsManager();
});
