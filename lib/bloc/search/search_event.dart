import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchQueryChanged extends SearchEvent {
  final String query;
  
  SearchQueryChanged(this.query);
  
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
  
  SearchSubmitted(this.query);
  
  @override
  List<Object?> get props => [query];
}

class AddRecentSearch extends SearchEvent {
  final String query;
  
  AddRecentSearch(this.query);
  
  @override
  List<Object?> get props => [query];
}

class ClearRecentSearches extends SearchEvent {}

class LoadRecentSearches extends SearchEvent {} 