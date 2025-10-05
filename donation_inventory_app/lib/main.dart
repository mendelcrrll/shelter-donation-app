import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'donation_state.dart';
import 'screens/distribution_screen.dart';
import 'screens/report_screen.dart';
import 'widgets/gradient_title.dart';
import 'widgets/donation_input.dart';
import 'models/donation.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => DonationState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Donations App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _viewMode = 'Contributor'; // toggle between Contributor and Type

  @override
  Widget build(BuildContext context) {
    var donationState = context.watch<DonationState>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            gradientTitle('Shelter Donation Manager'),

            const SizedBox(height: 10),

            // Donation input card
            const DonationInput(),

            const SizedBox(height: 10),

            // View toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('View by:'),
                const SizedBox(width: 10),
                ChoiceChip(
                  label: const Text('Contributor'),
                  selected: _viewMode == 'Contributor',
                  onSelected: (selected) {
                    setState(() => _viewMode = 'Contributor');
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Type'),
                  selected: _viewMode == 'Type',
                  onSelected: (selected) {
                    setState(() => _viewMode = 'Type');
                  },
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Total money display
            Text(
              'Total Money: \$${donationState.totalMoney().toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20),
            ),

            const SizedBox(height: 10),

            // Navigation buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const DistributionScreen()),
                    );
                  },
                  icon: const Icon(Icons.send),
                  label: const Text('Go to Distribution'),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ReportScreen()),
                    );
                  },
                  icon: const Icon(Icons.bar_chart),
                  label: const Text('View Reports'),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Dynamic list depending on view mode
            Expanded(
              child: _viewMode == 'Contributor'
                  ? _buildContributorView(donationState)
                  : _buildTypeView(donationState),
            ),
          ],
        ),
      ),
    );
  }

  // Grouped by contributor
  Widget _buildContributorView(DonationState donationState) {
    return ListView(
      children: donationState.contributors.map((c) {
        return ExpansionTile(
          title: Text('${c.name} - \$${c.totalMoney().toStringAsFixed(2)}'),
          children: c.donations
              .map((d) => ListTile(
                    title: Text(d.toString()),
                  ))
              .toList(),
        );
      }).toList(),
    );
  }

  // Grouped by donation type
  Widget _buildTypeView(DonationState donationState) {
    final grouped = <String, List<Donation>>{};
    for (var c in donationState.contributors) {
      for (var d in c.donations) {
        grouped.putIfAbsent(d.type, () => []).add(d);
      }
    }

    return ListView(
      children: grouped.entries.map((entry) {
        final type = entry.key;
        final donations = entry.value;
        return ExpansionTile(
          title: Text(
            '$type (${donations.length})',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          children: donations
              .map((d) => ListTile(
                    title: Text(
                        '${d.details}${' x${d.quantity}'} (${d.date.toLocal().toString().split(" ").first})'),
                  ))
              .toList(),
        );
      }).toList(),
    );
  }
}
