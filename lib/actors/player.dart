import 'dart:async';
import 'dart:developer';

import 'package:action_adventure/action_adventure.dart';
import 'package:flame/components.dart';

enum PlayerState { idle, running }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<ActionAdventure> {
  final String character;
  Player({required this.character, Vector2? position}):super(position: position);
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runinningAnimation;
  final double stepTime = 0.05;
  @override
  FutureOr<void> onLoad() {
    _loadAllAnimation();
    return super.onLoad();
  }

  void _loadAllAnimation() {
    inspect(game.images);
    idleAnimation = _spriteAnimation("Idle",11);
    runinningAnimation = _spriteAnimation("Run",12);
    animations = {PlayerState.idle: idleAnimation,PlayerState.running:runinningAnimation};
    current = PlayerState.running;
  }

  SpriteAnimation _spriteAnimation(String state ,int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache("Main Characters/$character/$state (32x32).png"),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
  }
}
