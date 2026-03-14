
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musica/controllers/home_controller.dart';
import 'package:musica/controllers/player_controller.dart';
import 'package:musica/models/track_model.dart';
import 'package:musica/views/description_track.dart';

class CardTrack extends StatelessWidget {
  final TrackModel cancion;

  const CardTrack({super.key, required this.cancion});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!Get.isRegistered<PlayerController>()) {
          Get.put(PlayerController());
        }
        final home = Get.find<HomeController>();
        final lista = home.ultimaBusqueda.isNotEmpty
            ? home.canciones.toList()
            : home.cancionesPopulares.toList();
        final indice = lista.indexOf(cancion);
        Get.find<PlayerController>().reproducir(cancion, lista: lista, indice: indice);
        Get.to(() => DescriptionTrack());
      },
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: cancion.artistViewUrl != null && cancion.artistViewUrl!.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: cancion.artistViewUrl!,
                  width: 56,
                  height: 56,
                  fit: BoxFit.contain,
                  placeholder: (_, __) => _placeholderAlbum(context),
                  errorWidget: (_, __, ___) => _placeholderAlbum(context),
                )
              : _placeholderAlbum(context),
        ),
        title: Text(
          cancion.trackName,
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          cancion.artistName,
          style: TextStyle(
            fontSize: 13,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${(cancion.trackTimeMillis ~/ 60000)}:${((cancion.trackTimeMillis % 60000) ~/ 1000).toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.play_circle_outline, color: Colors.green),
              onPressed: null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholderAlbum(BuildContext context) => Container(
        width: 56,
        height: 56,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Icon(Icons.music_note, color: Theme.of(context).colorScheme.onSurfaceVariant),
      );
}
