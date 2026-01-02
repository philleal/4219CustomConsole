import 'package:yaml/yaml.dart';

class Config {
  // Roborio
  String _robotIPAddress = "";

  bool _isSimulator = false;
  bool get isSimulator => _isSimulator;

  // Roborio properties
  String get robotIPAddress => _robotIPAddress;

  // Limelight
  String _limeLightIPAddress = "";
  bool _enableLimeLight = true;
  int _limelightPort = 0;
  String _limelightPath = "";

  // Limelight properties
  bool get enableLimelight => _enableLimeLight;
  String get limeLightIPAddress => _limeLightIPAddress;
  int get lightLightPort => _limelightPort;
  String get limeLightPath => _limelightPath;

  // PhotonVision
  bool _enablePhotonVision = false;
  String _photonvision_ip = "";
  int _photonvision_port = 0;
  String _photonvision_path1 = "";

  String _photonvision_camera1_url = "";
  String get photonvision_camera1_url => _photonvision_camera1_url;
  String _photonvision_camera2_url = "";
  String get photonvision_camera2_url => _photonvision_camera1_url;

  // PhotonVision properties
  bool get enablePhotonVision => _enablePhotonVision;

  // Field
  bool _enableField = false;
  bool get enableField => _enableField;

  //
  //String _matchTimePath = "";
  //String _matchTimePath = "";
  //String get matchTimePath => _matchTimePath;
  //String _autonomousPath = "";
  //String get autonomousPath => _autonomousPath;

  Config({
    String robot_ip = "",
    String limelight_ip = "",
    bool enableLimelight = false,
    int limelightPort = 0,
    String limeLightPath = "",
    String photonvision_ip = "",
    bool enablePhotonVision = false,
    int photonVisionPort = 0,
    String photonVisionPath1 = "",
    String matchTimePath = "",
    String autonomousPath = "",
    bool isSimulator = false,
    String photonvision_camera1_url = "",
    String photonvision_camera2_url = "",
    bool enableField = false,
  }) {
    _robotIPAddress = robot_ip;
    _limeLightIPAddress = limelight_ip;
    _enableLimeLight = enableLimelight;
    _limelightPort = limelightPort;
    _limelightPath = limeLightPath;
    _enablePhotonVision = enablePhotonVision;
    _photonvision_ip = photonvision_ip;
    _photonvision_port = photonVisionPort;
    _photonvision_path1 = photonVisionPath1;
    _isSimulator = isSimulator;
    _photonvision_camera1_url = photonvision_camera1_url;
    _photonvision_camera2_url = photonvision_camera2_url;
    _enableField = enableField;
    //_matchTimePath = matchTimePath;
    //_autonomousPath = autonomousPath;
  }

  /*Config.fromJson(Map<String, dynamic> json) {
    _robotIPAddress = json['robot_ip'];
    _limeLightIPAddress = json['limelight_ip'];
    _enableLimeLight = json['enable_limelight'];
    _limelightPort = json['limelight_port'];
    _limelightPath = json['limelight_path'];

    _enablePhotonVision = json['enable_photonvision'];
  }*/

  Config.fromYAML(YamlMap yaml) {
    _robotIPAddress = (yaml['robot_ip'] != null) ? yaml['robot_ip'] : "";
    _isSimulator =
        (yaml['is_simulator'] != null) ? yaml['is_simulator'] : false;
    _limeLightIPAddress =
        (yaml['limelight_ip'] != null) ? yaml['limelight_ip'] : "";
    _enableLimeLight =
        (yaml['enable_limelight'] != null) ? yaml['enable_limelight'] : false;
    _limelightPort =
        (yaml['limelight_port'] != null) ? yaml['limelight_port'] : 0;
    _limelightPath =
        (yaml['limelight_path'] != null) ? yaml['limelight_path'] : "";

    // photonvision stuff
    _enablePhotonVision = (yaml['enable_photonvision'] != null)
        ? yaml['enable_photonvision']
        : false;
    _photonvision_ip =
        (yaml['photonvision_ip'] != null) ? yaml['photonvision_ip'] : "";
    _photonvision_port =
        (yaml['photonvision_port'] != null) ? yaml['photonvision_port'] : 0;
    _photonvision_path1 =
        (yaml['photonvision_path1'] != null) ? yaml['photonvision_path1'] : "";

    _photonvision_camera1_url = (yaml['photonvision_camera1_url'] != null)
        ? yaml['photonvision_camera1_url']
        : "";

    _photonvision_camera2_url = (yaml['photonvision_camera2_url'] != null)
        ? yaml['photonvision_camera2_url']
        : "";

    _enableField =
        (yaml['enable_field'] != null) ? yaml['enable_field'] : false;

    /*_matchTimePath =
        (yaml['match_time_path'] != null) ? yaml['match_time_path'] : "";

    _autonomousPath =
        (yaml['autonomous_path'] != null) ? yaml['autonomous_path'] : "";*/
  }
}
