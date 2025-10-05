class Donation {
  final String type; // Money, Food, Clothes
  final String details; // name or amount
  int quantity; 
  final DateTime date;
  int distributedQuantity;

  Donation({
    required this.type,
    required this.details,
    int? quantity,
    required this.date,
    this.distributedQuantity = 0,
  }) : quantity = quantity ?? (type == 'Money' ? int.tryParse(details) ?? 0 : 0);

  int get remaining => (quantity - distributedQuantity).clamp(0, quantity);

  bool get isFullyDistributed => remaining <= 0;
  bool get distributed => isFullyDistributed;

  void distribute(int count) {
    if (count <= 0) return;
    distributedQuantity += count;
    if (distributedQuantity > quantity) {
      distributedQuantity = quantity;
    }
  }

  String displayString() {
    final formatted = date.toLocal().toString().substring(0, 16); // YYYY-MM-DD HH:MM
    if (type == 'Money') {
      return '$type: \$${quantity} - Remaining: \$${remaining} on $formatted';
    } else {
      return '$type: $details - Total: $quantity, Remaining: $remaining on $formatted';
    }
  }

  @override
  String toString() => displayString();
}
