/// Controlador del reproductor de audio.
///
/// Gestiona todo el estado reactivo relacionado con la reproducción de música:
/// canción actual, posición de reproducción, duración, estado play/pause,
/// navegación entre canciones y control del hardware de audio.
///
/// Usa el paquete `audioplayers` para reproducir las vistas previas de 30 segundos
/// de iTunes a través de la URL almacenada en [TrackModel.previewUrl].
///
/// **Ciclo de vida:**
/// 1. Se registra con `Get.put(PlayerController())` en [CardTrack] cuando el usuario
///    toca una canción por primera vez.
/// 2. [onInit] recibe la canción inicial desde `Get.arguments` y comienza la reproducción.
/// 3. [DescriptionTrack] lee el estado reactivo del controlador para actualizar la UI.
/// 4. [onClose] libera los recursos del reproductor cuando se destruye el controlador.

import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:musica/models/track_model.dart';

/// Controlador GetX que encapsula la lógica del reproductor de audio.
///
/// Se crea la primera vez que el usuario toca una canción en [CardTrack]
/// y persiste durante toda la sesión de la app.
class PlayerController extends GetxController {
  /// Instancia del reproductor de audio del paquete `audioplayers`.
  ///
  /// Permite reproducir, pausar, reanudar, adelantar y navegar en el audio.
  final AudioPlayer _reproductor = AudioPlayer();

  /// Canción actualmente seleccionada para reproducir.
  ///
  /// Es reactiva (`Rx`) para que [DescriptionTrack] se reconstruya
  /// automáticamente cuando cambia de canción.
  /// El valor puede ser `null` si aún no se ha seleccionado ninguna canción.
  final Rx<TrackModel?> cancion = Rx<TrackModel?>(null);

  /// Lista de canciones del contexto actual (resultados de búsqueda o populares).
  ///
  /// Permite navegar con [cancionAnterior] y [cancionSiguiente].
  List<TrackModel> _lista = [];

  /// Índice de la canción actual dentro de [_lista].
  int _indiceActual = 0;

  /// Indica si el reproductor está reproduciendo activamente.
  ///
  /// Es `true` cuando el estado del reproductor es [PlayerState.playing].
  /// [DescriptionTrack] usa este valor para mostrar el ícono de pausa o reproducción.
  final RxBool estaReproduciendo = false.obs;

  /// Indica si el audio está siendo cargado/bufferizado.
  ///
  /// Es `true` entre el momento en que se solicita la reproducción y cuando
  /// el audio comienza a sonar. [DescriptionTrack] muestra un
  /// [CircularProgressIndicator] mientras sea `true`.
  final RxBool cargando = false.obs;

  /// Mensaje de error reactivo.
  ///
  /// Contiene una descripción del error si la reproducción falla
  /// (p. ej. URL de audio vacía o error de red).
  final RxString mensajeError = ''.obs;

  /// Posición actual de reproducción dentro de la canción.
  ///
  /// Se actualiza continuamente mientras el audio avanza.
  /// [DescriptionTrack] la usa para el [Slider] de progreso y para
  /// mostrar el tiempo transcurrido.
  final Rx<Duration> posicion = Duration.zero.obs;

  /// Duración total de la canción en reproducción.
  ///
  /// Puede ser `null` si el reproductor aún no ha cargado los metadatos del audio.
  /// [DescriptionTrack] la usa como valor máximo del [Slider].
  final Rx<Duration?> duracion = Rx<Duration?>(null);

  /// Se ejecuta automáticamente cuando GetX instancia este controlador.
  ///
  /// Lee `Get.arguments` para obtener la [TrackModel] que se debe reproducir
  /// (pasada desde [CardTrack] mediante [Get.to]) y llama a [_cargarYReproducir].
  /// También inicia los listeners del reproductor con [_escucharReproductor].
  ///
  /// **Llamado por:** GetX internamente al crear el controlador.
  @override
  void onInit() {
    final argumentos = Get.arguments;
    if (argumentos is TrackModel) {
      cancion.value = argumentos;
      _cargarYReproducir(argumentos);
    }
    _escucharReproductor();
    super.onInit();
  }

  /// Suscribe este controlador a los eventos del reproductor de audio.
  ///
  /// Escucha tres streams de `audioplayers`:
  /// - `onPositionChanged`: actualiza [posicion] con el tiempo transcurrido.
  /// - `onDurationChanged`: actualiza [duracion] cuando se conoce la duración del audio.
  /// - `onPlayerStateChanged`: actualiza [estaReproduciendo] y resetea [posicion]
  ///   cuando la canción termina ([PlayerState.stopped]).
  ///
  /// **Llamado desde:** [onInit].
  void _escucharReproductor() {
    _reproductor.onPositionChanged.listen((pos) => posicion.value = pos);
    _reproductor.onDurationChanged.listen((dur) => duracion.value = dur);
    _reproductor.onPlayerStateChanged.listen((estado) {
      estaReproduciendo.value = estado == PlayerState.playing;
      if (estado == PlayerState.stopped) {
        estaReproduciendo.value = false;
        posicion.value = Duration.zero;
      }
    });
  }

