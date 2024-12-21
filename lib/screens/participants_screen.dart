import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/participants_provider.dart';
import '../widgets/participant_card.dart';
import '../widgets/participant_form.dart';
import '../models/participant.dart';
class ParticipantsScreen extends ConsumerWidget {
  const ParticipantsScreen({super.key});

  void _openParticipantForm(
    BuildContext context,
    WidgetRef ref, {
    Participant? participant,
    int? index,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Material(
        child: ParticipantForm(
          participant: participant,
          onSave: (updatedParticipant) {
            if (index != null) {
              ref
                  .read(participantsProvider.notifier)
                  .updateMember(index, updatedParticipant);
            } else {
              ref.read(participantsProvider.notifier).addMember(updatedParticipant);
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final participants = ref.watch(participantsProvider);

    return Scaffold(
      body: participants.isEmpty
          ? const Center(
              child: Text(
                'Немає учасників',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: participants.length,
              itemBuilder: (context, index) {
                final participant = participants[index];
                return ParticipantCard(
                  participant: participant,
                  onEdit: () => _openParticipantForm(
                    context,
                    ref,
                    participant: participant,
                    index: index,
                  ),
                  onDelete: () {
                    ref.read(participantsProvider.notifier).removeMember(index);
                    final state = ProviderScope.containerOf(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${participant.givenName} було видалено.',
                        ),
                        action: SnackBarAction(
                          label: 'Undo',
                          textColor: Colors.orange,
                          onPressed: () {
                            state
                                .read(participantsProvider.notifier)
                                .undoRemove();
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openParticipantForm(context, ref),
        label: const Text('Додати'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
