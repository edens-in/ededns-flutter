import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isInitialized = false;

  SearchBloc() : super(const SearchState()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<SearchSubmitted>(_onSearchSubmitted);
    on<SearchCleared>(_onSearchCleared);
    on<VoiceSearchStarted>(_onVoiceSearchStarted);
    on<VoiceSearchStopped>(_onVoiceSearchStopped);
    on<VoiceSearchResult>(_onVoiceSearchResult);
    on<VoiceSearchError>(_onVoiceSearchError);
  }

  void _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) {
    emit(state.copyWith(
      query: event.query,
      status: event.query.isEmpty ? SearchStatus.initial : SearchStatus.active,
    ));
  }

  void _onSearchSubmitted(
    SearchSubmitted event,
    Emitter<SearchState> emit,
  ) {
    if (event.query.isNotEmpty) {
      emit(state.copyWith(
        status: SearchStatus.loading,
        recentSearches: [...state.recentSearches, event.query],
      ));
      // Here you would typically call your search API
      // For now, we'll just emit success
      emit(state.copyWith(status: SearchStatus.success));
    }
  }

  void _onSearchCleared(
    SearchCleared event,
    Emitter<SearchState> emit,
  ) {
    emit(state.copyWith(
      query: '',
      status: SearchStatus.initial,
    ));
  }

  Future<void> _onVoiceSearchStarted(
    VoiceSearchStarted event,
    Emitter<SearchState> emit,
  ) async {
    if (!_isInitialized) {
      _isInitialized = await _speech.initialize(
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            add(VoiceSearchStopped());
          }
        },
        onError: (error) => add(VoiceSearchError(error.errorMsg)),
      );
    }

    if (_isInitialized) {
      emit(state.copyWith(voiceStatus: VoiceSearchStatus.listening));
      
      await _speech.listen(
        onResult: (result) {
          add(VoiceSearchResult(
            result.recognizedWords,
            isFinal: result.finalResult,
          ));
        },
      );
    } else {
      add(const VoiceSearchError('Speech recognition not available'));
    }
  }

  void _onVoiceSearchStopped(
    VoiceSearchStopped event,
    Emitter<SearchState> emit,
  ) {
    _speech.stop();
    emit(state.copyWith(voiceStatus: VoiceSearchStatus.inactive));
  }

  void _onVoiceSearchResult(
    VoiceSearchResult event,
    Emitter<SearchState> emit,
  ) {
    emit(state.copyWith(
      query: event.recognizedText,
      status: SearchStatus.active,
      voiceStatus: event.isFinal ? VoiceSearchStatus.inactive : VoiceSearchStatus.listening,
    ));

    if (event.isFinal && event.recognizedText.isNotEmpty) {
      add(SearchSubmitted(event.recognizedText));
    }
  }

  void _onVoiceSearchError(
    VoiceSearchError event,
    Emitter<SearchState> emit,
  ) {
    emit(state.copyWith(
      voiceStatus: VoiceSearchStatus.error,
      errorMessage: event.error,
    ));
  }

  @override
  Future<void> close() {
    _speech.cancel();
    return super.close();
  }
} 