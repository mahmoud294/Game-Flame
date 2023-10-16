import 'dart:async';

import 'package:action_adventure/action_adventure.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

class JumbButton extends SpriteComponent
    with HasGameRef<ActionAdventure>, TapCallbacks {
  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache("HUD/JumpButton.png"));
    position = Vector2(game.size.x - 32 - 64, game.size.y - 32 - 64);
    priority = 10;
    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.player.hasJumped = true;
    super.onTapDown(event);
  }
  @override
  void onTapUp(TapUpEvent event) {
    game.player.hasJumped = false;
    super.onTapUp(event);
  }
}
