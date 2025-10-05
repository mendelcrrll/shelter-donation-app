import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../donation_state.dart';
import '../models/donation.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String sortBy = 'contributor'; // or 'type'

  @override
  Widget build(BuildContext context) {
    var donationState = context.watch<DonationState>();
    var donations = List<Donation>.from(donationState.donations);

    // Apply sorting
    donations.sort((a, b) {
      if (sortBy == 'type') {
        return a.type.compareTo(b.type);
      } else {
        return a.details.compareTo(b.details);
      }
    });

    // Totals
    int totalMoneyRemaining = donations
        .where((d) => d.type == 'Money')
        .fold(0, (sum, d) => sum + d.remaining);

    int totalItemsRemaining = donations
        .where((d) => d.type != 'Money')
        .fold(0, (sum, d) => sum + d.remaining);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Reports'),
          bottom: TabBar(
            tabs: const [
              Tab(text: 'Donations'),
              Tab(text: 'Distribution'),
            ],
          ),
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) => setState(() => sortBy = value),
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'contributor', child: Text('Sort by Contributor')),
                const PopupMenuItem(value: 'type', child: Text('Sort by Type')),
              ],
            ),
          ],
        ),
        body: TabBarView(
          children: [
            // Donations Tab
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Total Money: \$${totalMoneyRemaining}, Total Items: $totalItemsRemaining',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: donations.length,
                    itemBuilder: (context, index) {
                      var donation = donations[index];
                      if (donation.isFullyDistributed) return const SizedBox.shrink();

                      Color cardColor;
                      if (donation.distributedQuantity > 0) {
                        cardColor = Colors.orange[100]!;
                      } else {
                        cardColor = Colors.white;
                      }

                      return Card(
                        color: cardColor,
                        child: ListTile(
                          title: Text(donation.displayString()),
                          leading: Icon(
                            Icons.add_box,
                            color: donation.distributedQuantity > 0 ? Colors.orange : Colors.green,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            // Distribution Tab
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: donations.length,
                    itemBuilder: (context, index) {
                      var donation = donations[index];
                      if (donation.distributedQuantity == 0) return const SizedBox.shrink();

                      Color cardColor = donation.isFullyDistributed
                          ? Colors.red[100]!
                          : Colors.orange[100]!;

                      return Card(
                        color: cardColor,
                        child: ListTile(
                          title: Text(donation.displayString()),
                          leading: Icon(
                            Icons.send,
                            color: donation.isFullyDistributed ? Colors.red : Colors.orange,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
