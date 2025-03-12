import 'package:equatable/equatable.dart';

enum ConnectivityStatus { connected, disconnected, unknown }

class ConnectivityState extends Equatable {
  final ConnectivityStatus status;
  final String message;

  const ConnectivityState({
    required this.status,
    required this.message,
  });

  factory ConnectivityState.connected() {
    return const ConnectivityState(
      status: ConnectivityStatus.connected,
      message: 'Connected to the internet',
    );
  }

  factory ConnectivityState.disconnected() {
    return const ConnectivityState(
      status: ConnectivityStatus.disconnected,
      message: 'No internet connection',
    );
  }

  factory ConnectivityState.unknown() {
    return const ConnectivityState(
      status: ConnectivityStatus.unknown,
      message: 'Connection status unknown',
    );
  }

  @override
  List<Object> get props => [status, message];
}