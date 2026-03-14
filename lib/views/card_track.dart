/// Widget de tarjeta que representa una canción en la lista.
///
/// Muestra la portada del álbum, el nombre de la canción, el artista y la
/// duración. Al tocar la tarjeta, abre la pantalla del reproductor
/// ([DescriptionTrack]) y comienza la reproducción de la canción.
///
/// **Patrón de uso:**
/// - [HomeView] crea un [CardTrack] por cada canción en los resultados de
///   búsqueda y en la sección de populares.
/// - Usa [CachedNetworkImage] para cargar la portada desde la URL de iTunes
///   de forma eficiente (almacena la imagen en caché).
///
/// **Navegación:**
/// - Al tocar: registra (si no existe) [PlayerController], llama a
///   [PlayerController.reproducir] y navega a [DescriptionTrack] con `Get.to`.

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musica/controllers/home_controller.dart';
import 'package:musica/controllers/player_controller.dart';
import 'package:musica/models/track_model.dart';
import 'package:musica/views/description_track.dart';

/// Tarjeta visual que representa una canción en la lista de resultados.
///
/// Es un [StatelessWidget] porque no tiene estado propio; toda la lógica
/// de reproducción vive en [PlayerController].
class CardTrack extends StatelessWidget {
  /// La canción cuyos datos se muestran en esta tarjeta.
  final TrackModel cancion;

  const CardTrack({super.key, required this.cancion});

  /// Construye la tarjeta de la canción como un [ListTile] interactivo.
  ///
  /// Envuelve el [ListTile] en un [GestureDetector] para detectar el toque
  /// del usuario y navegar al reproductor.
  ///
  /// **Al tocar la tarjeta:**
  /// 1. Si [PlayerController] no está registrado aún en GetX, lo registra con
  ///    `Get.put(PlayerController())`.
  /// 2. Obtiene el [HomeController] para saber la lista de canciones del contexto
  ///    actual (búsqueda o populares) y el índice de esta canción.
  /// 3. Llama a [PlayerController.reproducir] pasando la canción, la lista y el índice.
  /// 4. Navega a [DescriptionTrack] con `Get.to`.
  ///
  /// **Componentes del ListTile:**
  /// - `leading`: imagen de portada del álbum (60×60 px) con [CachedNetworkImage].
  /// - `title`: nombre de la canción ([TrackModel.trackName]).
  /// - `subtitle`: nombre del artista ([TrackModel.artistName]).
  /// - `trailing`: duración formateada en "mm:ss" + ícono de play.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Registra PlayerController solo si aún no existe en GetX.
        // Esto evita crear múltiples instancias del reproductor.
        if (!Get.isRegistered<PlayerController>()) {
          Get.put(PlayerController());
        }

        // Obtiene el HomeController para determinar la lista de canciones activa.
        final home = Get.find<HomeController>();

        // Si hay una búsqueda activa, usa los resultados de búsqueda;
        // si no, usa las canciones populares.
        final lista = home.ultimaBusqueda.isNotEmpty
            ? home.canciones.toList()
            : home.cancionesPopulares.toList();

        // Encuentra la posición de esta canción en la lista.
        final indice = lista.indexOf(cancion);

        // Inicia la reproducción con el contexto completo de la lista
        // para poder navegar con anterior/siguiente.
        Get.find<PlayerController>()
            .reproducir(cancion, lista: lista, indice: indice);

        // Navega a la pantalla del reproductor.
        Get.to(() => DescriptionTrack());
      },
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 4),

        // Portada del álbum con esquinas redondeadas.
        // CachedNetworkImage descarga la imagen y la guarda en caché local
        // para no volver a descargarla en próximas visualizaciones.
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: cancion.artworkUrl60 != null &&
                  cancion.artworkUrl60!.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: cancion.artworkUrl60!,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  // Mientras carga la imagen muestra el placeholder.
                  placeholder: (_, __) => _placeholderAlbum(context),
                  // Si falla la carga muestra el placeholder con ícono.
                  errorWidget: (_, __, ___) => _placeholderAlbum(context),
                )
              : _placeholderAlbum(context),
        ),

        // Nombre de la canción.
        title: Text(
          cancion.trackName,
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),

        // Nombre del artista.
        subtitle: Text(
          cancion.artistName,
          style: TextStyle(
            fontSize: 13,
          ),
        ),

        // Duración y botón de play al final de la fila.
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Calcula el tiempo en formato "m:ss":
            // trackTimeMillis ~/ 60000 = minutos enteros
            // (trackTimeMillis % 60000) ~/ 1000 = segundos restantes
            Text(
              '${(cancion.trackTimeMillis ~/ 60000)}:${((cancion.trackTimeMillis % 60000) ~/ 1000).toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 8),
            // Ícono decorativo de play (onPressed: null porque el toque
            // se maneja en el GestureDetector padre).
            IconButton(
              icon: const Icon(Icons.play_circle_outline, color: Colors.green),
              onPressed: null,
            ),
          ],
        ),
      ),
    );
  }

  /// Construye un placeholder gris con un ícono de nota musical.
  ///
  /// Se muestra mientras la imagen de la portada carga desde la red,
  /// o si la URL está vacía o hay un error al cargar la imagen.
  ///
  /// **Parámetros:**
  /// - [context]: contexto de Flutter para acceder a los colores del tema.
  ///
  /// **Retorna:** un [Container] cuadrado de 56×56 px con fondo y ícono.
  ///
  /// **Llamado desde:** [build] como `placeholder` y `errorWidget` de
  /// [CachedNetworkImage], y como fallback cuando la URL está vacía.
  Widget _placeholderAlbum(BuildContext context) => Container(
        width: 56,
        height: 56,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Icon(
          Icons.music_note,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
}
