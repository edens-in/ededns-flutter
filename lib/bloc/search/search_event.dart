import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchQueryChanged extends SearchEvent {
  final String query;

  const SearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class SearchFocusChanged extends SearchEvent {
  final bool isFocused;
  
  SearchFocusChanged(this.isFocused);
  
  @override
  List<Object?> get props => [isFocused];
}

class SearchSubmitted extends SearchEvent {
  final String query;

  const SearchSubmitted(this.query);

  @override
  List<Object?> get props => [query];
}

class SearchCleared extends SearchEvent {}

class VoiceSearchStarted extends SearchEvent {}

class VoiceSearchStopped extends SearchEvent {}

class VoiceSearchResult extends SearchEvent {
  final String recognizedText;
  final bool isFinal;

  const VoiceSearchResult(this.recognizedText, {this.isFinal = false});

  @override
  List<Object?> get props => [recognizedText, isFinal];
}

class VoiceSearchError extends SearchEvent {
  final String error;

  const VoiceSearchError(this.error);

  @override
  List<Object?> get props => [error];
}

class AddRecentSearch extends SearchEvent {
  final String query;
  
  AddRecentSearch(this.query);
  
  @override
  List<Object?> get props => [query];
}

class ClearRecentSearches extends SearchEvent {}

class LoadRecentSearches extends SearchEvent {} 