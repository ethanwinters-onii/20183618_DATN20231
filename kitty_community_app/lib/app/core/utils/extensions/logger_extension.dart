import 'dart:developer';

import 'package:flutter/foundation.dart' as foundation;
import 'package:logger/logger.dart';

final logger = Logger(
  filter: null,
  printer: foundation.kDebugMode
      ? PrettyPrinter(
          printTime: false,
          lineLength: 80,
          errorMethodCount: 0,
          methodCount: 0,
          colors: false,
        )
      : null,
  output: ConsoleOutput(),
);

class ConsoleOutput extends LogOutput {
  // String _prettyTime(DateTime dateTime) {
  //   return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}.${dateTime.millisecond.toString().padLeft(3, '0').substring(0, 2)}';
  // }

  @override
  void output(OutputEvent event) {
    var type = "";
    var start = '\x1b[90m';
    const end = '\x1b[0m';
    const white = '\x1b[37m';

    switch (event.origin.level) {
      case Level.info:
        start = '\x1b[38;5;12m ';
        type = "INFO";
        break;
      case Level.verbose:
        start = '\x1b[38;5;226m';
        type = "FIREBASE";
        break;
      case Level.debug:
        start = '\x1b[32m';
        type = "DEBUG";
        break;
      case Level.warning:
        start = '\x1b[38;5;11m ';
        type = "WARN";
        break;
      case Level.error:
        start = '\x1b[38;5;196m';
        type = "ERROR";
        break;
      case Level.wtf:
        start = '\x1b[90m  ';
        type = "WTF";
        break;
      case Level.nothing:
        start = '\x1b[90m ';
        type = "NTHG";
        break;
    }

    for (var line in event.lines) {
      final message =
          '$white${event.origin.time.toString().split(" ")[1]} $end$start[$type]  $line$end';
      log(message, name: "PET_COMMUNITY");
    }
  }
}
