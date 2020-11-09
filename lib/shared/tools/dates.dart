import 'package:timezone/timezone.dart' as tz;

tz.TZDateTime makeAwareDateTime(DateTime dateTime, tz.Location timezone) {
  if(timezone == null) {
    timezone = tz.UTC;
  }
  return tz.TZDateTime.fromMillisecondsSinceEpoch(timezone, dateTime.millisecondsSinceEpoch);
}
