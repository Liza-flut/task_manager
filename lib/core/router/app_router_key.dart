import 'package:flutter/material.dart';

abstract final class AppRouterKey {
  static final rootKey = GlobalKey<NavigatorState>();
  static final dashboardKey = GlobalKey<NavigatorState>();
  static final signKey = GlobalKey<NavigatorState>();
}
