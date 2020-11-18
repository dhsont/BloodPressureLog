import 'package:bloodpressurelog/components/pressureLevelBar.dart';
import 'package:bloodpressurelog/utils/AppLocalization.dart';
import 'package:bloodpressurelog/utils/database/controllers/measurementService.dart';
import 'package:bloodpressurelog/utils/database/models/measurement.dart';
import 'package:commons/commons.dart';
import 'package:flutter/material.dart';
import 'package:bloodpressurelog/components/pageSample.dart' as components;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'constants.dart';

class UpdateRecord extends StatefulWidget {
  final Measurement measurement;

  UpdateRecord({Key key, @required this.measurement}) : super(key: key);

  @override
  _UpdateRecordState createState() => _UpdateRecordState();
}

class _UpdateRecordState extends State<UpdateRecord> {
  final TextEditingController noteController = new TextEditingController();
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();
  static int sysRecord = 100, diaRecord = 70, bpmRecord = 60;
  static DateTime dateTimeRecord = DateTime.now();

  @override
  void initState() {
    super.initState();

    sysRecord = widget.measurement.sysMeasurement;
    diaRecord = widget.measurement.diaMeasurement;
    bpmRecord = widget.measurement.bpmMeasurement;
    noteController.text = widget.measurement.notesMeasurement;
    dateTimeRecord = widget.measurement.dateTimeMeasurement;

    dateTimeRecord = DateTime.now();
  }

  createBody(BuildContext context) {
    return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        children: [
          kbanner,
          SizedBox(height: 20),
          PressureLevelBar(sysRecord: sysRecord, diaRecord: diaRecord),
          SizedBox(height: 10),
          Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 10),
                Container(
                    height: 200,
                    child: ListView(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        children: [
                          Column(children: [
                            Text(AppLocalizations.of(context).translate("sys"),
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("mmHg",
                                style: TextStyle(fontStyle: FontStyle.italic)),
                            SizedBox(height: 10),
                            NumberPicker.integer(
                                initialValue: sysRecord,
                                minValue: 20,
                                maxValue: 200,
                                onChanged: (value) {
                                  sysRecord = value;
                                  setState(() {});
                                }),
                          ]),
                          Column(children: [
                            Text(AppLocalizations.of(context).translate("dia"),
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("mmHg",
                                style: TextStyle(fontStyle: FontStyle.italic)),
                            SizedBox(height: 10),
                            NumberPicker.integer(
                                initialValue: diaRecord,
                                minValue: 20,
                                maxValue: 200,
                                onChanged: (value) {
                                  diaRecord = value;
                                  setState(() {});
                                }),
                          ]),
                          Column(children: [
                            Text(AppLocalizations.of(context).translate("bpm"),
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("bpm",
                                style: TextStyle(fontStyle: FontStyle.italic)),
                            SizedBox(height: 10),
                            NumberPicker.integer(
                                initialValue: bpmRecord,
                                minValue: 20,
                                maxValue: 200,
                                onChanged: (value) {
                                  bpmRecord = value;
                                  setState(() {});
                                }),
                          ]),
                        ])),
                SizedBox(height: 20),
                Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: RaisedButton(
                        onPressed: () {
                          DatePicker.showDateTimePicker(context,
                              showTitleActions: true, onChanged: (date) {
                            setState(() {
                              dateTimeRecord = date;
                            });
                          }, onConfirm: (date) {
                            setState(() {
                              dateTimeRecord = date;
                            });
                          }, currentTime: dateTimeRecord);
                        },
                        child: ListTile(
                          leading: Icon(Icons.calendar_today),
                          title: Text(AppLocalizations.of(context)
                              .translate("selectDateTime")),
                          subtitle: Text(DateFormat("yyyy-MM-dd HH:mm:ss")
                              .format(dateTimeRecord)),
                        ))),
              ],
            ),
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: noteController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            onSaved: (String val) {},
            decoration: InputDecoration(
              icon: const Icon(Icons.note_add),
              labelText: AppLocalizations.of(context).translate("note"),
            ),
          ),
          SizedBox(height: 20),
          RoundedLoadingButton(
              child: Text(AppLocalizations.of(context).translate("confirm"),
                  style: TextStyle(color: Colors.white)),
              controller: _btnController,
              onPressed: () async {
                try {
                  widget.measurement.bpmMeasurement = bpmRecord;
                  widget.measurement.dateTimeMeasurement = dateTimeRecord;
                  widget.measurement.diaMeasurement = diaRecord;
                  widget.measurement.notesMeasurement = noteController.text;
                  widget.measurement.sysMeasurement = sysRecord;

                  MeasurementService measurementService =
                      new MeasurementService();

                  var result =
                      await measurementService.update(widget.measurement);

                  if (result) {
                    setState(() {
                      _btnController.success();
                    });
                    successDialog(
                      context,
                      AppLocalizations.of(context)
                          .translate("updateConfirmation"),
                      title: "",
                      neutralText:
                          AppLocalizations.of(context).translate("confirm"),
                      neutralAction: () {
                        setState(() {
                          _btnController.reset();
                        });

                        Navigator.of(context).pop();
                      },
                    );
                    await Future.delayed(const Duration(seconds: 3));
                    setState(() {
                      _btnController.reset();
                    });
                  } else {
                    setState(() {
                      _btnController.error();
                    });
                    await Future.delayed(const Duration(seconds: 3));
                    setState(() {
                      _btnController.reset();
                    });
                  }
                } catch (e) {
                  setState(() {
                    _btnController.error();
                  });
                  await Future.delayed(const Duration(seconds: 3));
                  setState(() {
                    _btnController.reset();
                  });
                }
              }),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return components.Page(
        name: "updateValue",
        body: createBody(context),
        showBottomBar: false,
        appBarActions: [
          widget.measurement != null
              ? IconButton(
                  icon: Icon(Icons.delete, color: Colors.white),
                  onPressed: () async {
                    bool result =
                        await MeasurementService().delete(widget.measurement);
                    if (result) {
                      Navigator.pop(context);
                    }
                  },
                )
              : Container()
        ]);
  }
}