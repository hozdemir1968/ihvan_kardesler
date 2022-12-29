class Grup {
  final String id;
  final String name;
  final String secretWord;
  final String adminName;

  const Grup({
    required this.id,
    required this.name,
    required this.secretWord,
    required this.adminName,
  });

  Grup copyWith({
    String? id,
    String? name,
    String? secretWord,
    String? adminName,
  }) {
    return Grup(
      id: id ?? this.id,
      name: name ?? this.name,
      secretWord: secretWord ?? this.secretWord,
      adminName: adminName ?? this.adminName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'secretWord': secretWord,
      'adminName': adminName,
    };
  }

  factory Grup.fromMap(Map<String, dynamic> map) {
    return Grup(
      id: map['id'] as String,
      name: map['name'] as String,
      secretWord: map['secretWord'] as String,
      adminName: map['adminName'] as String,
    );
  }
}
