
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musica/controllers/album_controller.dart';
import 'package:musica/views/card_album.dart';

class AlbumsView extends StatelessWidget {
  const AlbumsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AlbumController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Text(
          controller.artistName,
          style: const TextStyle(fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Obx(() {
        if (controller.cargando.value) {
          return const Center(child: CircularProgressIndicator(color: Colors.green));
        }

        if (controller.mensajeError.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                const SizedBox(height: 12),
                Text(controller.mensajeError.value, textAlign: TextAlign.center),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: controller.cargarAlbumes,
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        if (controller.albumes.isEmpty) {
          return const Center(
            child: Text('No se encontraron álbumes'),
          );
        }

        return ListView.builder(
          itemCount: controller.albumes.length,
          itemBuilder: (_, index) => CardAlbum(album: controller.albumes[index]),
        );
      }),
    );
  }
}
