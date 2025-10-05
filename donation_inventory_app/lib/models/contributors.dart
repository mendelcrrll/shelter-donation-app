import 'donation.dart';

class Contributor {
  final String name;
  final List<Donation> donations = [];

  Contributor({required this.name});

  void addDonation(Donation donation) {
    donations.add(donation);
  }

  double totalMoney() {
    double total = 0;
    for (var d in donations) {
      if (d.type == 'Money') {
        total += double.tryParse(d.details) ?? 0;
      }
    }
    return total;
  }

  @override
  String toString() {
    return '$name (${donations.length} donations)';
  }
}
