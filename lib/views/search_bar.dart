/// Widget de barra de búsqueda personalizada con debounce.
///
/// Este widget provee el campo de texto donde el usuario escribe el nombre
/// del artista o canción a buscar. Internamente gestiona el texto con un
/// [TextEditingController] y delega la lógica de búsqueda al [HomeController].
///
/// **Características:**
/// - Botón de limpiar (✕) que aparece solo cuando hay texto escrito.
/// - Ícono de búsqueda a la izquierda.
/// - Llama a [HomeController.buscarCancionDebounce] en cada cambio de texto.
///
/// **Llamado desde:** [HomeView.build].

import 'package:flutter/material.dart';
import 'package:musica/controllers/home_controller.dart';

/// Barra de búsqueda personalizada para buscar canciones en iTunes.
///
/// Es un [StatefulWidget] porque necesita mantener el estado del texto
/// ingresado ([TextEditingController]) y reconstruir la UI cuando el usuario
/// escribe o limpia el campo (para mostrar/ocultar el botón de limpiar).
class SearchBarCustom extends StatefulWidget {
  const SearchBarCustom({super.key, required this.homeController});

  /// Controlador de la pantalla principal.
  ///
  /// Se usa para llamar a [HomeController.buscarCancionDebounce] cuando
  /// el usuario escribe, y para limpiar la búsqueda cuando presiona el botón ✕.
  final HomeController homeController;

  @override
  State<SearchBarCustom> createState() => _SearchBarCustomState();
}

/// Estado interno del widget [SearchBarCustom].
///
/// Gestiona el [TextEditingController] que controla el texto del campo
/// y reacciona a los eventos de escritura y limpieza.
class _SearchBarCustomState extends State<SearchBarCustom> {
  /// Controlador del campo de texto.
  ///
  /// Permite leer el texto actual con `_textoController.text` y limpiarlo
  /// programáticamente con `_textoController.clear()`.
  /// Debe liberarse en [dispose] para evitar fugas de memoria.
  final TextEditingController _textoController = TextEditingController();

  /// Libera los recursos del [TextEditingController] cuando se destruye el widget.
  ///
  /// Es fundamental llamar a `dispose()` para que Flutter libere la memoria
  /// del controlador de texto.
  ///
  /// **Llamado por:** Flutter automáticamente cuando el widget se elimina del árbol.
  @override
  void dispose() {
    _textoController.dispose();
    super.dispose();
  }

  /// Maneja los cambios de texto en el campo de búsqueda.
  ///
  /// Se llama automáticamente con `onChanged` del [TextField] cada vez que
  /// el usuario escribe o borra un carácter.
  ///
  /// Llama a [setState] para que Flutter reconstruya el widget y actualice
  /// la visibilidad del botón de limpiar.
  /// Luego delega la búsqueda al [HomeController.buscarCancionDebounce].
  ///
  /// **Parámetros:**
  /// - [valor]: texto actual del campo de búsqueda.
  ///
  /// **Llamado desde:** el callback `onChanged` del [TextField].
  void _alBuscar(String valor) {
    setState(() {});
    widget.homeController.buscarCancionDebounce(valor);
  }

  /// Limpia el campo de texto y resetea la búsqueda.
  ///
  /// Borra el texto del [TextField] con `_textoController.clear()`,
  /// fuerza una reconstrucción del widget con [setState] para ocultar
  /// el botón de limpiar, y notifica al [HomeController] que la búsqueda
  /// está vacía llamando a [HomeController.buscarCancionDebounce] con `''`.
  ///
  /// **Llamado desde:** el callback `onPressed` del [IconButton] de limpiar.
  void _limpiar() {
    _textoController.clear();
    setState(() {});
    widget.homeController.buscarCancionDebounce('');
  }

  /// Construye el widget de la barra de búsqueda.
  ///
  /// Renderiza un [Container] con fondo redondeado que contiene un [TextField].
  ///
  /// - `prefixIcon`: ícono de lupa siempre visible.
  /// - `suffixIcon`: botón ✕ que solo aparece si hay texto (`hayTexto == true`).
  /// - `onChanged`: vinculado a [_alBuscar] para reaccionar a cada pulsación.
  /// - `controller`: [_textoController] para controlar y leer el texto.
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // Determina si se debe mostrar el botón de limpiar.
    final hayTexto = _textoController.text.isNotEmpty;

    return Container(
      margin: EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(2),
      ),
      child: TextField(
        controller: _textoController,
        onChanged: _alBuscar,
        decoration: InputDecoration(
          hintText: 'Buscar artistas',
          prefixIcon:
              Icon(Icons.search, color: colorScheme.onSurfaceVariant),
          // El botón de limpiar aparece solo cuando hay texto escrito.
          suffixIcon: hayTexto
              ? IconButton(
                  icon:
                      Icon(Icons.close, color: colorScheme.onSurfaceVariant),
                  onPressed: _limpiar,
                )
              : null,
          hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
          labelText: 'Buscar canciones',
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        style: TextStyle(color: colorScheme.onSurface),
      ),
    );
  }
}
