import 'package:flame/components.dart';

class CollissionBlock extends PositionComponent {
  bool isPlatform;
  CollissionBlock({posision, size, this.isPlatform = false})
      : super(position: posision, size: size);
}
