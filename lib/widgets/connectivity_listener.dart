import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/connectivity/connectivity_bloc.dart';
import '../bloc/connectivity/connectivity_event.dart';
import '../bloc/connectivity/connectivity_state.dart';
import '../services/snackbar_service.dart';
import '../theme/app_theme.dart';

class ConnectivityListener extends StatefulWidget {
  final Widget child;

  const ConnectivityListener({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<ConnectivityListener> createState() => _ConnectivityListenerState();
}

class _ConnectivityListenerState extends State<ConnectivityListener> {
  @override
  void initState() {
    super.initState();
    // Trigger a connectivity check when the widget is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ConnectivityBloc>().add(CheckConnectivity());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectivityBloc, ConnectivityState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        _showConnectivitySnackBar(context, state);
      },
      child: widget.child,
    );
  }

  void _showConnectivitySnackBar(BuildContext context, ConnectivityState state) {
    try {
      if (state.status == ConnectivityStatus.connected) {
        SnackbarService.showSnackBar(
          message: state.message,
          // backgroundColor: Colors.green.shade800,
          // textColor: Colors.white,
          icon: Icons.wifi,
          duration: const Duration(seconds: 2),
        );
      } else if (state.status == ConnectivityStatus.disconnected) {
        SnackbarService.showSnackBar(
          message: state.message,
          // backgroundColor: Colors.red.shade800,
          // textColor: Colors.white,
          icon: Icons.wifi_off,
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'Retry',
            textColor: Colors.white,
            onPressed: () {
              context.read<ConnectivityBloc>().add(CheckConnectivity());
            },
          ),
        );
      } else if (state.status == ConnectivityStatus.unknown) {
        // Only show this in debug mode
        if (kDebugMode) {
          SnackbarService.showSnackBar(
            message: 'Connectivity plugin not available. Please restart the app.',
            backgroundColor: Colors.orange.shade800,
            textColor: Colors.white,
            icon: Icons.warning_amber_rounded,
            duration: const Duration(seconds: 5),
          );
        }
      }
    } catch (e) {
      debugPrint('Error showing connectivity snackbar: $e');
    }
  }
} 