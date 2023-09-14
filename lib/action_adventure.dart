import 'dart:async';
import 'dart:ui';

import 'package:action_adventure/Levels/level.dart';
import 'package:action_adventure/actors/player.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

class ActionAdventure extends FlameGame with HasKeyboardHandlerComponents {
  final Player player = Player();
  @override
  Color backgroundColor() => const Color(0xff211f30);
  late final CameraComponent cam;
  @override
  FutureOr<void> onLoad() async {
    images.prefix = "assets/Free/";
    final world = Level1(levelName: "level-01", player: player);
    await images.loadAllImages();

    cam = CameraComponent.withFixedResolution(
      world: world,
      width: 640,
      height: 360,
    );
    cam.viewfinder.anchor = Anchor.topLeft;
    addAll([world, cam]);
    return super.onLoad();
  }
}
