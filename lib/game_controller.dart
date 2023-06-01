import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';

class GameController extends GetxController {
  RxList<Object> objects = <Object>[].obs;

  @override
  void onInit() {
    super.onInit();
    createObjects();
  }

  void createObjects() {
    final random = Random();
    final startX = 50.0;
    final startY = 50.0;
    final spacing = Get.width / 6.0; // Adjust the spacing based on screen width

    final objectTypes = [
      ObjectType.Rock,
      ObjectType.Paper,
      ObjectType.Scissors,
    ];

    int index = 0;
    for (int i = 0; i < objectTypes.length; i++) {
      final type = objectTypes[i];
      final color = type == ObjectType.Rock
          ? Colors.grey
          : type == ObjectType.Paper
              ? Colors.blue
              : Colors.red;
      final text = type == ObjectType.Rock
          ? 'Rock'
          : type == ObjectType.Paper
              ? 'Paper'
              : 'Scissors';
      final image = type == ObjectType.Rock
          ? 'assets/rock.png'
          : type == ObjectType.Paper
              ? 'assets/paper.png'
              : 'assets/scissors.png';

      for (int j = 0; j < 5; j++) {
        final position = Offset(
          startX + j * spacing,
          startY + i * spacing,
        );

        objects.add(
          Object(
            type: type,
            color: color,
            text: text,
            image: image,
            position: Rx<Offset>(position),
          ),
        );
        index++;
      }
    }
  }

  void startMoving() {
    objects.forEach((object) {
      final direction = randomDirection();
      moveObject(object, direction);
    });
  }

  void moveObject(Object object, Offset direction) {
    final random = Random();
    final speed = 5.0 + random.nextInt(5);
    final position = object.position.value + direction * speed;

    // Check for collisions with walls
    if (position.dx < 0 || position.dx > Get.width - 50) {
      direction = Offset(-direction.dx, direction.dy);
    }
    if (position.dy < 0 || position.dy > Get.height - 50) {
      direction = Offset(direction.dx, -direction.dy);
    }

    // Check for collisions with other objects
    objects.forEach((otherObject) {
      if (otherObject != object) {
        final objectRect = Rect.fromLTWH(
          position.dx,
          position.dy,
          50,
          50,
        );
        final otherObjectRect = Rect.fromLTWH(
          otherObject.position.value.dx,
          otherObject.position.value.dy,
          50,
          50,
        );

        if (objectRect.overlaps(otherObjectRect)) {
          if (object.type != otherObject.type) {
            checkCollision(object, otherObject);
          } else {
            // Same object type, adjust position to avoid overlap
            checkCollision(object, otherObject);

            // final newDirection = randomDirection();
            // moveObject(object, newDirection);
          }
        }
      }
    });

    object.position.value = position;

    Future.delayed(
        const Duration(milliseconds: 2), () => moveObject(object, direction));
  }

  Offset randomDirection() {
    final random = Random();
    final dx = random.nextDouble() - 0.5;
    final dy = random.nextDouble() - 0.5;
    final magnitude = sqrt(dx * dx + dy * dy);
    return Offset(dx / magnitude, dy / magnitude);
  }

  void checkCollision(Object object1, Object object2) {
    final random = Random();
    final newDirection1 = randomDirection();
    final newDirection2 = randomDirection();

    if (object1.type == object2.type) {
      // Objects of the same type bounce off each other
      object1.position.value -= newDirection1 * 10.0;
      object2.position.value -= newDirection2 * 10.0;
    } else {
      // Handle collision based on object types
      if ((object1.type == ObjectType.Rock &&
              object2.type == ObjectType.Scissors) ||
          (object1.type == ObjectType.Scissors &&
              object2.type == ObjectType.Paper) ||
          (object1.type == ObjectType.Paper &&
              object2.type == ObjectType.Rock)) {
        // object1 wins, remove object2
        objects.remove(object2);
        // Make object1 bounce
        object1.position.value += newDirection1 * 10.0;
      } else {
        // object2 wins, remove object1
        objects.remove(object1);
        // Make object2 bounce
        object2.position.value += newDirection2 * 10.0;
      }
    }
  }
}

enum ObjectType { Rock, Paper, Scissors }

class Object {
  final ObjectType type;
  final Color color;
  final String text;
  final String image;
  final Rx<Offset> position;

  Object({
    required this.type,
    required this.color,
    required this.text,
    required this.image,
    required this.position,
  });
}
