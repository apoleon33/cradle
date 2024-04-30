import 'package:cradle/album.dart';
import 'package:cradle/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceButton extends StatefulWidget {
  final Album album;

  const ServiceButton({super.key, required this.album});

  @override
  State<StatefulWidget> createState() => _ServiceButtonState();
}

class _ServiceButtonState extends State<ServiceButton> {
  Service service = Service.spotify;
  Uri _url = Uri.parse("https://example.com");

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _getCurrentService();
    });
  }

  Future<void> _getCurrentService() async {
    final prefs = await SharedPreferences.getInstance();
    int serviceNumber = prefs.getInt('service') ?? 0;
    if (mounted) {
      setState(() {
        service = Service.values[serviceNumber];
      });
    }
    String initialUrl = service.searchUrl;
    String url = Uri.encodeFull(
        '$initialUrl${widget.album.name} - ${widget.album.artist}');
    _url = Uri.parse(url);
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      icon: SvgPicture.asset(
        service.iconPath,
        color: Theme.of(context).colorScheme.onPrimary,
        width: 18,
        height: 18,
      ),
      onPressed: _launchUrl,
      label: Text(
        "Listen on ${service.fullName}",
      ),
    );
  }
}
