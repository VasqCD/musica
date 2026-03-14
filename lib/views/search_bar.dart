
import 'package:flutter/material.dart';
import 'package:musica/controllers/home_controller.dart';

class SearchBarCustom extends StatefulWidget {
  const SearchBarCustom({super.key, required this.homeController});
  //recibiendo el home controller
  final HomeController homeController;

  @override
  State<SearchBarCustom> createState() => _SearchBarCustomState();
}

class _SearchBarCustomState extends State<SearchBarCustom> {

  final TextEditingController _textoController = TextEditingController();

  @override
  void dispose() {
    _textoController.dispose();
    super.dispose();
  }

  void _alBuscar(String valor) {
    setState(() {});
    widget.homeController.buscarCancionDebounce(valor);
  }

  void _limpiar() {
    _textoController.clear();
    setState(() {});
    widget.homeController.buscarCancionDebounce('');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hayTexto = _textoController.text.isNotEmpty;

    return Container(
      margin: EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(2)
      ),
      child: TextField(
        controller: _textoController,
        onChanged: _alBuscar,
        decoration: InputDecoration(
          hintText: 'Buscar artistas',
          prefixIcon: Icon(Icons.search, color: colorScheme.onSurfaceVariant),
          suffixIcon: hayTexto
              ? IconButton(
                  icon: Icon(Icons.close, color: colorScheme.onSurfaceVariant),
                  onPressed: _limpiar,
                )
              : null,
          hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
          labelText: 'Buscar canciones',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14)
        ),
        style: TextStyle(color: colorScheme.onSurface),
      ),
    );
  }
}
