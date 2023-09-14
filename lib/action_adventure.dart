import 'dart:async';
import 'dart:io';

import 'package:action_adventure/Levels/level.dart';
import 'package:action_adventure/actors/player.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class ActionAdventure extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks {
  final Player player = Player();

  late JoystickComponent joystickComponent;
  @override
  Color backgroundColor() => const Color(0xff211f30);
  late final CameraComponent cam;
  bool showJoystick =
      Platform.isAndroid || Platform.isIOS || Platform.isFuchsia;
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
    if (showJoystick) addJoystick();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showJoystick) updateJoystick();
    super.update(dt);
  }

  void addJoystick() {
    joystickComponent = JoystickComponent(
      knob: SpriteComponent(
        sprite: Sprite(
          images.fromCache("HUD/Knob.png"),
        ),
      ),
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache("HUD/Joystick.png"),
        ),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );
    add(joystickComponent);
  }

  void updateJoystick() {
    switch (joystickComponent.direction) {
      case JoystickDirection.left:
        player.playerDirection = PlayerDirection.left;
        break;
      case JoystickDirection.right:
        player.playerDirection = PlayerDirection.right;
        break;
      case JoystickDirection.idle:
        player.playerDirection = PlayerDirection.none;
        break;
      default:
    }
  }
}
