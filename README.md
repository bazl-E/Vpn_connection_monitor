# VPN Connection Monitor

The `vpn_connection_monitor` package provides a simple and efficient way to monitor VPN connection status in a Dart/Flutter application. It includes a singleton class, `VpnConnectionMonitor`, that offers a stream of VPN connection states and a method to check the VPN connection status.

## Features

- Monitor VPN connection status with ease.
- Detect changes in VPN connectivity and trigger events accordingly.
- Allow users to set custom time intervals for checking VPN status.
- Designed as a singleton for efficient resource management.

## Getting Started

### Installation

Add the `vpn_connection_monitor` package to your `pubspec.yaml`:

```yaml
dependencies:
  vpn_connection_monitor: ^1.0.0 # Use the latest version
```

### Installation
Import the `package` package in your `Dart/Flutter` file:
```
import 'package:vpn_connection_monitor/vpn_connection_monitor.dart';
```

Create a `VpnConnectionMonitor` Instance
```
final vpnMonitor = VpnConnectionMonitor(Duration(seconds: 30));
```
### Access the VPN Connection Stream
```
vpnMonitor.vpnConnectionStream.listen((state) {
  if (state == VpnConnectionState.connected) {
    print("VPN connected.");
    // Handle VPN connected event
  } else {
    print("VPN disconnected.");
    // Handle VPN disconnected event
  }
});
```
### Check the VPN Connection Status Manually
```
bool isVpnConnected = await vpnMonitor.isVpnActive();
```

### Dispose of the VpnConnectionMonitor Instance
```
vpnMonitor.dispose();
```
### Example

For a complete example of how to use this package, please refer to the example directory.

### Contributions

Contributions are welcome! If you encounter any issues, have suggestions, or want to contribute to the project, please feel free to create issues, submit pull requests, or reach out to us.

