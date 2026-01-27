import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_herodex_3000/blocs/roster/roster_bloc.dart';
import 'package:flutter_herodex_3000/blocs/roster/roster_event.dart';
import 'package:flutter_herodex_3000/blocs/roster/roster_state.dart';
import 'package:flutter_herodex_3000/widgets/hero_card_widget.dart';

class RosterScreen extends StatelessWidget {
  const RosterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RosterBloc()..add(GetRoster()),
      child: const RosterView(),
    );
  }
}

class RosterView extends StatelessWidget {
  const RosterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: BlocBuilder<RosterBloc, RosterState>(
                  builder: (context, state) {
                    if (state is RosterLoading && state.heroes.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is RosterError && state.heroes.isEmpty) {
                      return Center(
                        child: Text(
                          state.message,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      );
                    }

                    if (state.heroes.isEmpty) {
                      return const Center(
                        child: Text(
                          'No heroes in your roster yet.\nSearch and add some heroes!',
                        ),
                      );
                    }
                    final rosterList = state.heroes.toList();
                    return ListView.builder(
                      itemCount: rosterList.length,
                      itemBuilder: (context, index) {
                        final hero = rosterList[index];
                        return HeroCard(hero: hero, showIcon: false);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
