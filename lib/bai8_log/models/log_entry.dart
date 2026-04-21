class LogEntry {
  final int? id;
  final String action;
  final String time;

  LogEntry({this.id, required this.action, required this.time});

  Map<String, dynamic> toMap() {
    return {'id': id, 'action': action, 'time': time};
  }

  factory LogEntry.fromMap(Map<String, dynamic> map) {
    return LogEntry(
      id: map['id'] as int?,
      action: map['action'] as String,
      time: map['time'] as String,
    );
  }
}
