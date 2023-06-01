import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';

import 'game_controller.dart';

class GamePage extends StatelessWidget {
  final GameController controller = Get.put(GameController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rock Paper Scissors'),
      ),
      body: Obx(
        () => Stack(
          children: [
            for (final object in controller.objects)
              Positioned(
                left: object.position.value.dx,
                top: object.position.value.dy,
                child: GestureDetector(
                  onTap: () {
                    // Handle object tap
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    color: object.color,
                    child: Image.asset(
                      object.image,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.startMoving,
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}
