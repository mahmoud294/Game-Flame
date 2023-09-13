import 'dart:async';

import 'package:action_adventure/Levels/level.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

class ActionAdventure extends FlameGame {
  late final CameraComponent cam;
  final world = Level1();
  @override
  FutureOr<void> onLoad() async {
    cam = CameraComponent.withFixedResolution(
        world: world, width: 640, height: 360);
    cam.viewfinder.anchor = Anchor.topLeft;
    addAll([world, cam]);
    return super.onLoad();
  }
}
