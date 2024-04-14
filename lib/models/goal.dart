import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_boilerplate/models/category.dart';
import 'package:flutter_boilerplate/models/frequency.dart';

class Goal {
  final String? id;
  final String name;
  double saved;
  final double price;
  final Category category;
  final Frequency frequency;
  final DateTime targetDate;

  Goal({
    this.id,
    required this.name,
    this.saved = 0,
    required this.price,
    required this.category,
    required this.frequency,
    required this.targetDate,
  });

  factory Goal.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> data = snapshot.data()!;

    return Goal(
      id: snapshot.id,
      name: data['name'],
      saved: data['saved'],
      price: data['price'],
      category: Category.fromJson(data['category']),
      frequency: Frequency.fromJson(data['frequency']),
      targetDate: data['targetDate'].toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'saved': saved,
      'price': price,
      'category': category.toJson(),
      'frequency': frequency.toJson(),
      'targetDate': targetDate,
    };
  }

  double get savingsPerFrequency {
    int daysUntilTargetDate = targetDate.difference(DateTime.now()).inDays;
    // two decimal places
    return ((price - saved) / (daysUntilTargetDate / frequency.daysInBetween));
  }

  void addSavings(double savings) {
    saved += savings;
  }
}
