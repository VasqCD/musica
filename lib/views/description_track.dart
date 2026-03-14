
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musica/controllers/player_controller.dart';

class DescriptionTrack extends StatelessWidget {
  const DescriptionTrack({super.key});

  String _formatear(Duration d) {
    final min = d.inMinutes.remainder(60);
    final sec = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$min:$sec';
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PlayerController>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        final cancion = controller.cancion.value;
        if (cancion == null) {
          return const Center(child: Text('No hay canción seleccionada'));
        }

        final duracionTotal = controller.duracion.value ?? Duration.zero;
        final posicionActual = controller.posicion.value;
        final maxSlider = duracionTotal.inSeconds > 0
            ? duracionTotal.inSeconds.toDouble()
            : 1.0;
        final valorSlider = posicionActual.inSeconds
            .toDouble()
            .clamp(0.0, maxSlider);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const SizedBox(height: 16),

              // Imagen del álbum
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
                        errorWidget: (_, __, ___) => _placeholderAlbum(context),
                      )
                    : _placeholderAlbum(context),
              ),

              const SizedBox(height: 32),

              // Nombre de la canción
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

              // Nombre del artista
              Text(
                cancion.artistName,
                style: TextStyle(
                  fontSize: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Slider de progreso
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

              // Tiempos
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

              // Botones de control
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 40,
                    icon: const Icon(Icons.skip_previous),
                    onPressed: null,
                  ),
                  const SizedBox(width: 16),
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
                  IconButton(
                    iconSize: 40,
                    icon: const Icon(Icons.skip_next),
                    onPressed: null,
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

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
