import 'package:equatable/equatable.dart';

abstract class BannerEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class BannerPageChanged extends BannerEvent {
  final int page;

  BannerPageChanged(this.page);

  @override
  List<Object?> get props => [page];
}

class BannerAutoPlayToggled extends BannerEvent {
  final bool isPlaying;

  BannerAutoPlayToggled(this.isPlaying);

  @override
  List<Object?> get props => [isPlaying];
}

class BannerAutoAdvance extends BannerEvent {} 