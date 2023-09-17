import 'dart:async';

import 'package:action_adventure/Components/collision_block.dart';
import 'package:action_adventure/Components/player.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Level1 extends World {
  final Player player;
  final String levelName;
  Level1({required this.player, required this.levelName});
  late TiledComponent level;
  List<CollissionBlock> collisionBlocks = [];
  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load("$levelName.tmx", Vector2.all(16));
    add(level);
    final spawnLayer = level.tileMap.getLayer<ObjectGroup>("SpawnLayer");
    if (spawnLayer != null) {
      for (final spawnPoint in spawnLayer.objects) {
        switch (spawnPoint.class_) {
          case "Player":
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            add(player);
            break;
          default:
        }
      }
    }
    final collisionLayer = level.tileMap.getLayer<ObjectGroup>("Collisions");
    if (collisionLayer != null) {
      for (final coillision in collisionLayer.objects) {
        switch (coillision.class_) {
          case "Platform":
            final platform = CollissionBlock(
              isPlatform: true,
              posision: Vector2(coillision.x, coillision.y),
              size: Vector2(coillision.width, coillision.height),
            );
            collisionBlocks.add(platform);
            add(platform);
            break;
          default:
            final block = CollissionBlock(
              posision: Vector2(coillision.x, coillision.y),
              size: Vector2(coillision.width, coillision.height),
            );
            collisionBlocks.add(block);
            add(block);
        }
      }
      player.collisionBlocks = collisionBlocks;
    }
    // add(Player(character: "Ninja Frog"));
    return super.onLoad();
  }
}
