import 'package:action_adventure/action_adventure.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscape();
  // final ActionAdventure actionAdventure = ActionAdventure();
  runApp(GameWidget(game: ActionAdventure()));
}
