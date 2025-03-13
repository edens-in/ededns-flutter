import 'package:equatable/equatable.dart';

enum SearchStatus {
  initial,
  active,
  loading,
  success,
  error
}

enum VoiceSearchStatus {
  inactive,
  listening,
  processing,
  error
}

class SearchState extends Equatable {
  final String query;
  final SearchStatus status;
  final VoiceSearchStatus voiceStatus;
  final String? errorMessage;
  final List<String> recentSearches;

  const SearchState({
    this.query = '',
    this.status = SearchStatus.initial,
    this.voiceStatus = VoiceSearchStatus.inactive,
    this.errorMessage,
    this.recentSearches = const [],
  });

  SearchState copyWith({
    String? query,
    SearchStatus? status,
    VoiceSearchStatus? voiceStatus,
    String? errorMessage,
    List<String>? recentSearches,
  }) {
    return SearchState(
      query: query ?? this.query,
      status: status ?? this.status,
      voiceStatus: voiceStatus ?? this.voiceStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      recentSearches: recentSearches ?? this.recentSearches,
    );
  }

  @override
  List<Object?> get props => [
    query,
    status,
    voiceStatus,
    errorMessage,
    recentSearches,
  ];

  bool get isVoiceSearchActive => voiceStatus == VoiceSearchStatus.listening;
  bool get hasError => errorMessage != null;
} 