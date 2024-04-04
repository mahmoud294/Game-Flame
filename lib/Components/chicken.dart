import 'dart:async';
import 'dart:ui';

import 'package:action_adventure/Components/player.dart';
import 'package:action_adventure/action_adventure.dart';
import 'package:flame/components.dart';

enum ChickenState { run, hit, idle }

class Chicken extends SpriteAnimationGroupComponent
    with HasGameRef<ActionAdventure> {
  final double offNeg;
  final double offPos;

  Chicken({
    posision,
    size,
    this.offNeg = 0,
    this.offPos = 0,
  }) : super(position: posision, size: size);

  late SpriteAnimation _idleAnimation;
  late SpriteAnimation _runAnimation;
  late SpriteAnimation _hitAnimation;
  late Player player;
  static const stepTime = 0.05;
  final textureSize = Vector2(32, 34);
  double rangeNeg = 0.0;
  double rangePos = 0.0;
  static const tileSize = 16;
  Vector2 velocity = Vector2.zero();
  double moveDirection = 1;
  double targetDirection = -1;
  @override
  FutureOr<void> onLoad() {
    player = game.player;
    _loadAnimation();
    _calcualteRange();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updateState();
    _movement(dt);
    super.update(dt);
  }

  void _loadAnimation() {
    _idleAnimation = _spriteAnimation("Idle", 13);
    _runAnimation = _spriteAnimation("Run", 14);
    _hitAnimation = _spriteAnimation("Hit", 5)..loop = false;
    animations = {
      ChickenState.idle: _idleAnimation,
      ChickenState.hit: _hitAnimation,
      ChickenState.run: _runAnimation,
    };
    current = ChickenState.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache("Enemies/Chicken/$state (32x34).png"),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: textureSize,
      ),
    );
  }

  void _calcualteRange() {
    rangeNeg = position.x - offNeg * tileSize;
    rangePos = position.x + offPos * tileSize;
  }

  void _movement(double dt) {
    velocity.x = 0;
    double playerOffset = (player.scale.x > 0) ? 0 : -player.width;
    double chickenOffset = (scale.x > 0) ? 0 : -width;
    if (playerINRange()) {
      targetDirection =
          (player.x + playerOffset < position.x + chickenOffset) ? -1 : 1;
      velocity.x = targetDirection * 80;
    }
    moveDirection = lerpDouble(moveDirection, targetDirection, 0.1) ?? 1;
    position.x += velocity.x * dt;
  }

  bool playerINRange() {
    double playerOffset = (player.scale.x > 0) ? 0 : -player.width;
    return player.x + playerOffset >= rangeNeg &&
        player.x + playerOffset <= rangePos &&
        player.y + player.height > position.y &&
        player.y < position.y + height;
  }

  void _updateState() {
    current = (velocity.x != 0) ? ChickenState.run : ChickenState.idle;
    if ((moveDirection > 0 && scale.x > 0) ||
        (moveDirection < 0 && scale.x < 0)) {
      flipHorizontallyAroundCenter();
    }
  }
}
