import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:musica/models/track_model.dart';


class PlayerController extends GetxController {
  //instancia para reproducir musica
  final AudioPlayer _reproductor = AudioPlayer();

  //cancion a reproducir
  final Rx<TrackModel?> cancion = Rx<TrackModel?>(null);
  
  //flag cuando esta reproduciendo una cancion
  final RxBool estaReproduciendo = false.obs;

  final RxBool cargando = false.obs;
  final RxString mensajeError = ''.obs;
  //variables de estado de avance de la cancion
  final Rx<Duration> posicion = Duration.zero.obs;
  final Rx<Duration?> duracion = Rx<Duration?>(null);

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

  /// Reproduce una canción (público para llamar desde la vista).
  void reproducir(TrackModel track) {
    cancion.value = track;
    _cargarYReproducir(track);
  }

  Future<void> alternarPlayPause() async {
    if (cancion.value == null) return;
    if (estaReproduciendo.value) {
      await _reproductor.pause();
    } else {
      await _reproductor.resume();
    }
  }

  Future<void> irA(Duration pos) async {
    await _reproductor.seek(pos);
  }

  @override
  void onClose() {
    _reproductor.dispose();
    super.onClose();
  }
}
