import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:network_tables/network_tables41.dart';
import 'dart:developer' as dev;

import 'package:network_tables_client/config.dart';
import 'package:network_tables_client/constants.dart';
import 'package:yaml/yaml.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Necessary initialization for package:media_kit.
  MediaKit.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      //theme: ThemeData.dark(),
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: Colors.black,
        ),
        //colorScheme: ColorScheme(brightness: brightness, primary: primary, onPrimary: onPrimary, secondary: secondary, onSecondary: onSecondary, error: error, onError: onError, surface: surface, onSurface: onSurface),
        iconTheme: const IconThemeData(
          color: Colors.red,
        ),
        primaryIconTheme: const IconThemeData(
          color: Colors.red,
        ),
        dividerColor: Colors.black,
        textButtonTheme: const TextButtonThemeData(
          style: ButtonStyle(
            textStyle: WidgetStatePropertyAll(
              TextStyle(
                color: Colors.white,
              ),
            ),
            foregroundColor: WidgetStatePropertyAll(Colors.red),
          ),
        ),
        sliderTheme: const SliderThemeData(
          activeTrackColor: Colors.red,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          //focusColor: Colors.white,
          //hoverColor: Colors.white,
          contentPadding: EdgeInsets.all(20),
          //border: OutlineInputBorder(),
          constraints: BoxConstraints(
            minWidth: 100.0,
            maxWidth: 100.0,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
              width: 2.0,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
              width: 2.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
              width: 2.0,
            ),
          ),
          labelStyle: TextStyle(
            color: Colors.white,
          ),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(color: Colors.white),
        ),
      ),
      home: const MyHomePage(title: "Team RED!"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //late Network_Tables _networkTables;
  late Network_Tables41 _network_tables41;
  Map<String, dynamic> _entries = {};
  Alliance _alliance = Alliance.red;
  int _stationNumber = 0;
  double _matchTime = 0;
  bool _isAuto = false;
  bool _enabled = false;
  Mode _mode = Mode.disconnected;
  bool _fmsAttached = false;
  bool _dsAttached = false;
  double totalPower = 0.0;
  String _modeText = "";
  List<String> _autos = [defaultSelectedAutoString];
  String _selectedAuto = "";
  bool _connected = false;
  String _cam1Raw = "";
  String _cam1Processed = "";
  String _cam2Raw = "";
  String _cam2Processed = "";
  String _limelightProcessed = "";
  double _batteryVoltage = 0.0;
  //double _x = 0.0;
  //double _y = 0.0;
  Config _config = Config();

  double turningMotorPIDP = 0.0;
  double turningMotorPIDI = 0.0;
  double turningMotorPIDD = 0.0;

  TextEditingController textEditingControllerTurnP = TextEditingController();
  TextEditingController textEditingControllerTurnI = TextEditingController();
  TextEditingController textEditingControllerTurnD = TextEditingController();

  double driveMotorPIDP = 0.0;
  double driveMotorPIDI = 0.0;
  double driveMotorPIDD = 0.0;

  TextEditingController textEditingControllerDriveP = TextEditingController();
  TextEditingController textEditingControllerDriveI = TextEditingController();
  TextEditingController textEditingControllerDriveD = TextEditingController();

  // Auto
  double autoDriveMotorPIDP = 0.0;
  double autoDriveMotorPIDI = 0.0;
  double autoDriveMotorPIDD = 0.0;

  TextEditingController textEditingControllerAutoDriveP =
      TextEditingController();
  TextEditingController textEditingControllerAutoDriveI =
      TextEditingController();
  TextEditingController textEditingControllerAutoDriveD =
      TextEditingController();

  double autoTurnPIDP = 0.0;
  double autoTurnPIDI = 0.0;
  double autoTurnPIDD = 0.0;

  TextEditingController textEditingControllerAutoTurnP =
      TextEditingController();
  TextEditingController textEditingControllerAutoTurnI =
      TextEditingController();
  TextEditingController textEditingControllerAutoTurnD =
      TextEditingController();

  bool _shooterHasTarget = false;
  String _robotStatus = "";

  List<double> fieldRobotValues = [0, 0, 0];
  List<double> photonEstimatedValus = [0, 0, 0];
  List<double> limeLightEstimatedValues = [0, 0, 0];

  ScrollController scrollController = ScrollController();

  TextEditingController textEditingControllerTime =
      TextEditingController(text: "0");

  // Create a [Player] to control playback.
  late final player = Player();
  // Create a [VideoController] to handle video output from [Player].
  late final controller = VideoController(player);

  // PhotonVision
  bool _photonVisionCam1HasTarget = false;

  bool _photonVisionEnableCam1 = false;
  bool _photonVisionEnableCam2 = false;

  // Camera 1
  double _photonVisionCam1XOffset = 0.0;
  double _photonVisionCam1YOffset = 0.0;
  double _photonVisionCam1Height = 0.0;
  double _photonVisionCam1Rotation = 0.0;

  TextEditingController textEditingControllerCamera1X = TextEditingController();
  TextEditingController textEditingControllerCamera1Y = TextEditingController();
  TextEditingController textEditingControllerCamera1Height =
      TextEditingController();
  TextEditingController textEditingControllerCamera1Rotation =
      TextEditingController();

  // Camera 2
  double _photonVisionCam2XOffset = 0.0;
  double _photonVisionCam2YOffset = 0.0;
  double _photonVisionCam2Height = 0.0;
  double _photonVisionCam2Rotation = 0.0;

  TextEditingController textEditingControllerCamera2X = TextEditingController();
  TextEditingController textEditingControllerCamera2Y = TextEditingController();
  TextEditingController textEditingControllerCamera2Height =
      TextEditingController();
  TextEditingController textEditingControllerCamera2Rotation =
      TextEditingController();

  // Shooter
  double _shooterP = 0.0;
  double _shooterI = 0.0;
  double _shooterD = 0.0;

  TextEditingController textEditingControllerShooterP = TextEditingController();
  TextEditingController textEditingControllerShooterI = TextEditingController();
  TextEditingController textEditingControllerShooterD = TextEditingController();

  double _hoodP = 0.0;
  double _hoodI = 0.0;
  double _hoodD = 0.0;

  TextEditingController textEditingControllerHoodP = TextEditingController();
  TextEditingController textEditingControllerHoodI = TextEditingController();
  TextEditingController textEditingControllerHoodD = TextEditingController();

  double _turretP = 0.0;
  double _turretI = 0.0;
  double _turretD = 0.0;

  TextEditingController textEditingControllerTurretP = TextEditingController();
  TextEditingController textEditingControllerTurretI = TextEditingController();
  TextEditingController textEditingControllerTurretD = TextEditingController();

  NetworkInfo _networkInfo = NetworkInfo();
  String _localAddress = "";
  TextEditingController _textEditingControllerRobotIP = TextEditingController();

  /*void setRobotState() {
    if (_isAuto == true) {
      _mode = Mode.auto;
      _modeText = "Auto";
    } else if (_enabled == true && _isAuto == false) {
      _mode = Mode.teleop;
      _modeText = "Teleop";
    } else if (_enabled == false && _isAuto == false) {
      _mode = Mode.disabled;
      _modeText = "Disabled";
    }
  }*/

  void connect() async {
    //_localAddress = await getLocalHostAddress();
    // String response = await rootBundle.loadString('config.yaml');
    // var yaml = await loadYaml(response);

    // setState(() {
    //   _config = Config.fromYAML(yaml);
    //   _textEditingControllerRobotIP.text = _config.robotIPAddress;
    // });

    Map<String, String> publications = {
      networkTablesSelectAuto: "string",
      gotoPosition: "int",
      networkTablesPhotonVisionEnableCam1: "boolean",
      networkTablesPhotonVisionEnableCam2: "boolean",
      turningMotorsPIDP: "double",
      turningMotorsPIDI: "double",
      turningMotorsPIDD: "double",
      driveMotorsPIDP: "double",
      driveMotorsPIDI: "double",
      driveMotorsPIDD: "double",
      ntAutoDriveP: "double",
      ntAutoDriveI: "double",
      ntAutoDriveD: "double",
      ntAutoTurnP: "double",
      ntAutoTurnI: "double",
      ntAutoTurnD: "double",
      ntPhotonVisionCam1XOffset: "double",
      ntPhotonVisionCam1YOffset: "double",
      ntPhotonVisionCam1Height: "double",
      ntPhotonVisionCam1Rotation: "double",
      ntPhotonVisionCam2XOffset: "double",
      ntPhotonVisionCam2YOffset: "double",
      ntPhotonVisionCam2Height: "double",
      ntPhotonVisionCam2Rotation: "double",
      ntShooterP: "double",
      ntShooterI: "double",
      ntShooterD: "double",
      ntHoodP: "double",
      ntHoodI: "double",
      ntHoodD: "double",
    };

    _network_tables41 = Network_Tables41(
      _config.robotIPAddress,
      5810,
      "4219",
      [
        networkTablesAutoOptionsPath,
        networkTablesBatteryPath,
        networkTablesAlliancePath,
        networkTablesFMSAttached,
        networkTablesDSAttached,
        networkTablesMatchTimePath,
        //_config.matchTimePath,
        networkTablesEnabledPath,
        networkTablesMatchNumberPath,
        networkTablesStationNumberPath,
        networkTablesEventNamePath,
        networkTablesPDPTotalCurrent,
        networkTablesPhotonVisionCameraPublisherProcessed,
        networkTablesPhotonVisionCameraPublisherRaw,
        networkTablesSelectAuto,
        networkTablesActiveAuto,
        fieldRobot,
        networkTablesStationNumber,
        networkTablesEnabled,
        //ntPhotonVisionEstimator,
        networkTablesPhotonVisionCam1HasTargetPath,
        networkTablesLimeLightVideoPath,
        networkTablesPhotonVisionCamera2PublisherProcessed,
        networkTablesPhotonVisionEnableCam1,
        networkTablesPhotonVisionEnableCam2,
        shooterHasTarget,
        robotStatus,
        turningMotorsPIDP,
        turningMotorsPIDI,
        turningMotorsPIDD,
        driveMotorsPIDP,
        driveMotorsPIDI,
        driveMotorsPIDD,
        ntAutoDriveP,
        ntAutoDriveI,
        ntAutoDriveD,
        ntAutoTurnP,
        ntAutoTurnI,
        ntAutoTurnD,
        ntPhotonVisionCam1XOffset,
        ntPhotonVisionCam1YOffset,
        ntPhotonVisionCam1Height,
        ntPhotonVisionCam1Rotation,
        ntPhotonVisionCam2XOffset,
        ntPhotonVisionCam2YOffset,
        ntPhotonVisionCam2Height,
        ntPhotonVisionCam2Rotation,
        ntShooterP,
        ntShooterI,
        ntShooterD,
        ntHoodP,
        ntHoodI,
        ntHoodD,
      ],
      publications,
      onConnected: () {
        setState(() {
          _connected = true;
        });
      },
      onValueReceived: (name, value) {
        //dev.log("onValueReceivedCalled name $name value $value");

        switch (name) {
          case networkTablesEnabled:
            dev.log("networkTablesEnabled called $value");
            setState(() {
              _enabled = value;
            });

            break;
          case networkTablesStationNumber:
            dev.log("networkTablesStationNumber called $value");
            break;
          case networkTablesActiveAuto:
            dev.log("networkTablesActiveAuto called $value");
            break;
          case networkTablesBatteryPath:
            _batteryVoltage = value;
            break;
          case networkTablesSelectAuto:
            dev.log("networkTablesSelectedAuto called ${value}");
            setState(() {
              _selectedAuto = value;
            });

            break;
          case networkTablesAlliancePath:
            setState(() {
              if (value) {
                _alliance = Alliance.red;
              } else {
                _alliance = Alliance.blue;
              }
            });
            break;
          case networkTablesFMSAttached:
            setState(() {
              if (value) {
                _fmsAttached = true;
              } else {
                _fmsAttached = false;
              }
            });
            break;
          case networkTablesDSAttached:
            setState(() {
              if (value) {
                _dsAttached = true;
              } else {
                _dsAttached = false;
              }
            });
            break;
          case networkTablesAutoOptionsPath:
            setState(() {
              for (String auto in value) {
                _autos.add(auto);
              }
            });
            break;
          case networkTablesMatchTimePath:
            //case matchTime:
            setState(() {
              _matchTime = value;
              textEditingControllerTime.text = "${_matchTime.round()}";
            });
            break;
          case networkTablesStationNumberPath:
            dev.log("networkTablesStationNumberPath is $value");
            setState(() {
              _stationNumber = value;
            });
            break;
          case networkTablesPDPTotalCurrent:
            setState(() {
              totalPower = value;
            });
            break;
          case networkTablesPhotonVisionCameraPublisherProcessed:
            dev.log(
                "networkTablesPhotonVisionCameraPublisherProcessed: ${value[0]}");

            String val = value[0];

            if (val.contains(".local") && val.contains(":1188")) {
              val = val.replaceRange(val.indexOf("http"), val.indexOf(":1188"),
                  "http://127.0.0.1");
            } else if (val.contains(".local") && val.contains(":1184")) {
              val = val.replaceRange(val.indexOf("http"), val.indexOf(":1184"),
                  "http://127.0.0.1");
            }

            dev.log("-------------> $val");

            setState(() {
              //_cam1Processed = value[0].replaceFirst("mjpg:", "");
              _cam1Processed = val.replaceFirst("mjpg:", "");
            });
            break;
          case networkTablesPhotonVisionCamera2PublisherProcessed:
            dev.log(
                "networkTablesPhotonVisionCamera2PublisherProcessed: ${value[0]}");

            String val = value[0];

            if (val.contains(".local") && val.contains(":1188")) {
              val = val.replaceRange(val.indexOf("http"), val.indexOf(":1188"),
                  "http://127.0.0.1");
            } else if (val.contains(".local") && val.contains(":1184")) {
              val = val.replaceRange(val.indexOf("http"), val.indexOf(":1184"),
                  "http://127.0.0.1");
            }

            dev.log("-------------> $val");

            setState(() {
              //_cam1Processed = value[0].replaceFirst("mjpg:", "");
              _cam2Processed = val.replaceFirst("mjpg:", "");
            });
            break;
          case networkTablesPhotonVisionCameraPublisherRaw:
            dev.log("networkTablesPhotonVisionCameraPublisherRaw: ${value[0]}");

            String val = value[0];

            if (val.contains(".local") && val.contains("1187")) {
              val = val.replaceRange(val.indexOf("http"), val.indexOf(":1187"),
                  "http://127.0.0.1");
            } else if (val.contains(".local") && val.contains("1183")) {
              val = val.replaceRange(val.indexOf("http"), val.indexOf(":1183"),
                  "http://127.0.0.1");
            }

            dev.log("-------------> $val");

            setState(() {
              //_cam1Raw = value[0].replaceFirst("mjpg:", "");
              _cam1Raw = val.replaceFirst("mjpg:", "");
            });
            break;
          case turningMotorsPIDP:
            //dev.log("received the value for turningMotorsPIDP $value");
            setState(() {
              turningMotorPIDP = value;
              textEditingControllerTurnP.text = "$turningMotorPIDP";
            });
            break;
          case turningMotorsPIDI:
            //dev.log("received the value for turningMotorsPIDI $value");
            setState(() {
              turningMotorPIDI = value;
              textEditingControllerTurnI.text = "$value";
            });
            break;
          case turningMotorsPIDD:
            //dev.log("received the value for turningMotorsPIDD $value");
            setState(() {
              turningMotorPIDD = value;
              textEditingControllerTurnD.text = "$value";
            });
            break;
          case driveMotorsPIDP:
            //dev.log("received the value for driveMotorsPIDP $value");
            setState(() {
              driveMotorPIDP = value;
              textEditingControllerDriveP.text = "$driveMotorPIDP";
            });
            break;
          case driveMotorsPIDI:
            //dev.log("received the value for driveMotorsPIDI $value");
            setState(() {
              driveMotorPIDI = value;
              textEditingControllerDriveI.text = "$driveMotorPIDI";
            });
            break;
          case driveMotorsPIDD:
            //dev.log("received the value for driveMotorsPIDD $value");
            setState(() {
              driveMotorPIDD = value;
              textEditingControllerDriveD.text = "$driveMotorPIDD";
            });
            break;
          case fieldRobot:
            //dev.log("received the value for fieldRobot $value");

            setState(() {
              fieldRobotValues[0] = value[0];
              fieldRobotValues[1] = value[1];
              fieldRobotValues[2] = value[2];
            });

            break;
          case ntPhotonVisionEstimator:
            dev.log(
                "-----------received the value for ntPhotonVisionEstimator $value");

            /*setState(() {
              photonEstimatedValus = [
                value[0] as double,
                value[1] as double,
                value[2] as double,
              ];
            });*/

            break;
          case networkTablesPhotonVisionCam1HasTargetPath:
            //dev.log(
            //"-----------received the value for networkTablesPhotonVisionCam1HasTargetPath $value");
            setState(() {
              _photonVisionCam1HasTarget = value;
            });
            break;
          case networkTablesLimeLightVideoPath:
            setState(() {
              _limelightProcessed = value[0];
            });
            break;
          case networkTablesPhotonVisionEnableCam1:
            // _photonVisionEnableCam1 = value;
            //dev.log("networkTablesPhotonVisionEnableCam1: $value");
            setState(() {
              _photonVisionEnableCam1 = value;
            });
            break;
          case networkTablesPhotonVisionEnableCam2:
            // _photonVisionEnableCam2 = value;
            //dev.log("networkTablesPhotonVisionEnableCam2: $value");
            setState(() {
              _photonVisionEnableCam2 = value;
            });
            break;
          case shooterHasTarget:
            setState(() {
              _shooterHasTarget = value;
            });
            break;
          case robotStatus:
            _robotStatus = value;
            break;
          case ntAutoDriveP:
            setState(() {
              autoDriveMotorPIDP = value;
              textEditingControllerAutoDriveP.text = "$autoDriveMotorPIDP";
            });
            break;
          case ntAutoDriveI:
            setState(() {
              autoDriveMotorPIDI = value;
              textEditingControllerAutoDriveI.text = "$autoDriveMotorPIDI";
            });
            break;
          case ntAutoDriveD:
            setState(() {
              autoDriveMotorPIDD = value;
              textEditingControllerAutoDriveD.text = "$autoDriveMotorPIDD";
            });
            break;
          case ntAutoTurnP:
            setState(() {
              autoTurnPIDP = value;
              textEditingControllerAutoTurnP.text = "$autoTurnPIDP";
            });
            break;
          case ntAutoTurnI:
            setState(() {
              autoTurnPIDI = value;
              textEditingControllerAutoTurnI.text = "$autoTurnPIDI";
            });
            break;
          case ntAutoTurnD:
            setState(() {
              autoTurnPIDD = value;
              textEditingControllerAutoTurnD.text = "$autoTurnPIDD";
            });
            break;
          case ntPhotonVisionCam1XOffset:
            setState(() {
              _photonVisionCam1XOffset = value;
              textEditingControllerCamera1X.text = "$_photonVisionCam1XOffset";
            });
            break;
          case ntPhotonVisionCam1YOffset:
            setState(() {
              _photonVisionCam1YOffset = value;
              textEditingControllerCamera1Y.text = "$_photonVisionCam1YOffset";
            });
            break;
          case ntPhotonVisionCam1Height:
            setState(() {
              _photonVisionCam1Height = value;
              textEditingControllerCamera1Height.text =
                  "$_photonVisionCam1Height";
            });
            break;
          case ntPhotonVisionCam1Rotation:
            setState(() {
              _photonVisionCam1Rotation = value;
              textEditingControllerCamera1Rotation.text =
                  "$_photonVisionCam1Rotation";
            });
            break;
          case ntPhotonVisionCam2XOffset:
            setState(() {
              _photonVisionCam2XOffset = value;
              textEditingControllerCamera2X.text = "$_photonVisionCam2XOffset";
            });
            break;
          case ntPhotonVisionCam2YOffset:
            setState(() {
              _photonVisionCam2YOffset = value;
              textEditingControllerCamera2Y.text = "$_photonVisionCam2YOffset";
            });
            break;
          case ntPhotonVisionCam2Height:
            setState(() {
              _photonVisionCam2Height = value;
              textEditingControllerCamera2Height.text =
                  "$_photonVisionCam2Height";
            });
            break;
          case ntPhotonVisionCam2Rotation:
            setState(() {
              _photonVisionCam2Rotation = value;
              textEditingControllerCamera2Rotation.text =
                  "$_photonVisionCam2Rotation";
            });
            break;
          case ntShooterP:
            setState(() {
              _shooterP = value;
              textEditingControllerShooterP.text = "$_shooterP";
            });
            break;
          case ntShooterI:
            setState(() {
              _shooterI = value;
              textEditingControllerShooterI.text = "$_shooterI";
            });
            break;
          case ntShooterD:
            setState(() {
              _shooterD = value;
              textEditingControllerShooterD.text = "$_shooterD";
            });
            break;
          case ntHoodP:
            setState(() {
              _hoodP = value;
              textEditingControllerHoodP.text = "$_hoodP";
            });
            break;
          case ntHoodI:
            setState(() {
              _hoodI = value;
              textEditingControllerHoodI.text = "$_hoodI";
            });
            break;
          case ntHoodD:
            setState(() {
              _hoodD = value;
              textEditingControllerHoodD.text = "$_hoodD";
            });
            break;
          default:
            dev.log("dont know what $name is");
        }
      },
      onError: (errorString) {
        dev.log(errorString);
      },
      onDisconnected: () {
        dev.log("Disconnected called");
        setState(() {
          _connected = false;
        });
      },
    );

    _network_tables41.connect();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _networkInfo = NetworkInfo();

    loadConfigAndConnect();
  }

  Future<void> loadConfigAndConnect() async {
    await loadConfig();
    connect();
  }

  Future<void> loadConfig() async {
    _localAddress = await getLocalHostAddress();
    String response = await rootBundle.loadString('config.yaml');
    var yaml = await loadYaml(response);

    setState(() {
      _config = Config.fromYAML(yaml);
      _textEditingControllerRobotIP.text = _config.robotIPAddress;
    });
  }

  Future<String> getLocalHostAddress() async {
    return await _networkInfo.getWifiIP() ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme.of(context),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            titleTextStyle: Theme.of(context).textTheme.bodyLarge,
            bottom: TabBar(
              labelColor: Theme.of(context).iconTheme.color,
              dividerColor: Theme.of(context).iconTheme.color,
              indicatorColor: Colors.white,
              tabs: const [
                Tab(
                  icon: Icon(
                    Icons.directions_car,
                  ),
                ),
                Tab(icon: Icon(Icons.settings)),
              ],
            ),
            title: Text(
              (_alliance == Alliance.red)
                  ? "${_config.robotIPAddress} Red Alliance Station $_stationNumber connected: $_connected enabled: $_enabled my address: $_localAddress"
                  : "${_config.robotIPAddress} Blue Alliance Station $_stationNumber connected: $_connected enabled: $_enabled my address: $_localAddress",
              style: TextStyle(
                color: (_alliance == Alliance.red) ? Colors.red : Colors.blue,
              ),
            ),
          ),
          body: TabBarView(
            children: [
              (_connected) ? drawMainScreen() : drawReconnectScreen(),
              drawSettingsScreen(),
            ],
          ),
        ),
      ),
    );
  }

  Widget drawMainScreen() {
    return Center(
      child: Scrollbar(
        controller: scrollController,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Container(
            color: Theme.of(context).colorScheme.primary,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    timeWidget(),
                    Container(
                      clipBehavior: Clip.hardEdge,
                      padding: const EdgeInsets.all(20.0),
                      constraints: const BoxConstraints(
                        minWidth: 180.0,
                        maxWidth: 180.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 2.0,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5.0)),
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        style: Theme.of(context).textTheme.bodyLarge,
                        dropdownColor: Colors.black,
                        hint: const Text(defaultSelectedAutoString),
                        value: (_selectedAuto.isEmpty)
                            ? defaultSelectedAutoString
                            : _selectedAuto,
                        items: _autos
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (String? value) async {
                          // Notify network tables of the change
                          _network_tables41.setProperty(
                            networkTablesSelectAuto,
                            value,
                          );

                          setState(() {
                            _selectedAuto = value!;
                          });
                        },
                      ),
                    ),
                    batteryWidget(),
                    hasTargetWidget(),
                    robotStatusWidget(),
                    Text(
                      "FMSAttached",
                      style: TextStyle(
                          color: (_fmsAttached) ? Colors.green : Colors.red),
                    ),
                    Text(
                      "DSAttached",
                      style: TextStyle(
                          color: (_dsAttached) ? Colors.green : Colors.red),
                    ),
                    Text(
                      "Total Power $totalPower",
                    ),
                  ],
                ),
                drawCameraFeeds(),
                fieldWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget hasTargetWidget() {
    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            color: (_shooterHasTarget) ? Colors.green : Colors.red,
          ),
          Text(
            (_shooterHasTarget) ? "Has target" : "No target",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget timeWidget() {
    try {
      return Container(
        width: 200,
        color: (int.parse(textEditingControllerTime.text) < 31)
            ? Colors.red
            : Colors.black,
        child: TextField(
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayLarge,
          readOnly: true,
          showCursor: false,
          decoration: const InputDecoration(
            labelText: "Time",
          ).applyDefaults(Theme.of(context).inputDecorationTheme),
          controller: textEditingControllerTime,
        ),
      );
    } catch (e) {
      dev.log(
          "problem with int.parse, it is ${textEditingControllerTime.text}");
    }

    return Container();
  }

  Widget robotStatusWidget() {
    return TextField(
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.displayLarge,
      showCursor: false,
      decoration: InputDecoration(
        labelText: _robotStatus,
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

  Widget batteryWidget() {
    return SizedBox(
        width: 80,
        child: Stack(
          alignment: Alignment.center,
          children: [
            LinearProgressIndicator(
              color: (_batteryVoltage >= 11.9) ? Colors.green : Colors.red,
              backgroundColor: Colors.transparent,
              value: (_batteryVoltage / 12.0),
              minHeight: 80.0,
            ),
            Text(
              _batteryVoltage.toStringAsFixed(2),
            ),
          ],
        ));
  }

  Widget fieldWidget() {
    return Visibility(
        visible: _config.enableField,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              constraints: const BoxConstraints(
                minWidth: 800,
                maxWidth: 800,
                minHeight: 300,
                maxHeight: 300,
              ),
              child: Image.asset(
                fit: BoxFit.fill,
                //fit: BoxFit.scaleDown,
                "images/2025-new.png",
              ),
            ),

            // Clickable area 1
            Positioned(
              left: 525.0, // X-coordinate
              top: 5.0, // Y-coordinate
              child: GestureDetector(
                onTap: () {
                  print('Part 1 clicked!');
                  // Perform action for Part 1

                  _network_tables41.setProperty(
                    gotoPosition,
                    3,
                  );
                },
                child: Container(
                  width: 40, // Width of clickable area
                  height: 40, // Height of clickable area
                  //color: Colors.transparent, // Make it transparent
                  color: Colors.red, // Make it transparent
                ),
              ),
            ),
            Positioned(
              top: 80.0,
              left: 535.0,
              child: RawMaterialButton(
                onPressed: () {
                  _network_tables41.setProperty(
                    gotoPosition,
                    9,
                  );
                },
                elevation: 2.0,
                fillColor: Colors.white,
                constraints: const BoxConstraints(minWidth: 0.0),
                padding: const EdgeInsets.all(0.0),
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.play_arrow,
                  size: 35.0,
                ),
              ),
            ),
            Positioned(
              top: 50.0,
              left: 400.0,
              child: RawMaterialButton(
                onPressed: () {
                  dev.log("AprilTag 4 was clicked");
                  _network_tables41.setProperty(
                    gotoPosition,
                    4,
                  );
                },
                elevation: 2.0,
                fillColor: Colors.white,
                constraints: const BoxConstraints(minWidth: 0.0),
                padding: const EdgeInsets.all(0.0),
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.play_arrow,
                  size: 35.0,
                ),
              ),
            ),
            Positioned(
              top: 120.0,
              right: 370.0,
              child: RawMaterialButton(
                onPressed: () {
                  dev.log("Cancel was clicked");

                  _network_tables41.setProperty(
                    gotoPosition,
                    -1,
                  );
                },
                elevation: 2.0,
                fillColor: Colors.white,
                constraints: const BoxConstraints(minWidth: 0.0),
                padding: const EdgeInsets.all(15.0),
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.pause,
                  size: 35.0,
                ),
              ),
            ),
            // this is the estimator
            Positioned(
              left: (fieldRobotValues[0] * 47.05) - 25,
              bottom: (fieldRobotValues[1] * 37.5) - 25,
              child: Transform.rotate(
                angle: -(fieldRobotValues[2] / 180.0 * 3.1415926535897932),
                child: Image.asset(
                  width: 50,
                  height: 50,
                  "images/controller.png",
                ),
              ),
            ),
          ],
        ));
  }

  Widget drawReconnectScreen() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      color: Theme.of(context).colorScheme.primary,
      child: Column(
        spacing: 10.0,
        children: [
          Row(
            spacing: 10.0,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 150,
                child: TextField(
                  readOnly: false,
                  cursorColor: Colors.white,
                  controller: _textEditingControllerRobotIP,
                  decoration: const InputDecoration(
                    labelText: "Robot IP",
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (value) {
                    setState(() {
                      _config.robotIPAddress = value;
                      _textEditingControllerRobotIP.text = value;
                    });
                  },
                ),
              ),
              Text("Local address: $_localAddress"),
            ],
            /**/
          ),
          TextButton(
              //style: Theme.of(context).textButtonTheme.style,
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              onPressed: () {
                //_networkTables.connectBot();

                connect();
              },
              child: Text("Reconnect"))
        ],
      ),
    );
  }

  Widget drawSettingsScreen() {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SingleChildScrollView(
              child: Text("Robot IP: ${_config.robotIPAddress}"),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  drawCamera1Settings(),
                  drawCamera2Settings(),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      drawTurnMotorsPID(),
                      drawDriveMotorsPID(),
                      drawAutoDrivePID(),
                      drawAutoTurnPID(),
                    ],
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  drawShooterSettings(),
                  drawShooterHoodSettings(),
                  drawShooterTurretSettings(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget drawTurnMotorsPID() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: 250,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          border: Border.all(
            color: Colors.white,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
              child: Text(
                "Turn PID",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    "P: ",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                /*Slider(
                  max: 10.0,
                  activeColor: Theme.of(context).sliderTheme.activeTrackColor,
                  value: turningMotorPIDP,
                  onChanged: (value) {
                    _network_tables41.setProperty(
                      turningMotorsPIDP,
                      value,
                    );

                    setState(() {
                      turningMotorPIDP = value;
                    });
                  },
                ),*/
                /*Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Text(
                    turningMotorPIDP.toStringAsFixed(2),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),*/

                TextField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    //focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                  controller: textEditingControllerTurnP,
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.white,
                  showCursor: true,
                  onSubmitted: (value) {
                    double? newValue = double.tryParse(value);

                    if (newValue == null) {
                      textEditingControllerTurnP.text = "$turningMotorPIDP";
                    } else {
                      textEditingControllerTurnP.text = "$newValue";
                      turningMotorPIDP = newValue;

                      _network_tables41.setProperty(
                        turningMotorsPIDP,
                        turningMotorPIDP,
                      );
                    }
                  },
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    "I: ",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                /*Slider(
                  max: 10.0,
                  activeColor: Theme.of(context).sliderTheme.activeTrackColor,
                  value: turningMotorPIDI,
                  onChanged: (value) {
                    _network_tables41.setProperty(
                      turningMotorsPIDI,
                      value,
                    );

                    setState(() {
                      turningMotorPIDI = value;
                    });
                  },
                ),*/
                /*Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Text(
                    turningMotorPIDI.toStringAsFixed(2),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),*/
                TextField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    //focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                  controller: textEditingControllerTurnI,
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.white,
                  showCursor: true,
                  onSubmitted: (value) {
                    double? newValue = double.tryParse(value);

                    if (newValue == null) {
                      textEditingControllerTurnP.text = "$turningMotorPIDI";
                    } else {
                      textEditingControllerTurnI.text = "$newValue";
                      turningMotorPIDI = newValue;

                      _network_tables41.setProperty(
                        turningMotorsPIDI,
                        turningMotorPIDI,
                      );
                    }
                  },
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    "D: ",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                /*Slider(
                  max: 10.0,
                  activeColor: Theme.of(context).sliderTheme.activeTrackColor,
                  value: turningMotorPIDD,
                  onChanged: (value) {
                    _network_tables41.setProperty(
                      turningMotorsPIDD,
                      value,
                    );

                    setState(() {
                      turningMotorPIDD = value;
                    });
                  },
                ),*/
                /*Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Text(
                    turningMotorPIDD.toStringAsFixed(2),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),*/
                TextField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    //focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                  controller: textEditingControllerTurnD,
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.white,
                  showCursor: true,
                  onSubmitted: (value) {
                    double? newValue = double.tryParse(value);

                    if (newValue == null) {
                      textEditingControllerTurnD.text = "$turningMotorPIDD";
                    } else {
                      textEditingControllerTurnD.text = "$newValue";
                      turningMotorPIDD = newValue;

                      _network_tables41.setProperty(
                        turningMotorsPIDD,
                        turningMotorPIDD,
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget drawCameraFeeds() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Visibility(
          visible: _config.enablePhotonVision,
          //   child: (_cam1Processed.isNotEmpty)
          //       ? Mjpeg(
          //           width: MediaQuery.sizeOf(context).width / 3,
          //           fit: BoxFit.contain,
          //           //stream: _cam1Processed,
          //           //stream: "http://photonvision.local:1181/?action=stream",
          //           //stream: "http://photonvision.local:1182/stream.mjpg",
          //           //stream: "http://photonvision.local:1181/?action=stream",
          //           stream: "http://10.42.18.201:1181/?action=stream",
          //           isLive: true,
          //           error: (contet, error, stack) {
          //             return Text(
          //                 "Failed to load PhotonVision video $_cam1Processed");
          //           },
          //         )
          //       : const Text("not showing"),
          // ),
          child: Column(children: [
            Mjpeg(
              width: MediaQuery.sizeOf(context).width / 3,
              fit: BoxFit.contain,
              //stream: _cam1Processed,
              //stream: "http://photonvision.local:1182/?action=stream",
              stream: _config.photonvision_camera1_url,
              isLive: true,
              error: (contet, error, stack) {
                return Text(
                    "Failed to load PhotonVision video $_cam1Processed");
              },
            ),
            Switch(
              value: _photonVisionEnableCam1,
              activeColor: Colors.red,
              onChanged: (value) {
                _network_tables41.setProperty(
                  networkTablesPhotonVisionEnableCam1,
                  value,
                );

                setState(() {
                  // Update the state and rebuild the widget
                  _photonVisionEnableCam1 = value;
                });
              },
            ),
          ]),
        ),
        Visibility(
            visible: _config.enablePhotonVision,
            // child: (_cam2Processed.isNotEmpty)
            //     ? Mjpeg(
            //         width: MediaQuery.sizeOf(context).width / 3,
            //         fit: BoxFit.contain,
            //         stream: _cam2Processed,
            //         //stream: "http://photonvision.local:1182/stream.mjpg",
            //         //stream: "http://photonvision.local:1181/?action=stream",
            //         //stream: "http://10.42.18.201:1181/?action=stream",
            //         isLive: true,
            //         error: (contet, error, stack) {
            //           return Text(
            //               "Failed to load PhotonVision video $_cam2Processed");
            //         },
            //       )
            //     : const Text("not showing"),
            child: Column(
              children: [
                Mjpeg(
                  width: MediaQuery.sizeOf(context).width / 3,
                  fit: BoxFit.contain,
                  //stream: _cam2Processed,
                  //stream: "http://photonvision.local:1184/?action=stream",
                  stream: "http://10.42.19.201:1184/?action=stream",
                  //stream: _config.photonvision_camera1_url,
                  isLive: true,
                  error: (contet, error, stack) {
                    return Text(
                        "Failed to load PhotonVision video $_cam2Processed");
                  },
                ),
                Switch(
                  value: _photonVisionEnableCam2,
                  activeColor: Colors.red,
                  onChanged: (value) {
                    _network_tables41.setProperty(
                      networkTablesPhotonVisionEnableCam2,
                      value,
                    );

                    setState(() {
                      // Update the state and rebuild the widget
                      _photonVisionEnableCam2 = value;
                    });
                  },
                ),
              ],
            )),
        Visibility(
          //visible: _config.enablePhotonVision,
          visible: false,
          child: (_cam1Raw.isNotEmpty)
              ? Mjpeg(
                  width: MediaQuery.sizeOf(context).width / 3,
                  fit: BoxFit.contain,
                  //stream: _cam1Raw,
                  stream: "http://photonvision.local:1182/stream.mjpg",
                  isLive: true,
                  error: (contet, error, stack) {
                    return Text("Failed to load PhotonVision video $_cam1Raw");
                  },
                )
              : const Text("not showing"),
        ),
        Visibility(
          visible: _config.enableLimelight,
          child: Expanded(
            child: Mjpeg(
              width: MediaQuery.sizeOf(context).width / 3,
              //fit: BoxFit.fill,
              fit: BoxFit.contain,
              //stream: (_config.isSimulator) ? _cam1Raw : _limelightProcessed,
              stream: "http://10.42.19.200:5800",
              //: "http://${_config.limeLightIPAddress}:${_config.lightLightPort}/${_config.limeLightPath}",
              isLive: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget drawDriveMotorsPID() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: 250,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15.0)),
              border: Border.all(
                color: Colors.white,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
                  child: Text(
                    "Drive PID",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "P: ",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    /*Slider(
                      max: 10.0,
                      activeColor:
                          Theme.of(context).sliderTheme.activeTrackColor,
                      value: driveMotorPIDP,
                      onChanged: (value) {
                        _network_tables41.setProperty(
                          driveMotorsPIDP,
                          value,
                        );

                        setState(() {
                          driveMotorPIDP = value;
                        });
                      },
                    ),*/
                    /*Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Text(
                        driveMotorPIDP.toStringAsFixed(2),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),*/
                    TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        //focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      controller: textEditingControllerDriveP,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.white,
                      showCursor: true,
                      onSubmitted: (value) {
                        double? newValue = double.tryParse(value);

                        if (newValue == null) {
                          textEditingControllerDriveP.text = "$driveMotorPIDP";
                        } else {
                          textEditingControllerDriveP.text = "$newValue";
                          driveMotorPIDP = newValue;

                          _network_tables41.setProperty(
                            driveMotorsPIDP,
                            driveMotorPIDP,
                          );
                        }
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "I: ",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    /*Slider(
                      max: 10.0,
                      activeColor:
                          Theme.of(context).sliderTheme.activeTrackColor,
                      value: driveMotorPIDI,
                      onChanged: (value) {
                        _network_tables41.setProperty(
                          driveMotorsPIDI,
                          value,
                        );

                        setState(() {
                          driveMotorPIDI = value;
                        });
                      },
                    ),*/
                    /*Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Text(
                        driveMotorPIDI.toStringAsFixed(2),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),*/
                    TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        //focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      controller: textEditingControllerDriveI,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.white,
                      showCursor: true,
                      onSubmitted: (value) {
                        double? newValue = double.tryParse(value);

                        if (newValue == null) {
                          textEditingControllerDriveI.text = "$driveMotorPIDI";
                        } else {
                          textEditingControllerDriveI.text = "$newValue";
                          driveMotorPIDI = newValue;

                          _network_tables41.setProperty(
                            driveMotorsPIDI,
                            driveMotorPIDI,
                          );
                        }
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "D: ",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    /*Slider(
                      max: 10.0,
                      activeColor:
                          Theme.of(context).sliderTheme.activeTrackColor,
                      value: driveMotorPIDD,
                      onChanged: (value) {
                        _network_tables41.setProperty(
                          driveMotorsPIDD,
                          value,
                        );

                        setState(() {
                          driveMotorPIDD = value;
                        });
                      },
                    ),*/
                    /*Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Text(
                        driveMotorPIDD.toStringAsFixed(2),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),*/
                    TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        //focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      controller: textEditingControllerDriveD,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.white,
                      showCursor: true,
                      onSubmitted: (value) {
                        double? newValue = double.tryParse(value);

                        if (newValue == null) {
                          textEditingControllerDriveD.text = "$driveMotorPIDD";
                        } else {
                          textEditingControllerDriveD.text = "$newValue";
                          driveMotorPIDD = newValue;

                          _network_tables41.setProperty(
                            driveMotorsPIDD,
                            driveMotorPIDD,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget drawAutoDrivePID() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: 250,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15.0)),
              border: Border.all(
                color: Colors.white,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
                  child: Text(
                    "Auto Drive PID",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "P: ",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        //focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      controller: textEditingControllerAutoDriveP,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.white,
                      showCursor: true,
                      onSubmitted: (value) {
                        double? newValue = double.tryParse(value);

                        if (newValue == null) {
                          textEditingControllerAutoDriveP.text =
                              "$autoDriveMotorPIDP";
                        } else {
                          textEditingControllerAutoDriveP.text = "$newValue";
                          autoDriveMotorPIDP = newValue;

                          _network_tables41.setProperty(
                            ntAutoDriveP,
                            autoDriveMotorPIDP,
                          );
                        }
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "I: ",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        //focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      controller: textEditingControllerAutoDriveI,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.white,
                      showCursor: true,
                      onSubmitted: (value) {
                        double? newValue = double.tryParse(value);

                        if (newValue == null) {
                          textEditingControllerDriveI.text =
                              "$autoDriveMotorPIDI";
                        } else {
                          textEditingControllerAutoDriveI.text = "$newValue";
                          autoDriveMotorPIDI = newValue;

                          _network_tables41.setProperty(
                            ntAutoDriveI,
                            autoDriveMotorPIDI,
                          );
                        }
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "D: ",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        //focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      controller: textEditingControllerAutoDriveD,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.white,
                      showCursor: true,
                      onSubmitted: (value) {
                        double? newValue = double.tryParse(value);

                        if (newValue == null) {
                          textEditingControllerDriveD.text =
                              "$autoDriveMotorPIDD";
                        } else {
                          textEditingControllerAutoDriveD.text = "$newValue";
                          autoDriveMotorPIDD = newValue;

                          _network_tables41.setProperty(
                            ntAutoDriveD,
                            autoDriveMotorPIDD,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget drawAutoTurnPID() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: 250,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15.0)),
              border: Border.all(
                color: Colors.white,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
                  child: Text(
                    "Auto Turn PID",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "P: ",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        //focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      controller: textEditingControllerAutoTurnP,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.white,
                      showCursor: true,
                      onSubmitted: (value) {
                        double? newValue = double.tryParse(value);

                        if (newValue == null) {
                          textEditingControllerAutoTurnP.text = "$autoTurnPIDP";
                        } else {
                          textEditingControllerAutoTurnP.text = "$newValue";
                          autoTurnPIDP = newValue;

                          _network_tables41.setProperty(
                            ntAutoTurnP,
                            autoTurnPIDP,
                          );
                        }
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "I: ",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        //focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      controller: textEditingControllerAutoTurnI,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.white,
                      showCursor: true,
                      onSubmitted: (value) {
                        double? newValue = double.tryParse(value);

                        if (newValue == null) {
                          textEditingControllerTurnI.text = "$autoTurnPIDI";
                        } else {
                          textEditingControllerAutoTurnI.text = "$newValue";
                          autoTurnPIDI = newValue;

                          _network_tables41.setProperty(
                            ntAutoTurnI,
                            autoTurnPIDI,
                          );
                        }
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "D: ",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        //focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      controller: textEditingControllerAutoTurnD,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.white,
                      showCursor: true,
                      onSubmitted: (value) {
                        double? newValue = double.tryParse(value);

                        if (newValue == null) {
                          textEditingControllerTurnD.text = "$autoTurnPIDD";
                        } else {
                          textEditingControllerAutoTurnD.text = "$newValue";
                          autoTurnPIDD = newValue;

                          _network_tables41.setProperty(
                            ntAutoTurnD,
                            autoTurnPIDD,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget drawCamera1Settings() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: 325,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15.0)),
              border: Border.all(
                color: Colors.white,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
                  child: Text(
                    "Camera 1 Settings",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "X: ",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        //focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      controller: textEditingControllerCamera1X,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.white,
                      showCursor: true,
                      onSubmitted: (value) {
                        double? newValue = double.tryParse(value);

                        if (newValue == null) {
                          textEditingControllerCamera1X.text =
                              "$_photonVisionCam1XOffset";
                        } else {
                          textEditingControllerCamera1X.text = "$newValue";
                          _photonVisionCam1XOffset = newValue;

                          _network_tables41.setProperty(
                            ntPhotonVisionCam1XOffset,
                            _photonVisionCam1XOffset,
                          );
                        }
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "Y: ",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        //focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      controller: textEditingControllerCamera1Y,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.white,
                      showCursor: true,
                      onSubmitted: (value) {
                        double? newValue = double.tryParse(value);

                        if (newValue == null) {
                          textEditingControllerCamera1Y.text =
                              "$_photonVisionCam1YOffset";
                        } else {
                          textEditingControllerCamera1Y.text = "$newValue";
                          _photonVisionCam1YOffset = newValue;

                          _network_tables41.setProperty(
                            ntPhotonVisionCam1YOffset,
                            _photonVisionCam1YOffset,
                          );
                        }
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "Height: ",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        //focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      controller: textEditingControllerCamera1Height,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.white,
                      showCursor: true,
                      onSubmitted: (value) {
                        double? newValue = double.tryParse(value);

                        if (newValue == null) {
                          textEditingControllerCamera1Height.text =
                              "$_photonVisionCam1Height";
                        } else {
                          textEditingControllerCamera1Height.text = "$newValue";
                          _photonVisionCam1Height = newValue;

                          _network_tables41.setProperty(
                            ntPhotonVisionCam1Height,
                            _photonVisionCam1Height,
                          );
                        }
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "Rotation: ",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        //focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      controller: textEditingControllerCamera1Rotation,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.white,
                      showCursor: true,
                      onSubmitted: (value) {
                        double? newValue = double.tryParse(value);

                        if (newValue == null) {
                          textEditingControllerCamera1Rotation.text =
                              "$_photonVisionCam1Rotation";
                        } else {
                          textEditingControllerCamera1Rotation.text =
                              "$newValue";
                          _photonVisionCam1Rotation = newValue;

                          _network_tables41.setProperty(
                            ntPhotonVisionCam1Rotation,
                            _photonVisionCam1Rotation,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget drawCamera2Settings() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: 325,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15.0)),
              border: Border.all(
                color: Colors.white,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
                  child: Text(
                    "Camera 2 Settings",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "X: ",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        //focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      controller: textEditingControllerCamera2X,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.white,
                      showCursor: true,
                      onSubmitted: (value) {
                        double? newValue = double.tryParse(value);

                        if (newValue == null) {
                          textEditingControllerCamera2X.text =
                              "$_photonVisionCam2XOffset";
                        } else {
                          textEditingControllerCamera2X.text = "$newValue";
                          _photonVisionCam2XOffset = newValue;

                          _network_tables41.setProperty(
                            ntPhotonVisionCam2XOffset,
                            _photonVisionCam2XOffset,
                          );
                        }
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "Y: ",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        //focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      controller: textEditingControllerCamera2Y,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.white,
                      showCursor: true,
                      onSubmitted: (value) {
                        double? newValue = double.tryParse(value);

                        if (newValue == null) {
                          textEditingControllerCamera2Y.text =
                              "$_photonVisionCam2YOffset";
                        } else {
                          textEditingControllerCamera2Y.text = "$newValue";
                          _photonVisionCam2YOffset = newValue;

                          _network_tables41.setProperty(
                            ntPhotonVisionCam2YOffset,
                            _photonVisionCam2YOffset,
                          );
                        }
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "Height: ",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        //focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      controller: textEditingControllerCamera2Height,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.white,
                      showCursor: true,
                      onSubmitted: (value) {
                        double? newValue = double.tryParse(value);

                        if (newValue == null) {
                          textEditingControllerCamera2Height.text =
                              "$_photonVisionCam2Height";
                        } else {
                          textEditingControllerCamera2Height.text = "$newValue";
                          _photonVisionCam2Height = newValue;

                          _network_tables41.setProperty(
                            ntPhotonVisionCam2Height,
                            _photonVisionCam2Height,
                          );
                        }
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "Rotation: ",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        //focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      controller: textEditingControllerCamera2Rotation,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.white,
                      showCursor: true,
                      onSubmitted: (value) {
                        double? newValue = double.tryParse(value);

                        if (newValue == null) {
                          textEditingControllerCamera2Rotation.text =
                              "$_photonVisionCam2Rotation";
                        } else {
                          textEditingControllerCamera2Rotation.text =
                              "$newValue";
                          _photonVisionCam2Rotation = newValue;

                          _network_tables41.setProperty(
                            ntPhotonVisionCam2Rotation,
                            _photonVisionCam2Rotation,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget drawShooterSettings() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: 250,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15.0)),
              border: Border.all(
                color: Colors.white,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
                  child: Text(
                    "Shooter Settings",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "P: ",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        //focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      controller: textEditingControllerShooterP,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.white,
                      showCursor: true,
                      onSubmitted: (value) {
                        double? newValue = double.tryParse(value);

                        if (newValue == null) {
                          textEditingControllerShooterP.text = "$_shooterP";
                        } else {
                          textEditingControllerShooterP.text = "$newValue";
                          _shooterP = newValue;

                          _network_tables41.setProperty(
                            ntShooterP,
                            _shooterP,
                          );
                        }
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "I: ",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        //focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      controller: textEditingControllerShooterI,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.white,
                      showCursor: true,
                      onSubmitted: (value) {
                        double? newValue = double.tryParse(value);

                        if (newValue == null) {
                          textEditingControllerShooterI.text = "$_shooterP";
                        } else {
                          textEditingControllerShooterI.text = "$newValue";
                          _shooterP = newValue;

                          _network_tables41.setProperty(
                            ntShooterI,
                            _shooterP,
                          );
                        }
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "D: ",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        //focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      controller: textEditingControllerShooterD,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.white,
                      showCursor: true,
                      onSubmitted: (value) {
                        double? newValue = double.tryParse(value);

                        if (newValue == null) {
                          textEditingControllerShooterD.text = "$_shooterD";
                        } else {
                          textEditingControllerShooterD.text = "$newValue";
                          _shooterD = newValue;

                          _network_tables41.setProperty(
                            ntShooterD,
                            _shooterD,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget drawShooterHoodSettings() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: 250,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15.0)),
              border: Border.all(
                color: Colors.white,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
                  child: Text(
                    "Shooter Hood Settings",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "P: ",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        //focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      controller: textEditingControllerHoodP,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.white,
                      showCursor: true,
                      onSubmitted: (value) {
                        double? newValue = double.tryParse(value);

                        if (newValue == null) {
                          textEditingControllerHoodP.text = "$_hoodP";
                        } else {
                          textEditingControllerHoodP.text = "$newValue";
                          _hoodP = newValue;

                          _network_tables41.setProperty(
                            ntHoodP,
                            _hoodP,
                          );
                        }
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "I: ",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        //focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      controller: textEditingControllerHoodI,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.white,
                      showCursor: true,
                      onSubmitted: (value) {
                        double? newValue = double.tryParse(value);

                        if (newValue == null) {
                          textEditingControllerHoodI.text = "$_hoodI";
                        } else {
                          textEditingControllerHoodI.text = "$newValue";
                          _hoodI = newValue;

                          _network_tables41.setProperty(
                            ntHoodI,
                            _hoodI,
                          );
                        }
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "D: ",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        //focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      controller: textEditingControllerHoodD,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.white,
                      showCursor: true,
                      onSubmitted: (value) {
                        double? newValue = double.tryParse(value);

                        if (newValue == null) {
                          textEditingControllerHoodD.text = "$_hoodD";
                        } else {
                          textEditingControllerHoodD.text = "$newValue";
                          _hoodD = newValue;

                          _network_tables41.setProperty(
                            ntHoodD,
                            _hoodD,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget drawShooterTurretSettings() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: 250,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15.0)),
              border: Border.all(
                color: Colors.white,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
                  child: Text(
                    "Shooter Turret Settings",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "P: ",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        //focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      controller: textEditingControllerHoodP,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.white,
                      showCursor: true,
                      onSubmitted: (value) {
                        double? newValue = double.tryParse(value);

                        if (newValue == null) {
                          textEditingControllerHoodP.text = "$_hoodP";
                        } else {
                          textEditingControllerHoodP.text = "$newValue";
                          _hoodP = newValue;

                          _network_tables41.setProperty(
                            ntHoodP,
                            _hoodP,
                          );
                        }
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "I: ",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        //focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      controller: textEditingControllerHoodI,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.white,
                      showCursor: true,
                      onSubmitted: (value) {
                        double? newValue = double.tryParse(value);

                        if (newValue == null) {
                          textEditingControllerHoodI.text = "$_hoodI";
                        } else {
                          textEditingControllerHoodI.text = "$newValue";
                          _hoodI = newValue;

                          _network_tables41.setProperty(
                            ntHoodI,
                            _hoodI,
                          );
                        }
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "D: ",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        //focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      controller: textEditingControllerHoodD,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.white,
                      showCursor: true,
                      onSubmitted: (value) {
                        double? newValue = double.tryParse(value);

                        if (newValue == null) {
                          textEditingControllerHoodD.text = "$_hoodD";
                        } else {
                          textEditingControllerHoodD.text = "$newValue";
                          _hoodD = newValue;

                          _network_tables41.setProperty(
                            ntHoodD,
                            _hoodD,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
