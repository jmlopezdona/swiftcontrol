import 'dart:async';
import 'dart:io';

import 'package:dartx/dartx.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:swift_control/main.dart';
import 'package:swift_control/pages/touch_area.dart';
import 'package:swift_control/utils/keymap/buttons.dart';
import 'package:swift_control/widgets/custom_keymap_selector.dart';
import 'package:swift_control/widgets/logviewer.dart';
import 'package:swift_control/widgets/title.dart';

import '../bluetooth/devices/base_device.dart';
import '../widgets/menu.dart';

class DevicePage extends StatefulWidget {
  const DevicePage({super.key});

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  late StreamSubscription<BaseDevice> _connectionStateSubscription;
  final controller = TextEditingController(text: actionHandler.supportedApp?.name);

  @override
  void initState() {
    super.initState();

    _connectionStateSubscription = connection.connectionStream.listen((state) async {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _connectionStateSubscription.cancel();
    controller.dispose();
    super.dispose();
  }

  final _snackBarMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _snackBarMessengerKey,
      child: PopScope(
        onPopInvokedWithResult: (hello, _) {
          connection.reset();
        },
        child: Scaffold(
          appBar: AppBar(
            title: AppTitle(),
            actions: buildMenuButtons(),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Text(
                  'Devices:\n${connection.devices.joinToString(separator: '\n', transform: (it) {
                    return "${it.device.name ?? it.runtimeType}: ${it.isConnected ? 'Connected' : 'Not connected'}";
                  })}',
                ),
                Divider(color: Theme.of(context).colorScheme.primary, height: 30),
                if (!kIsWeb)
                  DropdownMenu<SupportedApp>(
                    controller: controller,
                    dropdownMenuEntries:
                        SupportedApp.supportedApps
                            .map((app) => DropdownMenuEntry<SupportedApp>(value: app, label: app.name))
                            .toList(),
                    onSelected: (app) async {
                      if (app == null) {
                        return;
                      }
                      controller.text = app.name ?? '';
                      if (app is CustomApp) {
                        settings.setCustomApp(app);
                      }
                      setState(() {});
                    },
                    initialSelection: actionHandler.supportedApp,
                    hintText: 'Keymap',
                  ),

                if (!kIsWeb &&
                    (Platform.isMacOS || Platform.isWindows || kDebugMode) &&
                    actionHandler.supportedApp is CustomApp)
                  ElevatedButton(
                    onPressed: () async {
                      final app = await showCustomKeymapDialog(
                        context,
                        customApp: actionHandler.supportedApp as CustomApp,
                      );
                      if (app != null) {
                        settings.setCustomApp(app);
                      }
                      setState(() {});
                    },
                    child: Text('Customize key map'),
                  ),
                if (!kIsWeb && (Platform.isAndroid || kDebugMode) && actionHandler.supportedApp is CustomApp)
                  ElevatedButton(
                    onPressed: () async {
                      final result = await Navigator.of(
                        context,
                      ).push<bool>(MaterialPageRoute(builder: (_) => TouchAreaSetupPage()));
                      if (result == true && actionHandler.supportedApp is CustomApp) {
                        settings.setCustomApp(actionHandler.supportedApp as CustomApp);
                      }
                      setState(() {});
                    },
                    child: Text('Customize touch areas (optional)'),
                  ),
                Expanded(child: LogViewer()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
