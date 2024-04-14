import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/models/goal.dart';
import 'package:flutter_boilerplate/services/database/firestore_service.dart';
import 'package:flutter_boilerplate/widgets/goal_input_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(context),
        body: _buildUI(context),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _addGoalDialog(context);
          },
          child: const Icon(Icons.add),
        ));
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: const Text('🤑 Goals'),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            GoRouter.of(context).push('/profile');
          },
        ),
      ],
    );
  }

  Widget _buildUI(BuildContext context) {
    return StreamBuilder<List<Goal>>(
        stream: _firestoreService.streamGoals(),
        builder: (context, snapshot) {
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Builder(
              builder: (context) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error encountered while reading data.'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No goals yet!'),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Goal goal = snapshot.data![index];
                    return _goalCard(context, goal);
                  },
                );
              }
            ),
          );
        });
  }

  Widget _goalCard(BuildContext context, Goal goal) {
    return Card(
      child: ListTile(
        title: Text(goal.name),
        subtitle: Text('₱${goal.savingsPerFrequency.toStringAsFixed(2)} / ${goal.frequency.formatName()}\n${DateFormat('MMMM d, y').format(goal.targetDate)}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            _firestoreService.deleteGoal(goal);
          },
        ),
        onTap: () => GoRouter.of(context).push('/goal/${goal.id}'),
      ),
    );
  }

  void _addGoalDialog(BuildContext context) {
    goalInputDialog(
      submitButtonLabel: 'Add',
      context: context,
      formKey: _formKey,
      onSubmit: (name, saved, price, category, frequency, targetDate) {
        Goal goal = Goal(
          name: name!,
          saved: saved!,
          price: price!,
          category: category!,
          frequency: frequency!,
          targetDate: targetDate!,
        );

        _firestoreService.addGoal(goal);
      },
    );
  }
}
