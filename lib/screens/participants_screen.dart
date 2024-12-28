import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/participants_provider.dart';
import '../widgets/participant_card.dart';
import '../widgets/participant_form.dart';

class ParticipantsScreen extends ConsumerWidget {
  const ParticipantsScreen({super.key});

  void _openParticipantForm(
    BuildContext context,
    WidgetRef ref, {
    int? index,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Material(
        child: ParticipantForm(participantId: index,),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(participantsProvider);

    if (state.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: state.partisipants.isEmpty
          ? const Center(
              child: Text(
                'Немає учасників',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: state.partisipants.length,
              itemBuilder: (context, index) {
                final participant = state.partisipants[index];
                return ParticipantCard(
                  participant: participant,
                  onEdit: () => _openParticipantForm(
                    context,
                    ref,
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
                    ).closed.then((value) {
                      if (value != SnackBarClosedReason.action) {
                        ref.read(participantsProvider.notifier).delFromServer();
                      }
                    });
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
