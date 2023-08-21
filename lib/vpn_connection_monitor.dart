import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

enum VpnConnectionState { connected, disconnected }

class VpnConnectionMonitor {
  final StreamController<VpnConnectionState> _controller =
      StreamController.broadcast();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  // Private constructor for the singleton
  VpnConnectionMonitor._private() {
    // Listen to network connectivity changes
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      await _checkVpnStatus();
    });
  }

  ///Check weather a vpn is connected or not which returns a bool
  Future<bool> isVpnActive() async {
    try {
      final interfaces = await NetworkInterface.list(
        includeLoopback: false,
        type: InternetAddressType.any,
      );

      return interfaces.any((interface) => commonVpnInterfaceNamePatterns
          .any((pattern) => interface.name.toLowerCase().contains(pattern)));
    } catch (e) {
      // Handle exceptions, e.g., if the network interface list cannot be retrieved
      return false;
    }
  }

  // Singleton instance
  static VpnConnectionMonitor? _instance;

  factory VpnConnectionMonitor() {
    _instance ??= VpnConnectionMonitor._private();
    return _instance!;
  }

  /// Returns a stream of [VpnConnectionState]s that updates whenever there's an update in VPN connection status =
  Stream<VpnConnectionState> get vpnConnectionStream =>
      _controller.stream.asBroadcastStream();

  Future<void> _checkVpnStatus() async {
    bool currentVpnStatus = await _isVpnActive();

    if (currentVpnStatus) {
      _controller.add(VpnConnectionState.connected);
    } else {
      _controller.add(VpnConnectionState.disconnected);
    }
  }

  Future<bool> _isVpnActive() async {
    try {
      final interfaces = await NetworkInterface.list();

      return interfaces.any((interface) => commonVpnInterfaceNamePatterns
          .any((pattern) => interface.name.toLowerCase().contains(pattern)));
    } catch (e) {
      // Handle exceptions, e.g., if the network interface list cannot be retrieved
      return false;
    }
  }

  /// Dispose all the connection streams
  void dispose() {
    _controller.close();
    _connectivitySubscription.cancel();
  }

  List<String> commonVpnInterfaceNamePatterns = [
    "tun", // Linux/Unix TUN interface
    "tap", // Linux/Unix TAP interface
    "ppp", // Point-to-Point Protocol
    "pptp", // PPTP VPN
    "l2tp", // L2TP VPN
    "ipsec", // IPsec VPN
    "vpn", // Generic "VPN" keyword
    "wireguard", // WireGuard VPN
    "openvpn", // OpenVPN VPN
    "softether", // SoftEther VPN
  ];
}
