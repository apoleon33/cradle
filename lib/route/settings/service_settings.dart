import 'package:cradle/widgets/setting_page.dart';
import 'package:flutter/material.dart';
import 'package:cradle/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceSetting extends StatefulWidget {
  const ServiceSetting({super.key});

  @override
  State<StatefulWidget> createState() => _ServiceSettingState();
}

class _ServiceSettingState extends State<ServiceSetting> {
  Service? _chosenService = Service.spotify;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final prefs = await SharedPreferences.getInstance();
      int serviceNumber = prefs.getInt('service') ?? 0;
      setState(() {
        _chosenService = Service.values[serviceNumber];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> radioButtonList = createRadioTiles();
    return SettingPage(
      name: "Default music provider",
      childs: radioButtonList,
    );
  }

  List<Widget> createRadioTiles() {
    List<Widget> radioButtonList = [];
    for (var element in Service.values) {
      radioButtonList.add(
        RadioListTile(
          title: Text(element.fullName),
          value: element,
          groupValue: _chosenService,
          onChanged: (Service? service) async {
            final pref = await SharedPreferences.getInstance();

            setState(() {
              _chosenService = service;
            });
            await pref.setInt('service', service?.index ?? 0);
          },
        ),
      );
    }
    return radioButtonList;
  }
}
