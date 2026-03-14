
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

  void _alBuscar(String valor){
    setState(() { });
    widget.homeController.buscarCancionDebounce(valor);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,// pequeño resalte, segun el tema de la aplicacion
        borderRadius: BorderRadius.circular(2)
      ),
      child: TextField(
        onChanged: _alBuscar, //metodo que dispara la accion
        decoration: InputDecoration(
          hintText: 'Buscar artistas',
          prefixIcon: Icon(Icons.search, color: colorScheme.onSurfaceVariant,),
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

