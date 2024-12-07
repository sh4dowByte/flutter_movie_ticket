import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/ticket_provider.dart';
import '../widgets/app_ticket_card.dart';
import '../widgets/infinite_dragable_slider.dart';

class TicketPage extends ConsumerStatefulWidget {
  const TicketPage({super.key});

  @override
  ConsumerState<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends ConsumerState<TicketPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ticketProvider.notifier).fetchTicket();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ticketState = ref.watch(ticketProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Tickets'), actions: [
        IconButton(
          onPressed: () {
            ref.read(ticketProvider.notifier).clearTicket();
          },
          icon: const Icon(Icons.clear_all),
        ),
        IconButton(
          onPressed: () {
            ref.read(ticketProvider.notifier).fetchTicket();
          },
          icon: const Icon(Icons.replay_outlined),
        ),
      ]),
      body: Padding(
        padding: const EdgeInsets.all(20.0).copyWith(right: 50),
        child: ticketState.when(
            loading: () => const Text('Loading'),
            error: (error, stackTrace) => Center(child: Text('Error: $error')),
            data: (data) {
              if (data.isEmpty) {
                return const Center(
                  child: Text('No Ticket Found'),
                );
              }

              return Center(
                child: SizedBox(
                  height: 500,
                  child: InfiniteDragableSlider(
                    iteamCount: data.length,
                    itemBuilder: (context, index) => SizedBox(
                      child: AppTicketCard(data: data[index]),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