  /// Carga la URL de audio y comienza la reproducción.
  ///
  /// Verifica que [TrackModel.previewUrl] no esté vacío antes de intentar
  /// reproducir. Si lo está, establece un mensaje en [mensajeError] y retorna.
  ///
  /// Usa `_reproductor.play(UrlSource(...))` del paquete `audioplayers`
  /// para cargar y reproducir el audio directamente desde la URL de iTunes.
  ///
  /// **Parámetros:**
  /// - [cancionTrack]: el modelo de canción con la URL de la vista previa.
  ///
  /// **Llamado desde:** [onInit], [reproducir].
  Future<void> _cargarYReproducir(TrackModel cancionTrack) async {
    if (cancionTrack.previewUrl.isEmpty) {
      mensajeError.value = 'No hay URL de audio disponible';
      return;
    }
    try {
      mensajeError.value = '';
      cargando.value = true;
      await _reproductor.play(UrlSource(cancionTrack.previewUrl));
    } catch (e) {
      mensajeError.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      cargando.value = false;
    }
  }

  /// Cambia la canción actual y comienza su reproducción.
  ///
  /// Acepta opcionalmente una [lista] completa de canciones y el [indice]
  /// de la canción a reproducir para habilitar la navegación con
  /// [cancionAnterior] y [cancionSiguiente].
  ///
  /// **Parámetros:**
  /// - [track]: canción a reproducir.
  /// - [lista]: lista completa de canciones del contexto actual (opcional).
  /// - [indice]: posición de [track] dentro de [lista] (opcional).
  ///
  /// **Llamado desde:** [CardTrack.build] cuando el usuario toca una canción,
  /// y desde [cancionAnterior] / [cancionSiguiente].
  void reproducir(TrackModel track, {List<TrackModel>? lista, int? indice}) {
    if (lista != null) _lista = lista;
    if (indice != null) _indiceActual = indice;
    cancion.value = track;
    _cargarYReproducir(track);
  }

  /// Navega a la canción anterior en [_lista].
  ///
  /// No hace nada si la lista está vacía o si ya estamos en la primera canción.
  ///
  /// **Llamado desde:** [DescriptionTrack] al hacer doble tap en el botón anterior.
  void cancionAnterior() {
    if (_lista.isEmpty || _indiceActual <= 0) return;
    _indiceActual--;
    reproducir(_lista[_indiceActual]);
  }

  /// Navega a la siguiente canción en [_lista].
  ///
  /// No hace nada si la lista está vacía o si ya estamos en la última canción.
  ///
  /// **Llamado desde:** [DescriptionTrack] al hacer doble tap en el botón siguiente.
  void cancionSiguiente() {
    if (_lista.isEmpty || _indiceActual >= _lista.length - 1) return;
    _indiceActual++;
    reproducir(_lista[_indiceActual]);
  }

  /// Alterna entre reproducir y pausar la canción actual.
  ///
  /// Si [estaReproduciendo] es `true`, llama a `_reproductor.pause()`.
  /// Si es `false`, llama a `_reproductor.resume()` para continuar desde
  /// la posición actual.
  ///
  /// No hace nada si [cancion] es `null` (no hay canción cargada).
  ///
  /// **Llamado desde:** [DescriptionTrack] al presionar el botón play/pause.
  Future<void> alternarPlayPause() async {
    if (cancion.value == null) return;
    if (estaReproduciendo.value) {
      await _reproductor.pause();
    } else {
      await _reproductor.resume();
    }
  }

  /// Mueve la posición de reproducción al tiempo especificado.
  ///
  /// Usa `_reproductor.seek(pos)` para saltar a cualquier punto dentro
  /// de la canción.
  ///
  /// **Parámetros:**
  /// - [pos]: duración (tiempo) al que saltar.
  ///
  /// **Llamado desde:** [DescriptionTrack] cuando el usuario arrastra el [Slider].
  Future<void> irA(Duration pos) async {
    await _reproductor.seek(pos);
  }

  /// Reinicia la canción al principio (posición cero).
  ///
  /// **Llamado desde:** [DescriptionTrack] al presionar el botón de anterior
  /// (toque simple → reinicia; doble tap → canción anterior).
  Future<void> reiniciar() async {
    await _reproductor.seek(Duration.zero);
  }

  /// Adelanta la reproducción el número de segundos indicado.
  ///
  /// Calcula la nueva posición sumando [segundos] a [posicion].
  /// Si la nueva posición supera la duración total, se queda en el límite final.
  ///
  /// **Parámetros:**
  /// - [segundos]: cuántos segundos adelantar. Por defecto 10.
  ///
  /// **Llamado desde:** [DescriptionTrack] al presionar el botón siguiente
  /// (toque simple → adelanta 10 s; doble tap → canción siguiente).
  Future<void> adelantar({int segundos = 10}) async {
    final nueva = posicion.value + Duration(seconds: segundos);
    final limite = duracion.value ?? Duration.zero;
    await _reproductor.seek(nueva < limite ? nueva : limite);
  }

  /// Libera los recursos del reproductor cuando se destruye el controlador.
  ///
  /// Llama a `_reproductor.dispose()` para liberar el hardware de audio
  /// del sistema operativo y evitar fugas de memoria.
  ///
  /// **Llamado por:** GetX internamente cuando el controlador ya no es necesario.
  @override
  void onClose() {
    _reproductor.dispose();
    super.onClose();
  }
}
