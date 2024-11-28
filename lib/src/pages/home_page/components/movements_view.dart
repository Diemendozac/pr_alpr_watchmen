import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MovementsView extends StatelessWidget {

  const MovementsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 18),
      child: Skeletonizer(
        enabled: false,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            //color: FitnessAppTheme.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: const Color(0xFF3A5160).withOpacity(0.15),
                  offset: const Offset(1.1, 1.1),
                  blurRadius: 10.0),
            ],
          ),
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 16, left: 16, right: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 4, bottom: 8, top: 16),
                      child: Text(
                        'Estadísticas',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            //fontFamily: FitnessAppTheme.fontName,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            letterSpacing: -0.1,
                            color: Colors.black54),
                        //color: FitnessAppTheme.darkText),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 4, bottom: 3),
                              child: Text(
                                '52',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  //fontFamily: FitnessAppTheme.fontName,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 32,
                                  color: Colors.indigo,
                                  //color: FitnessAppTheme.nearlyDarkBlue,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Vehículos Almacenados',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            //fontFamily: FitnessAppTheme.fontName,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            letterSpacing: 0.0,
                            color: Colors.indigo,
                            //color: FitnessAppTheme.nearlyDarkBlue,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
                child: Container(
                  height: 2,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF2F3F8),
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 24, right: 24, top: 8, bottom: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildFirstStat(),
                    _buildMidStat(),
                    _buildLastStat()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Expanded _buildFirstStat() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            '214',
            textAlign: TextAlign.center,
            style: TextStyle(
              //fontFamily: FitnessAppTheme.fontName,
              fontWeight: FontWeight.w500,
              fontSize: 16,
              letterSpacing: -0.2,
              color: Color(0xFF253840),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              'Scanners\r\nrealizados',
              textAlign: TextAlign.left,
              style: TextStyle(
                //fontFamily: FitnessAppTheme.fontName,
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: const Color(0xFF3A5160).withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Expanded _buildMidStat() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text(
                '27.3 BMI',
                textAlign: TextAlign.center,
                style: TextStyle(
                  //fontFamily: FitnessAppTheme.fontName,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  letterSpacing: -0.2,
                  color: Color(0xFF253840),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'Overweight',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    //fontFamily: FitnessAppTheme.fontName,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: const Color(0xFF3A5160).withOpacity(0.5),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Expanded _buildLastStat() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              const Text(
                '3',
                //textAlign: TextAlign.right,
                style: TextStyle(
                  //fontFamily: FitnessAppTheme.fontName,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  letterSpacing: -0.2,
                  color: Color(0xFF253840),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'Visitantes\r\nRegistrados',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    //fontFamily: FitnessAppTheme.fontName,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: const Color(0xFF3A5160).withOpacity(0.5),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
