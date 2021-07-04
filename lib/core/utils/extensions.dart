import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  ThemeData get theme => Theme.of(this);
}

extension MediaQueryExtension on BuildContext {
  double height(double value) => mediaQuery.size.height * value;
  double width(double value) => mediaQuery.size.width * value;
}

extension ImageKit on String {
  String imgKitWidth(double width) {
    // ignore: unnecessary_this
    return this.replaceFirst(RegExp(r'(w-)\d*'), 'w-$width');
  }

  String imgKitSize(double width, double height) {
    // ignore: unnecessary_this
    return this
        .replaceFirst(RegExp(r'(h-)\d*'), 'h-${height.toInt()}')
        .replaceFirst(RegExp(r'(w-)\d*'), 'w-${width.toInt()}');
  }

  String imgKitBlur(double width, double height) {
    // ignore: unnecessary_this
    return this
            .replaceFirst(RegExp(r'(h-)\d*'), 'h-${height.toInt()}')
            .replaceFirst(RegExp(r'(w-)\d*'), 'w-${width.toInt()}') +
        ',q-10,bl-10';
  }
}
