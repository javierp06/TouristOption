enum RequestType { permission, overtime, vacation, disability }

enum RequestStatus { pending, approved, rejected }

class Request {
  final String id;
  final RequestType type;
  final RequestStatus status;
  final DateTime startDate;
  final DateTime endDate;
  final int? hours;
  final String reason;
  final String? comments;
  final String? attachmentUrl;
  final DateTime createdAt;

  Request({
    required this.id,
    required this.type,
    required this.status,
    required this.startDate,
    required this.endDate,
    this.hours,
    required this.reason,
    this.comments,
    this.attachmentUrl,
    required this.createdAt,
  });

  Request copyWith({
    String? id,
    RequestType? type,
    RequestStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    int? hours,
    String? reason,
    String? comments,
    String? attachmentUrl,
    DateTime? createdAt,
  }) {
    return Request(
      id: id ?? this.id,
      type: type ?? this.type,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      hours: hours ?? this.hours,
      reason: reason ?? this.reason,
      comments: comments ?? this.comments,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}