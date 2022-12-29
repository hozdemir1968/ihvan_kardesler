class Hatim {
  final String id;
  final String name;
  final String group;
  final DateTime createDate;
  final bool finished;

  const Hatim({
    required this.id,
    required this.name,
    required this.group,
    required this.createDate,
    required this.finished,
  });

  Hatim copyWith({
    String? id,
    String? name,
    String? group,
    DateTime? createDate,
    bool? finished,
  }) {
    return Hatim(
      id: id ?? this.id,
      name: name ?? this.name,
      group: group ?? this.group,
      createDate: createDate ?? this.createDate,
      finished: finished ?? this.finished,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'group': group,
      'createDate': createDate,
      'finished': finished,
    };
  }

  factory Hatim.fromMap(Map<String, dynamic> map) {
    return Hatim(
      id: map['id'] as String,
      name: map['name'] as String,
      group: map['group'] as String,
      createDate: map['createDate'].toDate(),
      finished: map['finished'] as bool,
    );
  }

  factory Hatim.fromJson(Map<String, dynamic> json) {
    return Hatim(
      id: json['id'],
      name: json['name'],
      group: json['group'],
      createDate: json['createDate'].toDate(),
      finished: json['finished'],
    );
  }
}
