import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> abrirEnlaceUtil(BuildContext context, String valor) async {
  try {
    final Uri url = Uri.parse(valor);
    await launchUrl(url);
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se puede abrir el enlace'),
        ),
      );
    }
  }
}
