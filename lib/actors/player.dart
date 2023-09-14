import 'dart:async';
import 'dart:developer';

import 'package:action_adventure/action_adventure.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';

enum PlayerState { idle, running }

enum PlayerDirection { left, right, none }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<ActionAdventure>, KeyboardHandler {
  Player({this.character = "Ninja Frog", Vector2? position})
      : super(position: position);

  final String character;

  late final SpriteAnimation idleAnimation;

  late final SpriteAnimation runinningAnimation;

  final double stepTime = 0.05;

  PlayerDirection playerDirection = PlayerDirection.none;

  double moveSpeed = 100;

  Vector2 velocity = Vector2.zero();

  bool isFacingRight = true;

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimation();
    return super.onLoad();
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    bool isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    bool isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);
    if (isLeftKeyPressed && isRightKeyPressed) {
      playerDirection = PlayerDirection.none;
    } else if (isLeftKeyPressed) {
      playerDirection = PlayerDirection.left;
    } else if (isRightKeyPressed) {
      playerDirection = PlayerDirection.right;
    } else {
      playerDirection = PlayerDirection.none;
    }
    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void update(double dt) {
    _updateMovementPlayer(dt);
    super.update(dt);
  }

  void _loadAllAnimation() {
    inspect(game.images);
    idleAnimation = _spriteAnimation("Idle", 11);
    runinningAnimation = _spriteAnimation("Run", 12);
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runinningAnimation,
    };
    current = PlayerState.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache("Main Characters/$character/$state (32x32).png"),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
  }

  void _updateMovementPlayer(double dt) {
    double dirx = 0.0;
    switch (playerDirection) {
      case PlayerDirection.left:
        if (isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = false;
        }
        current = PlayerState.running;
        dirx -= moveSpeed;
        break;
      case PlayerDirection.right:
        if (!isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = true;
        }
        current = PlayerState.running;
        dirx += moveSpeed;
        break;
      case PlayerDirection.none:
        current = PlayerState.idle;
        break;
      default:
    }
    velocity = Vector2(dirx, 0.0);
    position += (velocity * dt);
  }
}
