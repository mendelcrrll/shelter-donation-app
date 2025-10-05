import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../donation_state.dart';

class DistributionScreen extends StatelessWidget {
  const DistributionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var donationState = context.watch<DonationState>();
    var allDonations = donationState.donations;

    return Scaffold(
      appBar: AppBar(title: const Text('Distribute Donations')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: allDonations.length,
          itemBuilder: (context, index) {
            var donation = allDonations[index];
            final _amountController = TextEditingController();

            // Determine card color
            Color cardColor;
            if (donation.isFullyDistributed) {
              cardColor = Colors.red[100]!;
            } else if (donation.distributedQuantity > 0) {
              cardColor = Colors.orange[100]!;
            } else {
              cardColor = Colors.white;
            }

            return Card(
              color: cardColor,
              child: ListTile(
                leading: Icon(
                  donation.isFullyDistributed
                      ? Icons.check
                      : Icons.inventory_2,
                  color: donation.isFullyDistributed
                      ? Colors.red
                      : donation.distributedQuantity > 0
                          ? Colors.orange
                          : Colors.green,
                ),
                title: Text(donation.displayString()),
                subtitle: !donation.isFullyDistributed
                    ? TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: donation.type == 'Money'
                              ? 'Amount to distribute (max \$${donation.remaining})'
                              : 'Quantity to distribute (max ${donation.remaining})',
                        ),
                      )
                    : null,
                trailing: donation.isFullyDistributed
                    ? const Text('Distributed', style: TextStyle(color: Colors.red))
                    : ElevatedButton(
                        onPressed: () {
                          final input = int.tryParse(_amountController.text);
                          if (input == null || input <= 0 || input > donation.remaining) return;
                          donationState.distributePartial(donation, input);
                        },
                        child: const Text('Distribute'),
                      ),
              ),
            );
          },
        ),
      ),
    );
  }
}
