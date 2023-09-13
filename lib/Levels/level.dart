import 'dart:async';

import 'package:action_adventure/actors/player.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Level1 extends World {
  late TiledComponent level;
  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load("level-01.tmx", Vector2.all(16));
    add(level);
    final spawnLayer = level.tileMap.getLayer<ObjectGroup>("SpawnLayer");
    for (final spawnPoint in spawnLayer!.objects) {
      switch (spawnPoint.class_) {
        case "Player":
          final player = Player(
            character: "Ninja Frog",
            position: Vector2(spawnPoint.x, spawnPoint.y),
          );
          add(player);

          break;
        default:
      }
    }
    // add(Player(character: "Ninja Frog"));
    return super.onLoad();
  }
}
