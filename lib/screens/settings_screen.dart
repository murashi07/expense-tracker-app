import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );
  String _deviceId = 'Unknown';

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    _getDeviceInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Future<void> _getDeviceInfo() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    String deviceId;
    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      deviceId = androidInfo.id;
    } else if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      deviceId = iosInfo.identifierForVendor ?? 'Unknown';
    } else {
      deviceId = 'N/A';
    }

    setState(() {
      _deviceId = deviceId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('App Version'),
            subtitle: Text('${_packageInfo.version} + ${_packageInfo.buildNumber}'),
          ),
          ListTile(
            leading: const Icon(Icons.devices_other),
            title: const Text('Device ID'),
            subtitle: Text(_deviceId),
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Send Feedback'),
            subtitle: const Text('Report bugs or suggest improvements'),
            onTap: () => _launchURL('mailto:feedback@example.com?subject=Expense Tracker Feedback'),
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help & Support'),
            onTap: () => _launchURL('https://www.example.com/expense-tracker-help'),
          ),
          ListTile(
            leading: const Icon(Icons.code),
            title: const Text('Open Source Project'),
            subtitle: const Text('Contribute on Github'),
            onTap: () => _launchURL('https://github.com/YourUsername/expense_tracker'),
          ),
        ],
      ),
    );
  }

  _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}