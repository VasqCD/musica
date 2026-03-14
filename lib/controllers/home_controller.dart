/// Controlador principal de la pantalla de inicio (HomeView).
///
/// Gestiona el estado reactivo de las listas de canciones y la lógica de búsqueda.
/// Extiende [GetxController] del paquete GetX, lo que permite que las vistas
/// se actualicen automáticamente cuando cambian los datos observables (Rx).
///
/// **Ciclo de vida:**
/// 1. Se registra de forma diferida con `Get.lazyPut<HomeController>(...)` en [main].
/// 2. Cuando [HomeView] se muestra por primera vez, GetX lo instancia y llama a [onInit].
/// 3. [onInit] llama a [cargarPopulares] para mostrar canciones al abrir la app.
/// 4. Las búsquedas del usuario pasan por [buscarCancionDebounce] →  [buscarCanciones].
///
/// **Llamado desde:** [HomeView], [CardTrack].

import 'dart:async';

import 'package:get/get.dart';
import 'package:musica/models/track_model.dart';
import 'package:musica/services/itunes_service.dart';

/// Controlador GetX para la pantalla principal de la app.
///
/// Contiene los datos reactivos (Rx) que [HomeView] observa para reconstruir
/// la interfaz cuando cambian (mediante el widget [Obx]).
class HomeController extends GetxController {
  /// Referencia al servicio de iTunes registrado en el contenedor de GetX.
  ///
  /// Se obtiene con [Get.find] porque [ItunesService] fue registrado antes
  /// en [main] con `Get.put(ItunesService())`.
  final ItunesService _servicio = Get.find<ItunesService>();

  /// Lista reactiva de canciones devueltas por la búsqueda del usuario.
  ///
  /// El sufijo `.obs` convierte la lista en un [RxList], lo que significa
  /// que cualquier widget envuelto en [Obx] que lea esta variable se
  /// reconstruirá automáticamente al cambiar su contenido.
  ///
  /// Se actualiza en [buscarCanciones] y se limpia en [buscarCancionDebounce]
  /// cuando el campo de búsqueda está vacío.
  final RxList<TrackModel> canciones = <TrackModel>[].obs;

  /// Lista reactiva de canciones populares cargadas al iniciar la app.
  ///
  /// Se llena en [cargarPopulares] con canciones del género Rock.
  /// [HomeView] la muestra cuando el usuario no ha escrito nada en la búsqueda.
  final RxList<TrackModel> cancionesPopulares = <TrackModel>[].obs;

  /// Indicador reactivo de carga.
  ///
  /// Es `true` mientras se espera la respuesta de la API.
  /// [HomeView] puede usarlo para mostrar un indicador de progreso.
  final RxBool cargando = false.obs;

  /// Mensaje de error reactivo.
  ///
  /// Si ocurre un error en la petición HTTP, este campo contiene la descripción.
  /// Cuando está vacío (`''`) no hay error activo.
  final RxString mensajeError = ''.obs;

  /// Texto de la última búsqueda realizada por el usuario.
  ///
  /// Permite que [HomeView] sepa si debe mostrar los resultados de búsqueda
  /// o las canciones populares. Si está vacío, se muestran las populares.
  final RxString ultimaBusqueda = ''.obs;

  /// Temporizador interno para implementar el debounce de búsqueda.
  ///
  /// El debounce evita hacer una petición HTTP por cada letra que escribe
  /// el usuario. Se cancela y reinicia con cada pulsación de tecla,
  /// disparando la búsqueda solo cuando el usuario hace una pausa de 1 segundo.
  Timer? debounceBusqueda;

  /// Se ejecuta automáticamente cuando GetX instancia este controlador.
  ///
  /// Llama a [cargarPopulares] para mostrar canciones en la pantalla inicial
  /// antes de que el usuario haga cualquier búsqueda.
  ///
  /// **Llamado por:** GetX internamente al crear el controlador.
  @override
  void onInit() {
    super.onInit();
    cargarPopulares();
  }

  /// Carga una selección de canciones populares del género Rock desde iTunes.
  ///
  /// Llama a [ItunesService.buscarCanciones] con el término `'rock'`,
  /// un límite de 20 canciones y el atributo `'genreTerm'` para filtrar
  /// por género musical.
  ///
  /// Si la petición es exitosa, actualiza [cancionesPopulares].
  /// Si falla, establece un mensaje en [mensajeError].
  ///
  /// **Llamado desde:** [onInit].
  Future<void> cargarPopulares() async {
    try {
      final resultados = await _servicio.buscarCanciones(
        'rock',
        limite: 20,
        atributo: 'genreTerm',
      );
      cancionesPopulares.value = resultados;
    } catch (e) {
      mensajeError.value = 'Error al cargar canciones populares';
    }
  }

  /// Inicia una búsqueda con retraso (debounce) para evitar peticiones excesivas.
  ///
  /// Se llama cada vez que el usuario escribe o borra un carácter en
  /// [SearchBarCustom]. El debounce espera 1 segundo sin actividad antes
  /// de llamar a [buscarCanciones], reduciendo la cantidad de peticiones HTTP.
  ///
  /// Si [consulta] está vacía o solo tiene espacios:
  /// - Limpia [ultimaBusqueda] y [canciones].
  /// - Borra cualquier mensaje de error.
  /// - Cancela el temporizador pendiente.
  ///
  /// **Parámetros:**
  /// - [consulta]: texto actual del campo de búsqueda.
  ///
  /// **Llamado desde:** [SearchBarCustom._alBuscar] y [SearchBarCustom._limpiar].
  void buscarCancionDebounce(String consulta) {
    if (consulta.trim().isEmpty) {
      ultimaBusqueda.value = '';
      canciones.clear();
      mensajeError.value = '';
      return;
    }

    ultimaBusqueda.value = consulta;
    // Cancela el temporizador anterior si el usuario sigue escribiendo.
    debounceBusqueda?.cancel();
    // Inicia un nuevo temporizador de 1 segundo.
    debounceBusqueda = Timer(const Duration(milliseconds: 1000), () {
      buscarCanciones(consulta);
    });
  }

  /// Realiza la petición de búsqueda a la API de iTunes.
  ///
  /// Pone [cargando] en `true` mientras espera la respuesta, actualiza
  /// [canciones] con los resultados o captura cualquier error en [mensajeError].
  /// Al terminar (con éxito o fallo) pone [cargando] en `false`.
  ///
  /// **Parámetros:**
  /// - [consulta]: texto de búsqueda enviado a [ItunesService.buscarCanciones].
  ///
  /// **Llamado desde:** [buscarCancionDebounce] (dentro del temporizador).
  Future<void> buscarCanciones(String consulta) async {
    cargando.value = true;
    mensajeError.value = '';
    try {
      final resultados = await _servicio.buscarCanciones(consulta);
      canciones.value = resultados;
    } catch (e) {
      mensajeError.value = e.toString();
      canciones.clear();
    }

    cargando.value = false;
  }
}

