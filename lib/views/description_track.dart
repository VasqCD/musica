/// Pantalla del reproductor de música con detalle de la canción.
///
/// Muestra la portada ampliada del álbum, el nombre de la canción y del artista,
/// un slider de progreso de reproducción y los botones de control de audio.
///
/// **Dependencias:**
/// - [PlayerController]: provee el estado reactivo (posición, duración, etc.)
///   y los métodos de control (play, pausa, siguiente, anterior).
/// - [CachedNetworkImage]: carga la portada del álbum desde la URL de iTunes
///   sustituyendo el tamaño "100x100" por "600x600" para mayor resolución.
///
/// **Navegación:**
/// - Se accede desde [CardTrack] cuando el usuario toca una canción.
/// - El botón de flecha atrás (`←`) regresa a [HomeView] con `Get.back()`.
///
/// **Interacciones del usuario:**
/// - Arrastrar el [Slider] → llama a [PlayerController.irA].
/// - Botón play/pause → llama a [PlayerController.alternarPlayPause].
/// - Toque simple en anterior → [PlayerController.reiniciar].
/// - Doble tap en anterior → [PlayerController.cancionAnterior].
/// - Toque simple en siguiente → [PlayerController.adelantar] (10 s).
/// - Doble tap en siguiente → [PlayerController.cancionSiguiente].

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musica/controllers/player_controller.dart';

/// Vista del reproductor de música.
///
/// Es un [StatelessWidget] porque todo el estado vive en [PlayerController].
/// Usa el widget [Obx] de GetX para reconstruirse automáticamente cuando
/// cambian los valores reactivos del controlador (posición, canción, etc.).
class DescriptionTrack extends StatelessWidget {
  const DescriptionTrack({super.key});

  /// Formatea una [Duration] en el formato "m:ss".
  ///
  /// Ejemplos:
  /// - `Duration(seconds: 90)` → `"1:30"`
  /// - `Duration(seconds: 5)`  → `"0:05"`
  ///
  /// **Parámetros:**
  /// - [d]: duración a formatear.
  ///
  /// **Retorna:** String con formato "minutos:segundos" (segundos siempre 2 dígitos).
  ///
  /// **Llamado desde:** [build] para mostrar el tiempo transcurrido y la duración total.
  String _formatear(Duration d) {
    final min = d.inMinutes.remainder(60);
    final sec = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$min:$sec';
  }

