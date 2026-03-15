
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:musica/models/album_model.dart';

class CardAlbum extends StatelessWidget {
  final AlbumModel album;

  const CardAlbum({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: album.artworkUrl60.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: album.artworkUrl60,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                placeholder: (_, __) => _placeholderAlbum(context),
                errorWidget: (_, __, ___) => _placeholderAlbum(context),
              )
            : _placeholderAlbum(context),
      ),
      title: Text(
        album.collectionName,
        style: const TextStyle(fontWeight: FontWeight.w500),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${album.anio}  •  ${album.trackCount} canciones  •  ${album.primaryGenreName}',
        style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
      ),
      trailing: Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
    );
  }

  Widget _placeholderAlbum(BuildContext context) => Container(
        width: 56,
        height: 56,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Icon(
          Icons.album,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
}
