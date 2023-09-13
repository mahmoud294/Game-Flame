import 'package:action_adventure/action_adventure.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  // final ActionAdventure actionAdventure = ActionAdventure();
  runApp(GameWidget(game: ActionAdventure()));
}
