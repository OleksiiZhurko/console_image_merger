import 'dart:io';

/// Displays the received information
void printer(String string, {dynamic param = '', String newLine = ''}) =>
    stdout.write('$string $param$newLine');