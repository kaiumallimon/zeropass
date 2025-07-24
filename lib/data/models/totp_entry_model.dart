class TotpEntry {
  final String name;
  final String secret;
  final int digits;
  final String issuer;

  TotpEntry({
    required this.name,
    required this.secret,
    required this.digits,
    required this.issuer,
  });

  factory TotpEntry.fromJson(Map<String, dynamic> json) {
    return TotpEntry(
      name: json['name'],
      secret: json['secret'],
      digits: json['digits'],
      issuer: json['issuer'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'secret': secret,
      'digits': digits,
      'issuer': issuer,
    };
  }
}
