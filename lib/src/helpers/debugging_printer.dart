import 'dart:developer';

class Debugger {
  static void black(text) => log('\x1B[30m$text\x1B[0m');

  static void red(text) => log('\x1B[31m$text\x1B[0m');

  static void orange(text) => log('\x1B[33m$text\x1B[0m');

  static void green(text) => log('\x1B[32m$text\x1B[0m');

  static void yellow(text) => log('\x1B[33;1m\x1B[5m$text\x1B[0m');

  static void blue(text) => log('\x1B[34m$text\x1B[0m');

  static void magenta(text) => log('\x1B[35;1m\x1B[5m$text\x1B[0m');

  static void cyan(text) => log('\x1B[36m$text\x1B[0m');

  static void white(text) => log('\x1B[37m$text\x1B[0m');
}
