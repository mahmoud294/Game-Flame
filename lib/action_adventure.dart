import 'dart:async';
import 'dart:io';

import 'package:action_adventure/Components/jumb_button.dart';
import 'package:action_adventure/Components/level.dart';
import 'package:action_adventure/Components/player.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class ActionAdventure extends FlameGame
    with
        HasKeyboardHandlerComponents,
        DragCallbacks,
        HasCollisionDetection,
        TapCallbacks {
  final Player player = Player(character: "Virtual Guy");
  List<String> levelList = ["level-01", "level-01"];
  int levelIndex = 0;
  late JoystickComponent joystickComponent;
  @override
  Color backgroundColor() => const Color(0xff211f30);
  late CameraComponent cam;
  bool showJoystick =
      Platform.isAndroid || Platform.isIOS || Platform.isFuchsia;
  bool playSound = false;
  double soundVolume = 1.0;
  @override
  FutureOr<void> onLoad() async {
    images.prefix = "assets/Free/";

    await images.loadAllImages();
    _loadLevel();
    if (showJoystick) {
      addJoystick();
      add(JumbButton());
    }
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showJoystick) updateJoystick();
    super.update(dt);
  }

  void addJoystick() {
    joystickComponent = JoystickComponent(
      priority: 10,
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
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
        break;
      default:
        player.horizontalMovement = 0;
        break;
    }
  }

  void loadnextLevel() {
    removeWhere((component) => component is Level1);
    if (levelIndex < levelList.length) {
      levelIndex++;
      _loadLevel();
    } else {
      levelIndex = 0;
      _loadLevel();
    }
  }

  void _loadLevel() {
    Future.delayed(
      const Duration(seconds: 1),
      () {
        final world = Level1(levelName: levelList[levelIndex], player: player);
        cam = CameraComponent.withFixedResolution(
          world: world,
          width: 640,
          height: 360,
        );
        cam.viewfinder.anchor = Anchor.topLeft;
        addAll([world, cam]);
      },
    );
  }
}
