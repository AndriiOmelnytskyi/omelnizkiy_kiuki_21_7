import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/participant.dart';

class ParticipantsState {
  final List<Participant> partisipants;
  final bool loading;
  final String? errorOccured;

  ParticipantsState({
    required this.partisipants,
    required this.loading,
    this.errorOccured,
  });

  ParticipantsState copyWith({
    List<Participant>? students,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ParticipantsState(
      partisipants: students ?? partisipants,
      loading: isLoading ?? loading,
      errorOccured: errorMessage ?? errorOccured,
    );
  }
}

class ParticipantsManager extends StateNotifier<ParticipantsState> {
  ParticipantsManager() : super(ParticipantsState(partisipants: [], loading: false));

  Participant? _bufferPartisipant;
  int? _bufferIndex;

  Future<void> loadStudents() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final students = await Participant.remoteGetList();
      state = state.copyWith(students: students, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> addMember(
    String givenName,
    String surname,
    division,
    gender,
    int score,
  ) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final student = await Participant.remoteCreate(
          givenName, surname, division, gender, score);
      state = state.copyWith(
        students: [...state.partisipants, student],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> updateMember(
    int index,
    String givenName,
    String surname,
    division,
    gender,
    int score,
  ) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final updatedStudent = await Participant.remoteUpdate(
        state.partisipants[index].id,
        givenName,
        surname,
        division,
        gender,
        score,
      );
      final updatedList = [...state.partisipants];
      updatedList[index] = updatedStudent;
      state = state.copyWith(students: updatedList, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  void removeMember(int index) {
    _bufferPartisipant = state.partisipants[index];
    _bufferIndex = index;
    final updatedList = [...state.partisipants];
    updatedList.removeAt(index);
    state = state.copyWith(students: updatedList);
  }

  void undoRemove() {
    if (_bufferPartisipant != null && _bufferIndex != null) {
      final updatedList = [...state.partisipants];
      updatedList.insert(_bufferIndex!, _bufferPartisipant!);
      state = state.copyWith(students: updatedList);
    }
  }

  Future<void> delFromServer() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      if (_bufferPartisipant != null) {
        await Participant.remoteDelete(_bufferPartisipant!.id);
        _bufferPartisipant = null;
        _bufferIndex = null;
      }
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }
}

final participantsProvider =
    StateNotifierProvider<ParticipantsManager, ParticipantsState>((ref) {

  final notifier = ParticipantsManager();
  notifier.loadStudents();
  return notifier;
});
