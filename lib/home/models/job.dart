import 'package:meta/meta.dart';

class Job {
  Job({required this.name, required this.id, required this.ratePerHour});
  final String id;
  final String name;
  final int ratePerHour;

  factory Job.fromMap(Map<String, dynamic> data, String docimentId) {
    if (data == null) throw AssertionError('data must not be null');
    final String name = data['name'];
    final int ratePerHour = data['ratePerHour'];
    return Job(
      id: docimentId,
      name: name,
      ratePerHour: ratePerHour,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ratePerHour': ratePerHour,
    };
  }
}
