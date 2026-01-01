class AppUser {
  final String uid;
  final String username;
  final String email;

  AppUser({
    required this.uid,
    required this.username,
    required this.email,
  });

  factory AppUser.fromMap({
    required String uid,
    required Map<String, dynamic> data,
  }) {
    return AppUser(
      uid: uid,
      username: data['username'] ?? '',
      email: data['email'] ?? '',
    );
  }
}
