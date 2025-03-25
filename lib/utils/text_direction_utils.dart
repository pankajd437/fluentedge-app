import 'package:flutter/material.dart';

TextDirection getTextDirection(bool isRTL) {
  return isRTL ? TextDirection.rtl : TextDirection.ltr;
}