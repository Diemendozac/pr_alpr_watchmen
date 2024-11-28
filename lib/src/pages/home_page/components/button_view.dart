
import 'package:flutter/material.dart';

import '../../../theme/watchman_app_theme.dart';

class ButtonView extends StatelessWidget {
  const ButtonView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 24, right: 24, top: 0, bottom: 0),
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              GestureDetector(
                child: buildListButtonDecoration(context),
                onTap: () {
                  Navigator.of(context).pushNamed('vehicle_management');
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildListButtonDecoration(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: WatchmanAppTheme.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: WatchmanAppTheme.grey.withOpacity(0.2),
              offset: const Offset(1.1, 1.1),
              blurRadius: 10.0),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: SizedBox(
              height: 74,
              child: AspectRatio(
                aspectRatio: 1.714,
                child: Image.asset('assets/images/motorcycle.png')
              ),
            ),
          ),
          Flexible(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 16,
                      ),
                      child: Text(
                        "Gestionar Vehículos",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: WatchmanAppTheme.fontName,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          letterSpacing: 0.0,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    bottom: 12,
                    top: 4,
                    right: 16,
                  ),
                  child: Text(
                      "Recomendamos usar esta funcionalidad\r\nal final de cada día",
                      textAlign: TextAlign.left,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(fontSize: 10, fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
