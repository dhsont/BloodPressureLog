import 'package:bloodpressurelog/constants.dart';
import 'package:bloodpressurelog/utils/AppLocalization.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class PressureLevelBar extends StatefulWidget {
  final int sysRecord, diaRecord;

  PressureLevelBar({Key key, this.sysRecord, this.diaRecord}) : super(key: key);

  @override
  _PressureLevelBarState createState() => _PressureLevelBarState();
}

class _PressureLevelBarState extends State<PressureLevelBar> {
  static String statusLabel = "regular";
  static int selectedIndex = 1;

  calculateLevel() {
    setState(() {
      if (widget.sysRecord < 90 && widget.diaRecord < 60) {
        selectedIndex = 0;
        statusLabel = "hypotension";
      } else if ((widget.sysRecord >= 90 && widget.sysRecord < 120) &&
          (widget.diaRecord >= 60 && widget.diaRecord < 80)) {
        selectedIndex = 1;
        statusLabel = "regular";
      } else if ((widget.sysRecord >= 120 && widget.sysRecord <= 130) &&
          (widget.diaRecord < 80)) {
        selectedIndex = 2;
        statusLabel = "elevated";
      } else if ((widget.sysRecord > 130 && widget.sysRecord <= 140) &&
          (widget.diaRecord >= 80 && widget.diaRecord <= 90)) {
        selectedIndex = 3;
        statusLabel = "hypertensionstage1";
      } else if ((widget.sysRecord > 140 && widget.sysRecord <= 180) &&
          (widget.diaRecord > 90 && widget.diaRecord <= 120)) {
        selectedIndex = 4;
        statusLabel = "hypertensionstage2";
      } else if ((widget.sysRecord > 180) && widget.diaRecord > 120) {
        selectedIndex = 5;
        statusLabel = "hypertensivecrisis";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    calculateLevel();
    return Column(children: [
      Center(
          child: Text(AppLocalizations.of(context).translate(statusLabel),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
      SizedBox(height: 5),
      StepProgressIndicator(
          totalSteps: 6,
          padding: 0,
          size: 40,
          currentStep: 2,
          selectedColor: Colors.transparent,
          // ignore: missing_return
          customStep: (index, color, __) {
            if (index == selectedIndex) {
              return Container(
                  color: color,
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                  ));
            }
          },
          // ignore: missing_return
          customColor: (index) {
            switch (index) {
              case 0:
                return kHypotensionColor;
                break;
              case 1:
                return kRegularColor;
                break;
              case 2:
                return kElevatedColor;
                break;
              case 3:
                return kHypertension1Color;
                break;
              case 4:
                return kHypertension2Color;
                break;
              case 5:
                return kHypertensionCrisisColor;
                break;
            }
          })
    ]);
  }
}
