import 'dart:async';

import 'package:action_adventure/Components/checkpooint.dart';
import 'package:action_adventure/Components/collision_block.dart';
import 'package:action_adventure/Components/custom_hitbox.dart';
import 'package:action_adventure/Components/fruit_component.dart';
import 'package:action_adventure/Components/saw.dart';
import 'package:action_adventure/Components/util.dart';
import 'package:action_adventure/action_adventure.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';

enum PlayerState {
  idle,
  running,
  jumping,
  falling,
  disappearing,
  appearing,
  fading
}

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<ActionAdventure>, KeyboardHandler, CollisionCallbacks {
  String character;
  bool died = false;

  Player({
    position,
    this.character = 'Ninja Frog',
  }) : super(position: position);
  bool loading = false;
  bool reachedCheckedPoint = false;
  Vector2? firstPosition;
  final double stepTime = 0.05;
  late final SpriteAnimation appearingAnimation;
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation jumpingAnimation;
  late final SpriteAnimation fallingAnimation;
  late final SpriteAnimation disappearingAnimation;
  late final SpriteAnimation fadingAnimation;

  final double _gravity = 9.8;
  final double _jumpForce = 280;
  final double _terminalVelocity = 300;
  double horizontalMovement = 0;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();
  bool isOnGround = false;
  bool hasJumped = false;
  List<CollissionBlock> collisionBlocks = [];
  CustomHitBox hitbox = CustomHitBox(
    offsetX: 10,
    offsetY: 4,
    width: 14,
    height: 28,
  );

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    // debugMode = true;
    add(
      RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height),
      ),
    );
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (!died && !reachedCheckedPoint) {
      _updatePlayerState();
      _updatePlayerMovement(dt);
      _checkHorizontalCollisions();
      _applyGravity(dt);
      _checkVerticalCollisions();
    }
    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    horizontalMovement += isLeftKeyPressed ? -1 : 0;
    horizontalMovement += isRightKeyPressed ? 1 : 0;

    hasJumped = keysPressed.contains(LogicalKeyboardKey.space);

    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Fruit) {
      other.onCollidedFruit();
    } else if (other is Saw) {
      _respawn();
    } else if (other is CheckPoint) {
      _reachCheckPoint();
    }
    super.onCollision(intersectionPoints, other);
  }

  void _loadAllAnimations() {
    idleAnimation = _spriteAnimation('Idle', 11);
    runningAnimation = _spriteAnimation('Run', 12);
    jumpingAnimation = _spriteAnimation('Jump', 1);
    fallingAnimation = _spriteAnimation('Fall', 1);
    disappearingAnimation = _spriteAnimation("Hit", 7);
    appearingAnimation = _appearingAnimation();
    fadingAnimation = _fadingAnimation();

    // List of all animations
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
      PlayerState.jumping: jumpingAnimation,
      PlayerState.falling: fallingAnimation,
      PlayerState.disappearing: disappearingAnimation,
      PlayerState.appearing: appearingAnimation,
      PlayerState.fading: fadingAnimation,
    };

    current = PlayerState.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/$character/$state (32x32).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
  }

  SpriteAnimation _appearingAnimation() {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/Appearing (96x96).png'),
      SpriteAnimationData.sequenced(
        amount: 7,
        stepTime: stepTime,
        textureSize: Vector2.all(96),
      ),
    );
  }

  SpriteAnimation _fadingAnimation() {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/Desappearing (96x96).png'),
      SpriteAnimationData.sequenced(
        amount: 7,
        stepTime: stepTime,
        textureSize: Vector2.all(96),
      ),
    );
  }

  void _updatePlayerState() {
    // if(loading){

    // }
    PlayerState playerState = PlayerState.idle;

    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    // Check if moving, set running
    if (velocity.x > 0 || velocity.x < 0) playerState = PlayerState.running;

    // check if Falling set to falling
    if (velocity.y > 0) playerState = PlayerState.falling;

    // Checks if jumping, set to jumping
    if (velocity.y < 0) playerState = PlayerState.jumping;
    // if (died) playerState = PlayerState.disappearing;
    current = playerState;
  }

  void _updatePlayerMovement(double dt) {
    if (hasJumped && isOnGround) _playerJump(dt);

    // if (velocity.y > _gravity) isOnGround = false; // optional

    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }

  void _playerJump(double dt) {
    velocity.y = -_jumpForce;
    position.y += velocity.y * dt;
    isOnGround = false;
    hasJumped = false;
  }

  void _checkHorizontalCollisions() {
    for (final block in collisionBlocks) {
      if (!block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.x > 0) {
            velocity.x = 0;
            position.x = block.x - hitbox.offsetX - hitbox.width;
            break;
          }
          if (velocity.x < 0) {
            velocity.x = 0;
            position.x = block.x + block.width + hitbox.width + hitbox.offsetX;
            break;
          }
        }
      }
    }
  }

  void _applyGravity(double dt) {
    velocity.y += _gravity;
    velocity.y = velocity.y.clamp(-_jumpForce, _terminalVelocity);
    position.y += velocity.y * dt;
  }

  void _checkVerticalCollisions() {
    for (final block in collisionBlocks) {
      if (block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            break;
          }
        }
      } else {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            break;
          }
          if (velocity.y < 0) {
            velocity.y = 0;
            position.y = block.y + block.height - hitbox.offsetY;
          }
        }
      }
    }
  }

  void _respawn() {
    died = true;
    current = PlayerState.disappearing;
    Future.delayed(
      const Duration(milliseconds: 350),
      () {
        scale.x = 1;
        position =
            Vector2(firstPosition!.x, firstPosition!.y) - Vector2.all(32);
        current = PlayerState.appearing;
        Future.delayed(const Duration(milliseconds: 350), () {
          velocity = Vector2.zero();
          position = Vector2(firstPosition!.x, firstPosition!.y);
          _updatePlayerState();
          Future.delayed(
            const Duration(milliseconds: 400),
            () => died = false,
          );
        });
      },
    );
  }

  void _reachCheckPoint() {
    reachedCheckedPoint = true;
    if (scale.x > 0) {
      position = position - Vector2.all(32);
    } else if (scale.x < 0) {
      position = position + Vector2(32, -32);
    }
    current = PlayerState.fading;
    Future.delayed(
      const Duration(milliseconds: 350),
      () {
        reachedCheckedPoint = false;
        position = Vector2.all(-640);
        Future.delayed(
          const Duration(seconds: 3),
          () {},
        );
      },
    );
  }
}
