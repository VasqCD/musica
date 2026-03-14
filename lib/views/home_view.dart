
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musica/controllers/home_controller.dart';
import 'package:musica/views/card_track.dart';
import 'package:musica/views/search_bar.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    //leyendo el home controller
    final controller = Get.find<HomeController>();
    return Scaffold(
      body: SafeArea(// impide que se monte contenido en zonas prohibidas ej.appbar
        child: CustomScrollView( // permite hacer scroll
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Explorar',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        ),
                    ),
                    SizedBox(height: 10),
                    Text('Descubre más música en iTunes',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SearchBarCustom(homeController: controller,),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 24,),
            ),
            Obx(() => _construirContenido(context, controller))
          ],
        )
      ),
    );
  }

 // funcion que retorna un widget
 //recibimos el controlador HomeController
 //HomeController tenemos el llamado al servicio de Itunes
 //Dentro del servicio, tenemos la peticion HTTP
  Widget _construirContenido(BuildContext context,HomeController controlador){

    // Estado búsqueda activa con texto
    if (controlador.ultimaBusqueda.isNotEmpty) {

      if (controlador.mensajeError.isNotEmpty) {
        return SliverFillRemaining(
          child: Center(child: Text(controlador.mensajeError.value)),
        );
      }

      if (controlador.canciones.isEmpty) {
        return SliverFillRemaining(
          child: Center(child: Text('No hay canciones')),
        );
      }

      return SliverMainAxisGroup(slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('Resultados de búsqueda',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25)),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 20)),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, indice) => CardTrack(cancion: controlador.canciones[indice]),
            childCount: controlador.canciones.length,
          ),
        ),
      ]);
    }

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
            child: Text(
              'Popular',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: 25
                ),
              ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(height: 20),
        ),
        SliverList(delegate: SliverChildBuilderDelegate(
          (context, indice) => CardTrack(cancion: controlador.cancionesPopulares[indice]),
          childCount: controlador.cancionesPopulares.length
        )
        )

      ]
    );
  }
}


