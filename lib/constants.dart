enum Alliance {
  blue,
  red,
}

enum Mode {
  disabled,
  disconnected,
  teleop,
  auto,
}

// FMS Info
const String networkTablesMatchTimePath =
    "/AdvantageKit/DriverStation/MatchTime";
//const String networkTablesAutonomousPath =
//    "/AdvantageKit/DriverStation/Autonomous";
const String networkTablesEnabledPath = "/AdvantageKit/DriverStation/Enabled";
const String networkTablesDSAttached = "/AdvantageKit/DriverStation/DSAttached";
const String networkTablesFMSAttached =
    "/AdvantageKit/DriverStation/FMSAttached";
//const String networkTablesStationNumber = "/FMSInfo/StationNumber";
const String networkTablesStationNumber =
    "/AdvantageKit/DriverStation/AllianceStation";
const String networkTablesEnabled = "/AdvantageKit/DriverStation/Enabled";

// Power
const String networkTablesBatteryPath =
    "/AdvantageKit/RealOutputs/Power/BatteryVoltage";

// PDP
const String networkTablesPDPTotalPower =
    "/AdvantageKit/PowerDistribution/TotalPower";
const String networkTablesPDPTotalCurrent =
    "/AdvantageKit/PowerDistribution/TotalCurrent";
const String networkTablesPDPTotalEnergy =
    "/AdvantageKit/PowerDistribution/Energy";
const String networkTablesPDPTemperature =
    "/AdvantageKit/PowerDistribution/Temperature";

// CAN
const String networkTablesCANPercentUtilization =
    "/AdvantageKit/RealOutputs/CAN/PercentUtilization";

// Map
const String networkTablesField = "/SmartDashboard/field/Robot";

// Auto
const String networkTablesAutoOptionsPath =
    "/Shuffleboard/Autonomous/Auto/options";
//const String networkTablesSelectedAutoPath =
//"/Shuffleboard/Autonomous/Auto/selected";
const String defaultSelectedAutoString = "Select Auto";
const String networkTablesSelectAuto = "/Shuffleboard/Autonomous/Auto/selected";
const String networkTablesActiveAuto = "/Shuffleboard/Autonomous/Auto/active";

const String ntAutoDriveP = "/Shuffleboard/Autonomous/DriveP";
const String ntAutoDriveI = "/Shuffleboard/Autonomous/DriveI";
const String ntAutoDriveD = "/Shuffleboard/Autonomous/DriveD";

const String ntAutoTurnP = "/Shuffleboard/Autonomous/TurnP";
const String ntAutoTurnI = "/Shuffleboard/Autonomous/TurnI";
const String ntAutoTurnD = "/Shuffleboard/Autonomous/TurnD";

// Climber
//const String networkTablesClimberPath = "/climber/position";

// Field Management System
//const String networkTablesAlliancePath = "/Shuffleboard/Autonomous/Alliance";
const String networkTablesAlliancePath = "/FMSInfo/IsRedAlliance";
const String networkTablesMatchNumberPath = "/FMSInfo/MatchNumber";
const String networkTablesStationNumberPath = "/FMSInfo/StationNumber";
const String networkTablesEventNamePath = "/FMSInfo/EventName";

// PhotonVision
const String networkTablesPhotonVisionCam1HasTargetPath =
    "/photonvision/cam1/hasTarget";
const String networkTablesPhotonVisionCam1RawFeed =
    "/photonvision/cam1/rawBytes";
const String networkTablesPhotonVisionCameraPublisherRaw =
    "/CameraPublisher/cam1-raw/streams";
const String networkTablesPhotonVisionCameraPublisherProcessed =
    "/CameraPublisher/cam1-processed/streams";
const String ntPhotonVisionEstimator =
    "/AdvantageKit/RealOutputs/PhotonVisionEstimator/Robot";
const String networkTablesPhotonVisionCamera2PublisherProcessed =
    "/CameraPublisher/cam2-processed/streams";
const String networkTablesPhotonVisionEnableCam1 =
    "/Shuffleboard/PhotonVision/PhotonVisionEnableCam1";
const String networkTablesPhotonVisionEnableCam2 =
    "/Shuffleboard/PhotonVision/PhotonVisionEnableCam2";

const String ntPhotonVisionCam1XOffset =
    "/Shuffleboard/PhotonVision/camera1XOffset";
const String ntPhotonVisionCam1YOffset =
    "/Shuffleboard/PhotonVision/camera1YOffset";
const String ntPhotonVisionCam1Height =
    "/Shuffleboard/PhotonVision/camera1Height";
const String ntPhotonVisionCam1Rotation =
    "/Shuffleboard/PhotonVision/camera1Rotation";

const String ntPhotonVisionCam2XOffset =
    "/Shuffleboard/PhotonVision/camera2XOffset";
const String ntPhotonVisionCam2YOffset =
    "/Shuffleboard/PhotonVision/camera2YOffset";
const String ntPhotonVisionCam2Height =
    "/Shuffleboard/PhotonVision/camera2Height";
const String ntPhotonVisionCam2Rotation =
    "/Shuffleboard/PhotonVision/camera2Rotation";

// Shooter
const String shooterHasTarget = "/Shuffleboard/Shooter/hasTarget";
const String ntShooterP = "/Shuffleboard/Shooter/ShooterP";
const String ntShooterI = "/Shuffleboard/Shooter/ShooterI";
const String ntShooterD = "/Shuffleboard/Shooter/ShooterD";
const String ntHoodP = "/Shuffleboard/Shooter/HoodP";
const String ntHoodI = "/Shuffleboard/Shooter/HoodI";
const String ntHoodD = "/Shuffleboard/Shooter/HoodD";
const String ntTurretP = "/Shuffleboard/Shooter/HoodP";
const String ntTurretI = "/Shuffleboard/Shooter/HoodI";
const String ntTurretD = "/Shuffleboard/Shooter/HoodD";

const String robotStatus = "/SmartDashboard/Status";

//const String ntPhotonVisionEstimatorPose =
//"/AdvantageKit/RealOutputs/PhotonVisionEstimator/position";
//const String ntPhotonVisionEstimatorPose =
//    "/photonvision/PhotonVisionEstimator/position";

// Swerve Modules PID's
const String turningMotorsPIDP = "/Shuffleboard/Swerve/TurnP";
const String turningMotorsPIDI = "/Shuffleboard/Swerve/TurnI";
const String turningMotorsPIDD = "/Shuffleboard/Swerve/TurnD";

const String driveMotorsPIDP = "/Shuffleboard/Swerve/DriveP";
const String driveMotorsPIDI = "/Shuffleboard/Swerve/DriveI";
const String driveMotorsPIDD = "/Shuffleboard/Swerve/DriveD";

// Field
//const String fieldRobot = "/SmartDashboard/field/Robot";
//const String fieldRobot = "/AdvantageKit/RealOutputs/Estimator/PoseArray";
const String fieldRobot = "/AdvantageKit/RealOutputs/Estimator/Robot";

// Limelight
const bool enableLimeLight = true;
const String networkTablesLimeLightVideoPath =
    "/CameraPublisher/limelight/streams";
//"/CameraPublisher/limelight/source";

const String gotoPosition = "/Shuffleboard/gotoPosition";
