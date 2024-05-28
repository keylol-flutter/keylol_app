part of 'index_bloc.dart';

enum IndexStatus {
  initial,
  success,
  failure;

  static IndexStatus fromName(String name) =>
      IndexStatus.values.firstWhere((e) => e.name == name);
}

class IndexState extends Equatable {
  final IndexStatus status;
  final Index? index;

  const IndexState(this.status, this.index);

  IndexState copyWith({
    IndexStatus? status,
    Index? index,
  }) {
    return IndexState(
      status ?? this.status,
      index ?? this.index,
    );
  }

  @override
  List<Object?> get props => [status, index];

  factory IndexState.fromJson(Map<String, dynamic> json) => IndexState(
        IndexStatus.fromName(json['status']),
        json['index'] == null ? null : Index.fromJson(json['index']),
      );

  Map<String, dynamic> toJson() => {
        'status': status.name,
        'index': index?.toJson(),
      };
}

class IndexInitial extends IndexState {
  const IndexInitial() : super(IndexStatus.initial, null);
}
