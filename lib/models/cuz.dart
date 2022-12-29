class Cuz {
  final int id;
  final String name;
  final String hatimId;
  final String user;
  final bool finished;

  const Cuz({
    required this.id,
    required this.name,
    required this.hatimId,
    required this.user,
    required this.finished,
  });

  Cuz copyWith({
    int? id,
    String? name,
    String? hatimId,
    String? user,
    bool? finished,
  }) {
    return Cuz(
      id: id ?? this.id,
      name: name ?? this.name,
      hatimId: hatimId ?? this.hatimId,
      user: user ?? this.user,
      finished: finished ?? this.finished,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'hatimId': hatimId,
      'user': user,
      'finished': finished,
    };
  }

  factory Cuz.fromMap(Map<String, dynamic> map) {
    return Cuz(
      id: map['id'] as int,
      name: map['name'] as String,
      hatimId: map['hatimId'] as String,
      user: map['user'] as String,
      finished: map['finished'] as bool,
    );
  }

  factory Cuz.fromJson(Map<String, dynamic> json) {
    return Cuz(
      id: json['id'],
      name: json['name'],
      hatimId: json['hatimId'],
      user: json['user'],
      finished: json['finished'],
    );
  }
}
