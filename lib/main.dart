import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BluetoothCarController extends StatefulWidget {
  @override
  _BluetoothCarControllerState createState() => _BluetoothCarControllerState();
}

class _BluetoothCarControllerState extends State<BluetoothCarController> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<BluetoothDevice> devicesList = [];
  BluetoothDevice? _selectedDevice; // Store the selected device
  String? _error; // Store error message

  // Add Bluetooth device search function with error handling
  void searchDevices() {
    try {
      flutterBlue.startScan(timeout: Duration(seconds: 4));
      flutterBlue.scanResults.listen((results) {
        for (ScanResult r in results) {
          if (!devicesList.contains(r.device)) {
            setState(() {
              devicesList.add(r.device);
            });
          }
        }
      });
    } catch (e) {
      setState(() {
        _error = 'Error scanning for devices: $e';
      });
    }
  }

  // Add function to connect to a Bluetooth device with error handling
  void connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      // Once connected, you can implement your car control logic here
    } catch (e) {
      setState(() {
        _error = 'Error connecting to device: $e';
      });
    }
  }

  // Stop car movement
  void _stopMovement() {
    setState(() {
      // Your logic to stop car movement
    });
  }

  @override
  void initState() {
    super.initState();
    searchDevices(); // Start searching for devices when the widget initializes
  }

  // Build the dropdown menu for selecting devices
  Widget _buildDeviceDropdown() {
    return DropdownButton<BluetoothDevice>(
      value: _selectedDevice,
      items: devicesList.map((BluetoothDevice device) {
        return DropdownMenuItem<BluetoothDevice>(
          value: device,
          child: Text(device.name ?? "Unknown Device"),
        );
      }).toList(),
      onChanged: (BluetoothDevice? selectedDevice) {
        setState(() {
          _selectedDevice = selectedDevice;
        });
        if (selectedDevice != null) {
          connectToDevice(selectedDevice);
        }
      },
      hint: Text('Select Device'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Car Controller'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                devicesList.clear(); // Clear the existing list
                searchDevices(); // Refresh the device list
                _selectedDevice = null; // Reset selected device
                _error = null; // Clear any previous errors
              });
            },
          ),
          _buildDeviceDropdown(), // Add the dropdown to the app bar
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Display error message if any
          if (_error != null)
            Text(
              _error!,
              style: TextStyle(color: Colors.red),
            ),
          SizedBox(height: 20),
          // Your existing control buttons
          GestureDetector(
            // Forward button
            onTapDown: (_) {
              setState(() {
                // Your logic for moving the car forward
              });
            },
            onTapUp: (_) {
              setState(() {
                _stopMovement();
              });
            },
            child: ElevatedButton(
              onPressed: () {},
              child: Text('Forward'),
            ),
          ),
          SizedBox(height: 20),
          // Other buttons...
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: BluetoothCarController(),
  ));
}