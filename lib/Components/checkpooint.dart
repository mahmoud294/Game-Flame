import 'dart:async';

import 'package:action_adventure/Components/player.dart';
import 'package:action_adventure/action_adventure.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class CheckPoint extends SpriteAnimationComponent
    with HasGameRef<ActionAdventure>, CollisionCallbacks {
  CheckPoint({Vector2? size, Vector2? position})
      : super(size: size, position: position);
  @override
  FutureOr<void> onLoad() {
    animation = SpriteAnimation.fromFrameData(
      game.images
          .fromCache("Items/Checkpoints/Checkpoint/Checkpoint (No Flag).png"),
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: 1,
        textureSize: Vector2.all(64),
      ),
    );
    add(
      RectangleHitbox(
        position: Vector2(18, 56),
        size: Vector2(12, 8),
        collisionType: CollisionType.passive,
      ),
    );
    return super.onLoad();
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    if (other is Player) {
      _reachCheckpoint();
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  void _reachCheckpoint() async {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache(
        "Items/Checkpoints/Checkpoint/Checkpoint (Flag Out) (64x64).png",
      ),
      SpriteAnimationData.sequenced(
        amount: 26,
        stepTime: 0.05,
        textureSize: Vector2.all(64),
        loop: false,
      ),
    );
    await animationTicker?.completed;

    animation = animation = SpriteAnimation.fromFrameData(
      game.images.fromCache(
        "Items/Checkpoints/Checkpoint/Checkpoint (Flag Idle)(64x64).png",
      ),
      SpriteAnimationData.sequenced(
        amount: 10,
        stepTime: 0.05,
        textureSize: Vector2.all(64),
      ),
    );
  }
}
