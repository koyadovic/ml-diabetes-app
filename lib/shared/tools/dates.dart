import 'package:timezone/timezone.dart' as tz;

/*
import 'package:iDietFit/shared/tools/dates.dart';
 */


extension AsTimezone on DateTime {
  tz.TZDateTime asTimezone(tz.Location timezone) {
    if(timezone == null) {
      timezone = tz.UTC;
    }
    return tz.TZDateTime.fromMillisecondsSinceEpoch(timezone, this.toUtc().millisecondsSinceEpoch);
  }
}
