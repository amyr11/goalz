import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/models/goal.dart';
import 'package:flutter_boilerplate/services/database/firestore_service.dart';
import 'package:flutter_boilerplate/styles.dart';
import 'package:flutter_boilerplate/widgets/goal_input_dialog.dart';
import 'package:flutter_boilerplate/widgets/save_input_dialog.dart';
import 'package:intl/intl.dart';

class GoalDetailsScreen extends StatelessWidget {
  final String id;
  final FirestoreService _firestoreService = FirestoreService();
  final GlobalKey<FormState> _editFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _savingsFormKey = GlobalKey<FormState>();

  GoalDetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: _buildUI(context),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: const Text('Goal'),
    );
  }

  Widget _buildUI(BuildContext context) {
    return Center(
      child: StreamBuilder<Goal>(
        stream: _firestoreService.streamGoal(id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Error loading goal');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          Goal goal = snapshot.data!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height -
                    (kToolbarHeight + kBottomNavigationBarHeight + 16),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Text(
                          goal.name,
                          style: kTitlePrimary,
                        ),
                        Card(
                          margin: const EdgeInsets.only(top: 4.0),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 12.0),
                            child: Text(
                              goal.category.formatName(),
                              style: kLabel,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48.0),
                    Text(
                      'Amount saved',
                      textAlign: TextAlign.center,
                      style: kLabel,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '₱${goal.saved.toStringAsFixed(2)}',
                          style: kTitle,
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          '/ ₱${goal.price}',
                          style: kLabel,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24.0),
                    Text(
                      'Minimum amount to save',
                      textAlign: TextAlign.center,
                      style: kLabel,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '₱${goal.savingsPerFrequency.toStringAsFixed(2)}',
                          style: kTitle,
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          '/ ${goal.frequency.formatName()}',
                          style: kLabel,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24.0),
                    Text(
                      'Target date',
                      textAlign: TextAlign.center,
                      style: kLabel,
                    ),
                    Text(
                      DateFormat('MMMM d, y').format(goal.targetDate),
                      style: kSubtitle,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FilledButton(
                          onPressed: () {
                            goalInputDialog(
                              submitButtonLabel: 'Edit',
                              context: context,
                              formKey: _editFormKey,
                              dName: goal.name,
                              dSaved: goal.saved,
                              dPrice: goal.price,
                              dCategory: goal.category,
                              dFrequency: goal.frequency,
                              dTargetDate: goal.targetDate,
                              onSubmit: (name, saved, price, category,
                                  frequency, targetDate) {
                                goal = Goal(
                                  id: goal.id,
                                  name: name!,
                                  saved: saved!,
                                  price: price!,
                                  category: category!,
                                  frequency: frequency!,
                                  targetDate: targetDate!,
                                );

                                _firestoreService.updateGoal(goal);
                              },
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.secondary),
                          ),
                          child: const Text('✍️ Edit'),
                        ),
                        const SizedBox(width: 8.0),
                        FilledButton(
                          onPressed: () {
                            savingsInputDialog(
                              context: context,
                              formKey: _savingsFormKey,
                              submitButtonLabel: 'Add',
                              onSubmit: (saved) {
                                goal.addSavings(saved!);
                                _firestoreService.updateGoal(goal);
                              },
                            );
                          },
                          child: const Text('Add savings'),
                        ),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
