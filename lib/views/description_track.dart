

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musica/controllers/player_controller.dart';

class DescriptionTrack extends StatelessWidget {
  const DescriptionTrack({super.key});

  @override
  Widget build(BuildContext context) {
    //leyendo el controlador
    Get.find<PlayerController>();
    return Scaffold(
      body: Center(
        child: Icon(Icons.music_note),
      ),
    );
  }
}
