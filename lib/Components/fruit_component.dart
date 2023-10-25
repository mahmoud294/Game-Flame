import 'dart:async';

import 'package:action_adventure/Components/custom_hitbox.dart';
import 'package:action_adventure/action_adventure.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';

class Fruit extends SpriteAnimationComponent
    with HasGameRef<ActionAdventure>, CollisionCallbacks {
  final String fruitName;
  Fruit({Vector2? position, this.fruitName = "Apple", Vector2? size})
      : super(position: position, size: size);
  final stepTime = 0.05;
  final hitBox = CustomHitBox(offsetX: 10, offsetY: 10, width: 12, height: 12);
  bool isCollected = false;
  @override
  FutureOr<void> onLoad() {
    add(
      RectangleHitbox(
        position: Vector2(hitBox.offsetX, hitBox.offsetY),
        size: Vector2(hitBox.width, hitBox.height),
        collisionType: CollisionType.passive,
      ),
    );
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache("Items/Fruits/$fruitName.png"),
      SpriteAnimationData.sequenced(
        amount: 17,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
    return super.onLoad();
  }

  void onCollidedFruit() async {
    if (!isCollected) {
      isCollected = true;
      FlameAudio.play("pickupCoin.wav", volume: game.soundVolume);

      animation = SpriteAnimation.fromFrameData(
        game.images.fromCache("Items/Fruits/Collected.png"),
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: stepTime,
          textureSize: Vector2.all(32),
          loop: false,
        ),
      );
      await animationTicker?.completed;
      removeFromParent();
    }
  }
}
