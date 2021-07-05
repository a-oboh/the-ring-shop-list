import 'package:flutter/material.dart';
import 'package:ring_shop_list/core/utils/size_config.dart';

//ignore_for_file: prefer_interpolation_to_compose_strings
//ignore_for_file: unnecessary_this
extension ContextExtension on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  ThemeData get theme => Theme.of(this);
}

extension MediaQueryExtension on BuildContext {
  double height(double value) => mediaQuery.size.height * value;
  double width(double value) => mediaQuery.size.width * value;
}

//handle image kit resizing
extension ImageKit on String {
  String imgKitWidth(double width) {
    return this.replaceFirst(RegExp(r'(w-)\d*'), 'w-$width');
  }

  String imgKitSize(double width, double height) {
    return this
        .replaceFirst(RegExp(r'(h-)\d*'), 'h-${height.toInt()}')
        .replaceFirst(RegExp(r'(w-)\d*'), 'w-${width.toInt()}');
  }

  String imgKitBlur(double width, double height) {
    return this
            .replaceFirst(RegExp(r'(h-)\d*'), 'h-${height.toInt()}')
            .replaceFirst(RegExp(r'(w-)\d*'), 'w-${width.toInt()}') +
        ',q-10,bl-10';
  }
}

extension SizeExtension on num {
  double get height => SizeConfig.height(this.toDouble());

  num get width => SizeConfig.width(this.toDouble());

  num get text => SizeConfig.textSize(this.toDouble());
}
