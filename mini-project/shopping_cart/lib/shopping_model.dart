import 'dart:math';

import 'dart:ui';

import 'package:flutter/material.dart';

class ShoppingModel {
  ShoppingModel(this.name, this.img, this.price, this.nrItems,
      [Color customColor])
      : color = customColor ?? Color(Random().nextInt(0xffffffff));

  String name = '';
  String img = '';
  double price = 0.0;
  int nrItems = 0;
  Color color;
}
