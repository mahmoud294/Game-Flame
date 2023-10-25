import 'dart:async';

import 'package:action_adventure/Components/checkpooint.dart';
import 'package:action_adventure/Components/chicken.dart';
import 'package:action_adventure/Components/collision_block.dart';
import 'package:action_adventure/Components/fruit_component.dart';
import 'package:action_adventure/Components/player.dart';
import 'package:action_adventure/Components/saw.dart';
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
    _addCollisions();
    _spawningObjects();

    // add(Player(character: "Ninja Frog"));
    return super.onLoad();
  }

  // void _scrollingBackground() {
  //   final backgroundLayer = level.tileMap.getLayer("Background");
  //   if (backgroundLayer != null) {
  //     final backgroundColor =
  //         backgroundLayer.properties.getValue("Backgroundcolor");
  //     final backgroundTile = BackgroundTile(color: backgroundColor,position: Vector2.all(0));
  //   }
  // }

  void _addCollisions() {
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
  }

  void _spawningObjects() {
    final spawnLayer = level.tileMap.getLayer<ObjectGroup>("SpawnLayer");
    if (spawnLayer != null) {
      for (final spawnPoint in spawnLayer.objects) {
        switch (spawnPoint.class_) {
          case "Player":
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            player.firstPosition = Vector2(spawnPoint.x, spawnPoint.y);
            add(player);
            break;
          case "fruit":
            final fruit = Fruit(
              fruitName: spawnPoint.name,
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(fruit);
            break;
          case "Saw":
            final isvertical =
                spawnPoint.properties.getValue("isVertical") as bool;
            final offNeg = spawnPoint.properties.getValue("offNeg") as double;
            final offPos = spawnPoint.properties.getValue("offPos") as double;
            final saw = Saw(
              isVertical: isvertical,
              offNeg: offNeg,
              offPos: offPos,
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(saw);
            break;
          case "Checkpoint":
            final checkPoint = CheckPoint(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(checkPoint);
            break;
          case "Chicken":
            final offNeg = spawnPoint.properties.getValue("offNeg") as double;
            final offPos = spawnPoint.properties.getValue("offPos") as double;

            final chicken = Chicken(
              offNeg: offNeg,
              offPos: offPos,
              posision: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(chicken);
            break;
          default:
        }
      }
    }
  }
}
