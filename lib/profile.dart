class UserProfile {
  String fullName;
  int age;
  String email;

  UserProfile({required this.fullName, required this.age, required this.email});

  Map<String, dynamic> toJson() {
    return {
      "fullName": fullName,
      "age": age,
      "email": email,
    };
  }
}
