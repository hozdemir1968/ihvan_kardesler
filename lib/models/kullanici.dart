class Kullanici {
  final String uid;
  final String name;
  final String email;
  final String password;
  final String group;
  final bool isAdmin;

  Kullanici({
    required this.uid,
    required this.name,
    required this.email,
    required this.password,
    required this.group,
    required this.isAdmin,
  });

  Kullanici copyWith({
    String? uid,
    String? name,
    String? email,
    String? password,
    String? group,
    bool? isAdmin,
  }) {
    return Kullanici(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      group: group ?? this.group,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'password': password,
      'group': group,
      'isAdmin': isAdmin,
    };
  }

  factory Kullanici.fromMap(Map<String, dynamic> map) {
    return Kullanici(
      uid: map['uid'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      group: map['group'] as String,
      isAdmin: map['isAdmin'] as bool,
    );
  }
}
