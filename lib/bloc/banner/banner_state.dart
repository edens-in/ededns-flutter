import 'package:equatable/equatable.dart';

class BannerState extends Equatable {
  final int currentPage;
  final bool isAutoPlaying;

  const BannerState({
    this.currentPage = 0,
    this.isAutoPlaying = true,
  });

  BannerState copyWith({
    int? currentPage,
    bool? isAutoPlaying,
  }) {
    return BannerState(
      currentPage: currentPage ?? this.currentPage,
      isAutoPlaying: isAutoPlaying ?? this.isAutoPlaying,
    );
  }

  @override
  List<Object?> get props => [currentPage, isAutoPlaying];
} 