import 'dart:async';
import 'dart:developer' as developer;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'connectivity_event.dart';
import 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  bool _isInitialized = false;
  bool _hasPluginError = false;

  ConnectivityBloc() : super(ConnectivityState.unknown()) {
    on<CheckConnectivity>(_onCheckConnectivity);
    on<ConnectivityStatusChanged>(_onConnectivityStatusChanged);
    
    _initConnectivity();
  }

  Future<void> _initConnectivity() async {
    if (_isInitialized || _hasPluginError) return;
    
    try {
      // Initial connectivity check
      await _checkConnectivityStatus();
      
      // Set up the listener for connectivity changes
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
        (ConnectivityResult result) {
          add(ConnectivityStatusChanged(
            isConnected: result != ConnectivityResult.none,
          ));
        },
        onError: (Object error) {
          _handleError(error);
        },
        cancelOnError: false,
      );
      
      _isInitialized = true;
    } on PlatformException catch (e) {
      _handleError(e);
    } on MissingPluginException catch (e) {
      _handleMissingPluginError(e);
    } catch (e) {
      _handleError(e);
    }
  }

  void _handleMissingPluginError(MissingPluginException e) {
    developer.log('MissingPluginException: ${e.message}');
    _hasPluginError = true;
    emit(ConnectivityState.unknown());
  }

  void _handleError(Object error) {
    developer.log('Connectivity error: $error');
    if (error is MissingPluginException) {
      _hasPluginError = true;
      emit(ConnectivityState.unknown());
    } else {
      emit(ConnectivityState.disconnected());
    }
  }

  Future<void> _checkConnectivityStatus() async {
    if (_hasPluginError) {
      emit(ConnectivityState.unknown());
      return;
    }
    
    try {
      final ConnectivityResult result = await _connectivity.checkConnectivity();
      add(ConnectivityStatusChanged(
        isConnected: result != ConnectivityResult.none,
      ));
    } on PlatformException catch (e) {
      _handleError(e);
    } on MissingPluginException catch (e) {
      _handleMissingPluginError(e);
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> _onCheckConnectivity(
    CheckConnectivity event,
    Emitter<ConnectivityState> emit,
  ) async {
    if (_hasPluginError) {
      emit(ConnectivityState.unknown());
      return;
    }
    
    try {
      await _checkConnectivityStatus();
    } on MissingPluginException catch (e) {
      _handleMissingPluginError(e);
    } catch (e) {
      _handleError(e);
    }
  }

  void _onConnectivityStatusChanged(
    ConnectivityStatusChanged event,
    Emitter<ConnectivityState> emit,
  ) {
    if (_hasPluginError) {
      emit(ConnectivityState.unknown());
      return;
    }
    
    try {
      if (event.isConnected) {
        emit(ConnectivityState.connected());
      } else {
        emit(ConnectivityState.disconnected());
      }
    } catch (e) {
      _handleError(e);
    }
  }

  @override
  Future<void> close() async {
    await _connectivitySubscription?.cancel();
    return super.close();
  }
} 