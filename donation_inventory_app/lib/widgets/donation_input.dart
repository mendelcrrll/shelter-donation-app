import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../donation_state.dart';
import '../models/donation.dart';

class DonationInput extends StatefulWidget {
  const DonationInput({super.key});

  @override
  State<DonationInput> createState() => _DonationInputState();
}

class _DonationInputState extends State<DonationInput> {
  final _contributorController = TextEditingController();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();

  String _selectedType = 'Money';
  final List<String> _types = ['Money', 'Food', 'Clothes'];

  @override
  void dispose() {
    _contributorController.dispose();
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var donationState = context.watch<DonationState>();

    bool showQuantity() => _selectedType != 'Money';

    Color getTypeColor(String type) {
      switch (type) {
        case 'Money':
          return Colors.green;
        case 'Food':
          return Colors.orange;
        case 'Clothes':
          return Colors.blue;
        default:
          return Colors.grey;
      }
    }

    IconData getTypeIcon(String type) {
      switch (type) {
        case 'Money':
          return Icons.attach_money;
        case 'Food':
          return Icons.fastfood;
        case 'Clothes':
          return Icons.checkroom;
        default:
          return Icons.help;
      }
    }

    String getPrompt() {
      switch (_selectedType) {
        case 'Money':
          return 'Enter amount';
        case 'Food':
          return 'Enter food name';
        case 'Clothes':
          return 'Enter clothing type';
        default:
          return '';
      }
    }

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: _contributorController,
              decoration: const InputDecoration(
                labelText: 'Contributor Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: 'Select donation type',
                border: OutlineInputBorder(),
              ),
              items: _types.map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Row(
                    children: [
                      Icon(getTypeIcon(type), color: getTypeColor(type)),
                      const SizedBox(width: 10),
                      Text(
                        type,
                        style: TextStyle(
                          color: getTypeColor(type),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedType = value;
                    _nameController.clear();
                    _quantityController.clear();
                  });
                }
              },
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nameController,
              keyboardType:
                  _selectedType == 'Money' ? TextInputType.number : TextInputType.text,
              decoration: InputDecoration(
                labelText: getPrompt(),
                border: const OutlineInputBorder(),
              ),
            ),
            if (showQuantity()) ...[
              const SizedBox(height: 10),
              TextField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Enter quantity',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final contributorName = _contributorController.text.trim();
                if (contributorName.isEmpty) return;

                final itemName = _nameController.text.trim();
                if (itemName.isEmpty) return;

                if (_selectedType == 'Money') {
                  if (double.tryParse(itemName) == null) return;
                  donationState.addDonation(
                    contributorName,
                    Donation(
                        type: 'Money', details: itemName, quantity: int.parse(itemName), date: DateTime.now()),
                  );
                } else {
                  final quantity = int.tryParse(_quantityController.text);
                  if (quantity == null || quantity <= 0) return;
                  donationState.addDonation(
                    contributorName,
                    Donation(
                      type: _selectedType,
                      details: itemName,
                      quantity: quantity,
                      date: DateTime.now(),
                    ),
                  );
                }

                _contributorController.clear();
                _nameController.clear();
                _quantityController.clear();
              },
              child: const Text('Donate'),
            ),
          ],
        ),
      ),
    );
  }
}
