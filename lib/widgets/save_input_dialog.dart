import 'package:flutter/material.dart';

void savingsInputDialog(
    {required BuildContext context,
    required GlobalKey<FormState> formKey,
    required String submitButtonLabel,
    double? dSaved,
    required Function(double? saved) onSubmit}) {
  String? saved = dSaved?.toString();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Add Savings'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  initialValue: saved,
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    saved = value;
                  },
                  decoration: const InputDecoration(labelText: 'Amount'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    } else if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
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
                onSubmit(double.tryParse(saved!));
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
