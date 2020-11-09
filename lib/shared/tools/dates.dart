import 'package:timezone/timezone.dart' as tz;


extension AsTimezone on DateTime {
  tz.TZDateTime asTimezone(tz.Location timezone) {
    if(timezone == null) {
      timezone = tz.UTC;
    }
    return tz.TZDateTime.fromMillisecondsSinceEpoch(timezone, this.toUtc().millisecondsSinceEpoch);
  }
}
