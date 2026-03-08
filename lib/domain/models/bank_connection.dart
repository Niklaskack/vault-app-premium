class BankConnection {
  final String id;
  final String institutionName;
  final String publicToken;
  final DateTime connectedAt;

  BankConnection({
    required this.id,
    required this.institutionName,
    required this.publicToken,
    required this.connectedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'institutionName': institutionName,
      'publicToken': publicToken,
      'connectedAt': connectedAt.toIso8601String(),
    };
  }

  factory BankConnection.fromMap(Map<String, dynamic> map) {
    return BankConnection(
      id: map['id'],
      institutionName: map['institutionName'],
      publicToken: map['publicToken'],
      connectedAt: DateTime.parse(map['connectedAt']),
    );
  }
}