  /// Construye la pantalla completa del reproductor de música.
  ///
  /// La estructura principal es:
  /// ```
  /// Scaffold
  /// ├── AppBar (transparente con botón de regreso)
  /// └── Obx (reactivo al PlayerController)
  ///     └── Padding
  ///         └── Column
  ///             ├── Portada del álbum (CachedNetworkImage 600×600)
  ///             ├── Nombre de la canción
  ///             ├── Nombre del artista
  ///             ├── Slider de progreso (con SliderTheme verde)
  ///             ├── Tiempos (transcurrido / total)
  ///             └── Botones de control (anterior, play/pause, siguiente)
  /// ```
  ///
  /// El [Obx] envuelve todo el cuerpo para que la pantalla se reconstruya
  /// automáticamente cuando cambia [PlayerController.cancion],
  /// [PlayerController.posicion], [PlayerController.duracion], o
  /// [PlayerController.estaReproduciendo].
  @override
  Widget build(BuildContext context) {
    // Obtiene el PlayerController registrado en GetX por CardTrack.
    final controller = Get.find<PlayerController>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          // Regresa a la pantalla anterior (HomeView) sin destruir PlayerController.
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        // Lee la canción actual del controlador (puede ser null si no hay ninguna).
        final cancion = controller.cancion.value;
        if (cancion == null) {
          return const Center(child: Text('No hay canción seleccionada'));
        }

        // Calcula los valores del slider de progreso.
        final duracionTotal = controller.duracion.value ?? Duration.zero;
        final posicionActual = controller.posicion.value;

        // Valor máximo del slider: al menos 1.0 para evitar división por cero.
        final maxSlider = duracionTotal.inSeconds > 0
            ? duracionTotal.inSeconds.toDouble()
            : 1.0;

        // Valor actual del slider: siempre dentro del rango [0, maxSlider].
        final valorSlider =
            posicionActual.inSeconds.toDouble().clamp(0.0, maxSlider);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const SizedBox(height: 16),

              // ─── Portada del álbum ────────────────────────────────────────
              // La URL base de artworkUrl100 usa "100x100"; la reemplazamos
              // por "600x600" para obtener una imagen de alta resolución.
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: cancion.artworkUrl100 != null &&
                        cancion.artworkUrl100!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: cancion.artworkUrl100!
                            .replaceAll('100x100', '600x600'),
                        width: 280,
                        height: 280,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => _placeholderAlbum(context),
                        errorWidget: (_, __, ___) =>
                            _placeholderAlbum(context),
                      )
                    : _placeholderAlbum(context),
              ),

              const SizedBox(height: 32),

              // ─── Nombre de la canción ─────────────────────────────────────
              Text(
                cancion.trackName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              // ─── Nombre del artista ───────────────────────────────────────
              Text(
                cancion.artistName,
                style: TextStyle(
                  fontSize: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // ─── Slider de progreso ───────────────────────────────────────
              // SliderTheme personaliza los colores del slider.
              // Al arrastrar, llama a PlayerController.irA con el nuevo tiempo.
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.green,
                  inactiveTrackColor: Colors.green.withOpacity(0.3),
                  thumbColor: Colors.green,
                  overlayColor: Colors.green.withOpacity(0.2),
                ),
                child: Slider(
                  value: valorSlider,
                  max: maxSlider,
                  onChanged: (valor) =>
                      controller.irA(Duration(seconds: valor.toInt())),
                ),
              ),

              // ─── Tiempos transcurrido / total ─────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatear(posicionActual),
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      _formatear(duracionTotal),
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ─── Botones de control ───────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Botón anterior:
                  // - Toque simple → reinicia la canción desde el principio.
                  // - Doble tap → va a la canción anterior de la lista.
                  GestureDetector(
                    onDoubleTap: controller.cancionAnterior,
                    child: IconButton(
                      iconSize: 40,
                      icon: const Icon(Icons.skip_previous),
                      onPressed: controller.reiniciar,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Botón play/pause:
                  // - Muestra CircularProgressIndicator mientras carga el audio.
                  // - Muestra ícono de pausa si está reproduciendo.
                  // - Muestra ícono de play si está pausado.
                  controller.cargando.value
                      ? const CircularProgressIndicator(color: Colors.green)
                      : IconButton(
                          iconSize: 64,
                          icon: Icon(
                            controller.estaReproduciendo.value
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_filled,
                            color: Colors.green,
                          ),
                          onPressed: controller.alternarPlayPause,
                        ),
                  const SizedBox(width: 16),

                  // Botón siguiente:
                  // - Toque simple → adelanta 10 segundos.
                  // - Doble tap → va a la siguiente canción de la lista.
                  GestureDetector(
                    onDoubleTap: controller.cancionSiguiente,
                    child: IconButton(
                      iconSize: 40,
                      icon: const Icon(Icons.skip_next),
                      onPressed: controller.adelantar,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  /// Construye un placeholder grande con fondo gris y ícono de nota musical.
  ///
  /// Se muestra mientras la portada del álbum se descarga desde la red,
  /// o si la URL está vacía o hay un error al cargar la imagen.
  ///
  /// **Parámetros:**
  /// - [context]: contexto de Flutter para acceder a los colores del tema.
  ///
  /// **Retorna:** un [Container] cuadrado de 280×280 px con bordes redondeados.
  ///
  /// **Llamado desde:** [build] como `placeholder` y `errorWidget` de
  /// [CachedNetworkImage], y como fallback cuando la URL está vacía.
  Widget _placeholderAlbum(BuildContext context) => Container(
        width: 280,
        height: 280,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          Icons.music_note,
          size: 80,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
}
