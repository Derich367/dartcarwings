import 'package:intl/intl.dart';

class CarwingsBattery {

  NumberFormat numberFormat = new NumberFormat('0');

  DateTime timeStamp;
  double batteryLevelCapacity;
  double batteryLevel;
  bool isConnected = false;
  bool isCharging = false;
  bool isQuickCharging = false;
  bool isConnectedToQuickCharging = false;
  String batteryPercentage;
  String cruisingRangeAcOffKm;
  String cruisingRangeAcOffMiles;
  String cruisingRangeAcOnKm;
  String cruisingRangeAcOnMiles;
  Duration timeToFullTrickle;
  Duration timeToFullL2;
  Duration timeToFullL2_6kw;

  CarwingsBattery(Map params) {
    //this.timeStamp = new DateFormat('yyyy-MM-dd H:m:s').parse(params['timeStamp']);
    this.timeStamp = new DateTime.now(); // Always now
    this.batteryLevelCapacity = double.parse(params['batteryCapacity']);
    this.batteryLevel = double.parse(params['batteryDegradation']);
    this.isConnected = params['pluginState'] != 'NOT_CONNECTED';
    this.isCharging = params['charging'] == 'YES';
    this.isQuickCharging = params['chargeMode'] == 'RAPIDLY_CHARGING';
    this.isConnectedToQuickCharging = params['pluginState'] == 'QC_CONNECTED';
    this.batteryPercentage = ((this.batteryLevel * 100) / this.batteryLevelCapacity).toString() + '%';
    this.cruisingRangeAcOffKm = numberFormat.format(double.parse(params['cruisingRangeAcOff']) / 1000) + ' km';
    this.cruisingRangeAcOffMiles = numberFormat.format(double.parse(params['cruisingRangeAcOff']) * 0.0006213712) + ' mi';
    this.cruisingRangeAcOnKm = numberFormat.format(double.parse(params['cruisingRangeAcOn']) / 1000) + ' km';
    this.cruisingRangeAcOnMiles = numberFormat.format(double.parse(params['cruisingRangeAcOn']) * 0.0006213712) + ' mi';
    this.timeToFullTrickle = new Duration(minutes: _timeRemaining(params['TimeRequiredToFull']));
    this.timeToFullL2 = new Duration(minutes: _timeRemaining(params['TimeRequiredToFull200']));
    this.timeToFullL2_6kw = new Duration(minutes: _timeRemaining(params['TimeRequiredToFull200_6kW']));
  }

  CarwingsBattery.batteryLatest(Map params) {
    var recs = params["BatteryStatusRecords"];
    var bs = recs['BatteryStatus'];

    this.timeStamp = new DateFormat('dd-MM-yyyy H:m').parse(recs['OperationDateAndTime']);
    this.batteryLevelCapacity = double.parse(bs['BatteryCapacity']);
    this.batteryLevel = double.parse(bs['BatteryRemainingAmount']);
    this.isConnected = recs['PluginState'] != 'NOT_CONNECTED';
    this.isCharging = bs['BatteryChargingStatus'] != 'NOT_CHARGING';
    this.isQuickCharging = bs['BatteryChargingStatus'] == 'RAPIDLY_CHARGING';
    this.isConnectedToQuickCharging = recs['PluginState'] == 'QC_CONNECTED';
    this.batteryPercentage = new NumberFormat('0.0').format((this.batteryLevel * 100) / this.batteryLevelCapacity).toString() + '%';
    this.cruisingRangeAcOffKm = numberFormat.format(double.parse(recs['CruisingRangeAcOff']) / 1000) + ' km';
    this.cruisingRangeAcOffMiles = numberFormat.format(double.parse(recs['CruisingRangeAcOff']) * 0.0006213712) + ' mi';
    this.cruisingRangeAcOnKm = numberFormat.format(double.parse(recs['CruisingRangeAcOn']) / 1000) + ' km';
    this.cruisingRangeAcOnMiles = numberFormat.format(double.parse(recs['CruisingRangeAcOn']) * 0.0006213712) + ' mi';
    this.timeToFullTrickle = new Duration(minutes: _timeRemaining(recs['TimeRequiredToFull']));
    this.timeToFullL2 = new Duration(minutes: _timeRemaining(recs['TimeRequiredToFull200']));
    this.timeToFullL2_6kw = new Duration(minutes: _timeRemaining(recs['TimeRequiredToFull200_6kW']));
  }

  int _timeRemaining(Map params) {
    int minutes = 0;
    if(params != null) {
      if(params['hours'] != null && params['hours'] != '') {
        minutes = 60 * int.parse(params['hours']);
      } else if(params['HourRequiredToFull'] != null && params['HourRequiredToFull'] != '') {
        minutes = 60 * int.parse(params['HourRequiredToFull']);
      }
      if(params['minutes'] != null && params['minutes'] != '') {
        minutes += int.parse(params['minutes']);
      } else if(params['MinutesRequiredToFull'] != null && params['MinutesRequiredToFull'] != '') {
        minutes += int.parse(params['MinutesRequiredToFull']);
      }
    }
    return minutes;
  }
}