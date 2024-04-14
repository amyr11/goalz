import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/models/category.dart';
import 'package:flutter_boilerplate/models/frequency.dart';
import 'package:intl/intl.dart';

void goalInputDialog(
    {required BuildContext context,
    required GlobalKey<FormState> formKey,
    required String submitButtonLabel,
    String? dName,
    double? dSaved,
    double? dPrice,
    Category? dCategory,
    Frequency? dFrequency,
    DateTime? dTargetDate,
    required Function(String? name, double? saved, double? price,
            Category? category, Frequency? frequency, DateTime? targetDate)
        onSubmit}) {
  TextEditingController dateCtl = TextEditingController();
  String? name = dName;
  double? saved = dSaved ?? 0;
  double? price = dPrice;
  Category? category = dCategory;
  Frequency? frequency = dFrequency;
  DateTime? targetDate = dTargetDate;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Add Goal'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  initialValue: name,
                  onSaved: (value) {
                    name = value;
                  },
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: price?.toString(),
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    price = double.tryParse(value!);
                  },
                  decoration: const InputDecoration(labelText: 'Price'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    } else if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: saved.toString(),
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    saved = double.tryParse(value!);
                  },
                  decoration: const InputDecoration(labelText: 'Saved'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a saved amount';
                    } else if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField(
                  value: category,
                  decoration: const InputDecoration(labelText: 'Category'),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    category = value as Category;
                  },
                  items: Category.values
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category.formatName()),
                          ))
                      .toList(),
                ),
                TextFormField(
                  initialValue: dTargetDate != null
                      ? DateFormat('MMMM d, y').format(targetDate!)
                      : null,
                  controller: dTargetDate != null ? null : dateCtl,
                  onSaved: (value) {
                    targetDate = DateFormat('MMMM d, y').parse(value!);
                  },
                  decoration: const InputDecoration(
                    labelText: "Target Date",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a target date';
                    }
                    return null;
                  },
                  onTap: () async {
                    DateTime date = DateTime.now();
                    FocusScope.of(context).requestFocus(FocusNode());

                    DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: dTargetDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now()
                            .add(const Duration(days: 365 * yearLimit)));

                    date = selectedDate ?? date;

                    dateCtl.text = DateFormat('MMMM d, y').format(date);
                  },
                ),
                DropdownButtonFormField(
                  value: frequency,
                  decoration: const InputDecoration(labelText: 'Frequency'),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select frequency';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    frequency = value as Frequency;
                  },
                  items: Frequency.values
                      .map((frequency) => DropdownMenuItem(
                            value: frequency,
                            child: Text(frequency.formatName()),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                onSubmit(name, saved, price, category, frequency, targetDate);
                Navigator.of(context).pop();
              }
            },
            child: Text(submitButtonLabel),
          ),
        ],
      );
    },
  );
}