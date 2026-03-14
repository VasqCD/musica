

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musica/controllers/home_controller.dart';
import 'package:musica/core/theme/app_theme.dart';
import 'package:musica/services/itunes_service.dart';
import 'package:musica/views/home_view.dart';

void main(){
  //inyectando el controlador de ItunesServices
  Get.put(ItunesService());
  runApp(MusicPlayer());
}

class MusicPlayer extends StatelessWidget {
  const MusicPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'MusicPlayer',
      theme: AppTheme.light,
      home: HomeView(),
      //inyectando el controlador
      initialBinding: 
          BindingsBuilder(() =>
           Get.lazyPut<HomeController>(HomeController.new) ),
    );
  }
}




