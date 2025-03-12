import 'package:equatable/equatable.dart';

enum SearchStatus { idle, active }

class SearchState extends Equatable {
  final String query;
  final SearchStatus status;

  const SearchState({
    this.query = '',
    this.status = SearchStatus.idle,
  });

  SearchState copyWith({
    String? query,
    SearchStatus? status,
  }) {
    return SearchState(
      query: query ?? this.query,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [query, status];
} 