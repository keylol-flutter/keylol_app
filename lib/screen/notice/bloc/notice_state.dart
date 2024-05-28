part of 'notice_bloc.dart';

enum NoticeStatus {
  initial,
  success,
  failure;

  static NoticeStatus fromName(String name) =>
      NoticeStatus.values.firstWhere((e) => e.name == name);
}

class NoticeState extends Equatable {
  final NoticeStatus status;
  final List<Note> notices;
  final int page;
  final bool hasReachMax;
  final String? message;

  const NoticeState(
      this.status, this.notices, this.page, this.hasReachMax, this.message);

  NoticeState copyWith({
    NoticeStatus? status,
    List<Note>? notices,
    int? page,
    bool? hasReachMax,
    String? message,
  }) {
    return NoticeState(
      status ?? this.status,
      notices ?? this.notices,
      page ?? this.page,
      hasReachMax ?? this.hasReachMax,
      message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, notices, page, hasReachMax, message];

  factory NoticeState.fromJson(Map<String, dynamic> json) => NoticeState(
        NoticeStatus.fromName(json['status']),
        (json['notices'] as List<dynamic>)
            .map((json) => Note.fromJson(json))
            .toList(),
        json['page'],
        json['hasReachMax'] ?? true,
        json['message'],
      );

  Map<String, dynamic> toJson() => {
        'status': status.name,
        'notices': notices.map((note) => note.toJson()).toList(),
        'page': page,
        'hasReachMax': hasReachMax,
        'message': message,
      };
}

class NoticeInitial extends NoticeState {
  const NoticeInitial() : super(NoticeStatus.initial, const [], 1, false, null);
}
