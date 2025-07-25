class TotpEntry {
  final String id;
  final String name;
  final String secret;
  final int digits;
  final String issuer;

  TotpEntry({
    required this.id,
    required this.name,
    required this.secret,
    required this.digits,
    required this.issuer,
  });

  factory TotpEntry.fromJson(Map<String, dynamic> json) {
    return TotpEntry(
      id: json['id'] ?? '',
      name: json['name'],
      secret: json['secret'],
      digits: json['digits'],
      issuer: json['issuer'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'secret': secret, 'digits': digits, 'issuer': issuer};
  }

  set name(String newName) {
    name = newName;
  }

  set secret(String newSecret) {
    secret = newSecret;
  }

  set digits(int newDigits) {
    digits = newDigits;
  }

  set issuer(String newIssuer) {
    issuer = newIssuer;
  }
}
