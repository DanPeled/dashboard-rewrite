import 'package:elastic_dashboard/services/globals.dart';
import 'package:elastic_dashboard/services/nt4.dart';
import 'package:elastic_dashboard/services/nt4_connection.dart';
import 'package:elastic_dashboard/widgets/dialog_widgets/dialog_text_input.dart';
import 'package:elastic_dashboard/widgets/nt4_widgets/nt4_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PIDControllerWidget extends StatelessWidget with NT4Widget {
  @override
  String type = 'PIDController';

  late String kpTopicName;
  late String kiTopicName;
  late String kdTopicName;
  late String setpointTopicName;

  NT4Topic? kpTopic;
  NT4Topic? kiTopic;
  NT4Topic? kdTopic;
  NT4Topic? setpointTopic;

  TextEditingController? kpTextController;
  TextEditingController? kiTextController;
  TextEditingController? kdTextController;
  TextEditingController? setpointTextController;

  double kpLastValue = 0.0;
  double kiLastValue = 0.0;
  double kdLastValue = 0.0;
  double setpointLastValue = 0.0;

  PIDControllerWidget(
      {super.key,
      required topic,
      kpTopic,
      kiTopic,
      kdTopic,
      setpointTopic,
      period = Globals.defaultPeriod}) {
    super.topic = topic;
    super.period = period;

    kpTopicName = kpTopic ?? '$topic/p';
    kiTopicName = kiTopic ?? '$topic/i';
    kdTopicName = kdTopic ?? '$topic/d';
    setpointTopicName = setpointTopic ?? '$topic/setpoint';

    init();
  }

  PIDControllerWidget.fromJson(
      {super.key, required Map<String, dynamic> jsonData}) {
    super.topic = jsonData['topic'] ?? '';
    super.period = jsonData['period'] ?? Globals.defaultPeriod;

    kpTopicName = jsonData['kp_topic'] ?? '$topic/p';
    kiTopicName = jsonData['ki_topic'] ?? '$topic/i';
    kdTopicName = jsonData['kd_topic'] ?? '$topic/d';
    setpointTopicName = jsonData['setpoint_topic'] ?? '$topic/setpoint';

    init();
  }

  @override
  Map<String, dynamic>? toJson() {
    return {
      'topic': topic,
      'period': period,
      'kp_topic': kpTopicName,
      'ki_topic': kiTopicName,
      'kd_topic': kdTopicName,
      'setpoint_topic': setpointTopicName,
    };
  }

  @override
  Widget build(BuildContext context) {
    notifier = context.watch<NT4WidgetNotifier?>();
    
    return StreamBuilder(
        stream: subscription?.periodicStream(),
        builder: (context, snapshot) {
          double kP =
              nt4Connection.getLastAnnouncedValue(kpTopicName) as double? ??
                  0.0;
          double kI =
              nt4Connection.getLastAnnouncedValue(kiTopicName) as double? ??
                  0.0;
          double kD =
              nt4Connection.getLastAnnouncedValue(kdTopicName) as double? ??
                  0.0;
          double setpoint =
              nt4Connection.getLastAnnouncedValue(setpointTopicName)
                      as double? ??
                  0.0;

          // Creates the text editing controllers if they are null
          kpTextController ??= TextEditingController(text: kP.toString());
          kiTextController ??= TextEditingController(text: kI.toString());
          kdTextController ??= TextEditingController(text: kD.toString());
          setpointTextController ??=
              TextEditingController(text: setpoint.toString());

          // Updates the text of the text editing controller if the kp value has changed
          if (kP != kpLastValue) {
            kpTextController!.text = kP.toString();
          }
          kpLastValue = kP;

          // Updates the text of the text editing controller if the ki value has changed
          if (kI != kiLastValue) {
            kiTextController!.text = kI.toString();
          }
          kiLastValue = kI;

          // Updates the text of the text editing controller if the kd value has changed
          if (kD != kdLastValue) {
            kdTextController!.text = kD.toString();
          }
          kdLastValue = kD;

          // Updates the text of the text editing controller if the setpoint value has changed
          if (setpoint != setpointLastValue) {
            setpointTextController!.text = setpoint.toString();
          }
          setpointLastValue = setpoint;

          TextStyle labelStyle = Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.bold,
          );

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // kP
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Spacer(),
                  Text('P', style: labelStyle),
                  const Spacer(),
                  Flexible(
                    flex: 5,
                    child: DialogTextInput(
                      textEditingController: kpTextController,
                      initialText: kpTextController!.text,
                      label: 'kP',
                      onSubmit: (value) {
                        bool publishTopic = kpTopic == null;

                        kpTopic ??= nt4Connection.getTopicFromName(kpTopicName);

                        double? data = double.tryParse(value);

                        if (kpTopic == null || data == null) {
                          return;
                        }

                        if (publishTopic) {
                          nt4Connection.nt4Client.publishTopic(kpTopic!);
                        }

                        nt4Connection.updateDataFromTopic(kpTopic!, data);
                      },
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              // kI
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Spacer(),
                  Text('I', style: labelStyle),
                  const Spacer(),
                  Flexible(
                    flex: 5,
                    child: DialogTextInput(
                      textEditingController: kiTextController,
                      initialText: kiTextController!.text,
                      label: 'kI',
                      onSubmit: (value) {
                        bool publishTopic = kiTopic == null;

                        kiTopic ??= nt4Connection.getTopicFromName(kiTopicName);

                        double? data = double.tryParse(value);

                        if (kiTopic == null || data == null) {
                          return;
                        }

                        if (publishTopic) {
                          nt4Connection.nt4Client.publishTopic(kiTopic!);
                        }

                        nt4Connection.updateDataFromTopic(kiTopic!, data);
                      },
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              // kD
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Spacer(),
                  Text('D', style: labelStyle),
                  const Spacer(),
                  Flexible(
                    flex: 5,
                    child: DialogTextInput(
                      textEditingController: kdTextController,
                      initialText: kdTextController!.text,
                      label: 'kD',
                      onSubmit: (value) {
                        bool publishTopic = kdTopic == null;

                        kdTopic ??= nt4Connection.getTopicFromName(kdTopicName);

                        double? data = double.tryParse(value);

                        if (kdTopic == null || data == null) {
                          return;
                        }

                        if (publishTopic) {
                          nt4Connection.nt4Client.publishTopic(kdTopic!);
                        }

                        nt4Connection.updateDataFromTopic(kdTopic!, data);
                      },
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              Row(
                children: [
                  const Spacer(),
                  Text('Setpoint', style: labelStyle),
                  const Spacer(),
                  Flexible(
                    flex: 5,
                    child: DialogTextInput(
                      textEditingController: setpointTextController,
                      initialText: setpointTextController!.text,
                      label: 'Setpoint',
                      onSubmit: (value) {
                        bool publishTopic = setpointTopic == null;

                        setpointTopic ??=
                            nt4Connection.getTopicFromName(setpointTopicName);

                        double? data = double.tryParse(value);

                        if (setpointTopic == null || data == null) {
                          return;
                        }

                        if (publishTopic) {
                          nt4Connection.nt4Client.publishTopic(setpointTopic!);
                        }

                        nt4Connection.updateDataFromTopic(setpointTopic!, data);
                      },
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ],
          );
        });
  }
}