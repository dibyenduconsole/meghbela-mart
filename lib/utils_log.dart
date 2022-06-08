import 'package:intl/intl.dart';

class Utils{
  static void logResponse(var value){
    print(value);
  }


  static String getDateFromTime(int millis){
    var dt = DateTime.fromMillisecondsSinceEpoch(millis);

// 12 Hour format:
    var d12 = DateFormat('MM/dd/yyyy').format(dt);
    Utils.logResponse("Time-"+d12);
    return d12.toString();
  }
}