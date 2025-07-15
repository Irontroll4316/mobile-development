class FirebaseUser {
  final String email;
  final String name;
  final String profilePicture;

  const FirebaseUser({required this.email, required this.name, required this.profilePicture});

  FirebaseUser copyWith({
    String? email,
    String? name,
    String? profilePicture,
  }) {
    return FirebaseUser(
      email: email ?? this.email,
      name: name ?? this.name,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'profilePicture': profilePicture,
    };
  }

  factory FirebaseUser.fromMap(Map<String, dynamic> map) {
    return FirebaseUser(
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      profilePicture: map['profilePicture'] ?? '',
    );
  }
}