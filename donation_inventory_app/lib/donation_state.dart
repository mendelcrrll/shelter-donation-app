import 'package:flutter/material.dart';
import '../models/donation.dart';
import '../models/contributors.dart';

class DonationState extends ChangeNotifier {
  final List<Donation> donations = [];
  final List<Contributor> contributors = [];

  void addDonation(String contributorName, Donation donation) {
    donations.add(donation);

    // Find existing contributor or create a new one
    var contributor = contributors.firstWhere(
      (c) => c.name == contributorName,
      orElse: () {
        final newContributor = Contributor(name: contributorName);
        contributors.add(newContributor);
        return newContributor;
      },
    );

    contributor.addDonation(donation);
    notifyListeners();
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

  void distributeDonation(Donation donation) {
    // Distribute the full remaining amount
    donation.distribute(donation.remaining);
    notifyListeners();
  }

  // Optionally, get only available donations
  List<Donation> availableDonations() {
    return donations.where((d) => !d.distributed).toList();
  }

  void distributePartial(Donation donation, int count) {
    donation.distribute(count);
    notifyListeners();
  }

}
