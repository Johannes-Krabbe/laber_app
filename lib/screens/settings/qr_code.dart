import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:flutter_iconoir_ttf/flutter_iconoir_ttf.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laber_app/state/bloc/auth_bloc.dart';
import 'package:share_plus/share_plus.dart';

class QrCode extends StatefulWidget {
  const QrCode({super.key});

  @override
  State<QrCode> createState() => _QrCodeState();
}

class _QrCodeState extends State<QrCode> {
  double? hue;
  late AuthBloc authBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authBloc = context.read<AuthBloc>();
  }

  _getLink() {
    return "https://laber.app/#qr/${authBloc.state.meUser!.id}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: hue != null
                    ? HSLColor.fromAHSL(1, hue!, 1, 0.6).toColor()
                    : Colors.white,
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                height: 200,
                width: 200,
                child: PrettyQrView.data(
                  data: _getLink(),
                  errorCorrectLevel: QrErrorCorrectLevel.H,
                  decoration: const PrettyQrDecoration(
                    image: PrettyQrDecorationImage(
                      scale: 0.25,
                      image: Svg(
                        'assets/logo.svg',
                        scale: 5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 75,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[600],
                  ),
                  child: IconButton(
                    icon: const Icon(
                      IconoirIconsBold.shareIos,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Share.share(_getLink());
                    },
                  ),
                ),
                const SizedBox(width: 20),
                Container(
                  width: 75,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[600],
                  ),
                  child: IconButton(
                    icon: const Icon(
                      IconoirIconsBold.copy,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: _getLink()))
                          .then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.grey[800],
                          content: const Text(
                            "Contact link copied to clipboard",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ));
                      });
                    },
                  ),
                ),
                const SizedBox(width: 20),
                Container(
                  width: 75,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[600],
                  ),
                  child: IconButton(
                    icon: const Icon(
                      IconoirIconsBold.palette,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        // random
                        hue = Random().nextInt(360).toDouble();
                      });
                    },
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(30),
              child: const Text(
                'Share your QR code and link only with people you trust. If you share it, others can start a chat with you.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
