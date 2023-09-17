import 'dart:async';

import 'package:action_adventure/action_adventure.dart';
import 'package:flame/components.dart';

class BackgroundTile extends SpriteComponent with HasGameRef<ActionAdventure> {
  final String color;
  BackgroundTile({this.color = "Gray", Vector2? position})
      : super(position: position);

  @override
  FutureOr<void> onLoad() {
    size = Vector2.all(64);
    sprite = Sprite(game.images.fromCache("Background/$color.png"));
    return super.onLoad();
  }
}
