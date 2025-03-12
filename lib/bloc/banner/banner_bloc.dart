import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'banner_event.dart';
import 'banner_state.dart';

class BannerBloc extends Bloc<BannerEvent, BannerState> {
  Timer? _timer;
  final int itemCount;

  BannerBloc({required this.itemCount}) : super(const BannerState()) {
    on<BannerPageChanged>(_onPageChanged);
    on<BannerAutoPlayToggled>(_onAutoPlayToggled);
    on<BannerAutoAdvance>(_onAutoAdvance);

    // Start auto-sliding
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer?.cancel();
    if (state.isAutoPlaying) {
      _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
        add(BannerAutoAdvance());
      });
    }
  }

  void _onPageChanged(BannerPageChanged event, Emitter<BannerState> emit) {
    emit(state.copyWith(currentPage: event.page));
  }

  void _onAutoPlayToggled(BannerAutoPlayToggled event, Emitter<BannerState> emit) {
    emit(state.copyWith(isAutoPlaying: event.isPlaying));
    _startAutoSlide();
  }

  void _onAutoAdvance(BannerAutoAdvance event, Emitter<BannerState> emit) {
    final nextPage = state.currentPage < itemCount - 1 ? state.currentPage + 1 : 0;
    emit(state.copyWith(currentPage: nextPage));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
} 