import 'dart:async';

import 'package:action_adventure/action_adventure.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Saw extends SpriteAnimationComponent with HasGameRef<ActionAdventure> {
  final bool isVertical;
  final double offNeg;
  final double offPos;
  Saw({
    Vector2? size,
    Vector2? position,
    this.isVertical = false,
    this.offNeg = 0,
    this.offPos = 0,
  }) : super(size: size, position: position);
  final tileSize = 16;
  final moveSpeed = 50;
  double negRange = 0;
  double posRange = 0;
  int moveDirection = 1;
  @override
  FutureOr<void> onLoad() {
    debugMode = true;
    add(
      RectangleHitbox(
        collisionType: CollisionType.passive,
      ),
    );
    priority = -20;
    if (isVertical) {
      negRange = position.y - offNeg * tileSize;
      posRange = position.y + offPos * tileSize;
    } else {
      negRange = position.x - offNeg * tileSize;
      posRange = position.x + offPos * tileSize;
    }
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache("Traps/Saw/On (38x38).png"),
      SpriteAnimationData.sequenced(
        amount: 8,
        stepTime: 0.03,
        textureSize: Vector2.all(38),
      ),
    );
    return super.onLoad();
  }

  @override
  void update(double dt) {
    moving(dt);
    super.update(dt);
  }

  void moving(double dt) {
    if (isVertical) {
      if (position.y >= posRange) {
        animation = animation!.reversed();
        moveDirection = -1;
      } else if (position.y <= negRange) {
        animation = animation!.reversed();
        moveDirection = 1;
      }
      position.y += moveDirection * moveSpeed * dt;
    } else {
      if (position.x >= posRange) {
        animation = animation!.reversed();
        moveDirection = -1;
      } else if (position.x <= negRange) {
        animation = animation!.reversed();
        moveDirection = 1;
      }
      position.x += moveDirection * moveSpeed * dt;
    }
  }
}
