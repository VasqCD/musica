
import 'package:get/get.dart';
import 'package:musica/models/album_model.dart';
import 'package:musica/services/itunes_service.dart';

class AlbumController extends GetxController {

  final ItunesService _servicio = Get.find<ItunesService>();

  final int artistId;
  final String artistName;

  AlbumController({required this.artistId, required this.artistName});

  final RxList<AlbumModel> albumes = <AlbumModel>[].obs;
  final RxBool cargando = false.obs;
  final RxString mensajeError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    cargarAlbumes();
  }

  Future<void> cargarAlbumes() async {
    cargando.value = true;
    mensajeError.value = '';
    try {
      final resultados = await _servicio.buscarAlbumesArtista(artistId);
      albumes.value = resultados;
    } catch (e) {
      mensajeError.value = 'Error al cargar álbumes';
    }
    cargando.value = false;
  }
}
