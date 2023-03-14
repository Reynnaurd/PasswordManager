class Information {
  const Information(
      {required this.userName, required this.password, required this.website});

  final String userName;
  final String password;
  final String website;

  factory Information.fromJson(Map<String, dynamic> json) {
    return Information(
        userName: json['userName'],
        password: json['password'],
        website: json['website']);
  }
}
