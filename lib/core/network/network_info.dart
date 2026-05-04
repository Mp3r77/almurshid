// ============================================================================
// NETWORK INFO - Connectivity Checker
// ============================================================================
//
// PURPOSE:
// - Check if device has internet connectivity
// - Used before making API calls
// - Can be extended for real network checks
//
// USAGE:
// if (await networkInfo.isConnected) {
//   // Make API call
// } else {
//   // Show offline message
// }
//
// ============================================================================

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

abstract class NetworkInfo {
  /// Check if device has active internet connection
  Future<bool> get isConnected;

  /// Stream of connectivity changes
  Stream<bool> get onConnectivityChanged;
}

@LazySingleton(as: NetworkInfo)
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;

  NetworkInfoImpl(this._connectivity);

  @override
  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    return _isConnected(results);
  }

  @override
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map(_isConnected);
  }

  bool _isConnected(List<ConnectivityResult> results) {
    return results.any((result) =>
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile ||
        result == ConnectivityResult.ethernet);
  }
}

// ============================================================================
// SIMPLE IMPLEMENTATION (No external package dependency)
// ============================================================================
// Use this if you don't want to add connectivity_plus package

@LazySingleton(as: NetworkInfo)
class NetworkInfoSimpleImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    // In a real app, this would use platform channels to check connectivity
    // For now, return true (mock implementation)
    return true;
  }

  @override
  Stream<bool> get onConnectivityChanged => const Stream.empty();
}
