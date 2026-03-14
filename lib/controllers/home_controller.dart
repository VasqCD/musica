

import 'dart:async';

import 'package:get/get.dart';
import 'package:musica/models/track_model.dart';
import 'package:musica/services/itunes_service.dart';

class HomeController extends GetxController {

  //leyendo el servicio de itunes
  final ItunesService _servicio =
      Get.find<ItunesService>();

  //Rx programacion reactiva, el valor ira cambiando
  final RxList<TrackModel> canciones = <TrackModel>[].obs;
  final RxList<TrackModel> cancionesPopulares = <TrackModel>[].obs;
  final RxBool cargando = false.obs;
  final RxString mensajeError = ''.obs;
  final RxString ultimaBusqueda = ''.obs;
  
  //variable para busquedas pausadas
  Timer? debounceBusqueda;

  @override
  void onInit() {
    super.onInit();
    cargarPopulares();
  }

  Future<void> cargarPopulares() async {
    try {
      final resultados = await _servicio.buscarCanciones('popular', limite: 20);
      cancionesPopulares.value = resultados;
    } catch (e) {
      mensajeError.value = 'Error al cargar canciones populares';
    }
  }
  
  void buscarCancionDebounce(String consulta){
    if (consulta.trim().isEmpty) {
    ultimaBusqueda.value = '';
    canciones.clear();
    mensajeError.value = '';
    return;
  }

    ultimaBusqueda.value = consulta;
    debounceBusqueda?.cancel();
    debounceBusqueda = Timer(const Duration(milliseconds: 1000), (){
      buscarCanciones(consulta);
    });

  }

  Future<void> buscarCanciones(String consulta) async{

    cargando.value = true;
    mensajeError.value = '';
    try{
      final resultados = await _servicio.buscarCanciones(consulta);
      canciones.value = resultados;
    }
    catch(e){
      mensajeError.value = e.toString();
      canciones.clear();
    }

    cargando.value = false;


  }
  




}


