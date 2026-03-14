/// Pantalla principal de la aplicación MusicPlayer.
///
/// Muestra una barra de búsqueda y una lista de canciones. Cuando el usuario
/// no ha escrito nada, se muestran canciones populares de Rock. Cuando escribe
/// en la barra de búsqueda, se muestran los resultados de la búsqueda.
///
/// **Dependencias:**
/// - [HomeController]: provee los datos reactivos (canciones, estado de carga, errores).
/// - [SearchBarCustom]: widget de búsqueda con debounce.
/// - [CardTrack]: widget de cada fila de canción en la lista.
///
/// **Navegación:**
/// - Esta es la pantalla inicial (`home:`) configurada en [MusicPlayer].
/// - Al tocar una [CardTrack], se navega a [DescriptionTrack].

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musica/controllers/home_controller.dart';
import 'package:musica/views/card_track.dart';
import 'package:musica/views/search_bar.dart';

/// Vista principal de la aplicación.
///
/// Es un [StatelessWidget] porque todo el estado vive en [HomeController]
/// (GetX se encarga de reconstruir los widgets reactivos).
///
/// Usa [CustomScrollView] con slivers para poder combinar elementos fijos
/// (encabezado y barra de búsqueda) con una lista de longitud variable de forma
/// eficiente en memoria.
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  /// Construye el árbol de widgets de la pantalla principal.
  ///
  /// Estructura:
  /// ```
  /// Scaffold
  /// └── SafeArea              ← evita solaparse con notch/statusbar
  ///     └── CustomScrollView  ← scroll general de la pantalla
  ///         ├── Encabezado    ← título "Explorar" y subtítulo
  ///         ├── SearchBarCustom ← barra de búsqueda
  ///         ├── SizedBox      ← espaciado
  ///         └── Obx(...)      ← sección reactiva: populares o resultados
  /// ```
  ///
  /// El widget [Obx] observa los valores reactivos de [HomeController]
  /// y llama a [_construirContenido] cada vez que cambian.
  @override
  Widget build(BuildContext context) {
    // Obtiene la instancia del HomeController registrada en GetX.
    // GetX lanza un error si no encuentra el controlador registrado.
    final controller = Get.find<HomeController>();
    return Scaffold(
      body: SafeArea(
        // SafeArea impide que el contenido se dibuje detrás del notch
        // (muesca de la cámara), la barra de estado, etc.
        child: CustomScrollView(
          // CustomScrollView permite mezclar distintos tipos de slivers
          // (elementos desplazables) en un solo scroll.
          slivers: [
            // Encabezado con título y subtítulo de la app.
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Explorar',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Descubre más música en iTunes',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),

            // Barra de búsqueda. Recibe el controlador para poder llamar
            // a buscarCancionDebounce cuando el usuario escribe.
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SearchBarCustom(homeController: controller),
              ),
            ),

            // Espaciado entre la barra de búsqueda y la lista.
            SliverToBoxAdapter(
              child: SizedBox(height: 24),
            ),

            // Sección reactiva: se reconstruye cuando cambian los datos
            // del HomeController (nuevas canciones, errores, etc.).
            Obx(() => _construirContenido(context, controller))
          ],
        ),
      ),
    );
  }

  /// Decide qué contenido mostrar según el estado actual del controlador.
  ///
  /// Retorna un sliver (elemento compatible con [CustomScrollView]) que puede ser:
  ///
  /// 1. **Lista de resultados de búsqueda** — cuando [HomeController.ultimaBusqueda]
  ///    no está vacío y [HomeController.canciones] tiene datos.
  /// 2. **Mensaje de error** — cuando hay texto de búsqueda pero ocurrió un error.
  /// 3. **"No hay canciones"** — cuando hay texto de búsqueda pero no hay resultados.
  /// 4. **Lista de canciones populares** — cuando el usuario no ha buscado nada.
  ///
  /// **Parámetros:**
  /// - [context]: contexto de Flutter necesario para acceder al tema.
  /// - [controlador]: instancia de [HomeController] con el estado actual.
  ///
  /// **Retorna:** un widget sliver que se inserta en el [CustomScrollView].
  ///
  /// **Llamado desde:** el callback del widget [Obx] en [build].
  Widget _construirContenido(
      BuildContext context, HomeController controlador) {
    // Caso 1: El usuario escribió algo en la búsqueda.
    if (controlador.ultimaBusqueda.isNotEmpty) {
      // Sub-caso A: Hubo un error en la petición.
      if (controlador.mensajeError.isNotEmpty) {
        return SliverFillRemaining(
          child: Center(child: Text(controlador.mensajeError.value)),
        );
      }

      // Sub-caso B: La búsqueda no devolvió resultados.
      if (controlador.canciones.isEmpty) {
        return SliverFillRemaining(
          child: Center(child: Text('No hay canciones')),
        );
      }

      // Sub-caso C: Hay resultados de búsqueda — muestra la lista.
      return SliverMainAxisGroup(slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Resultados de búsqueda',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
            ),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 20)),
        // SliverList construye las filas de forma perezosa (solo las visibles),
        // ideal para listas largas.
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, indice) =>
                CardTrack(cancion: controlador.canciones[indice]),
            childCount: controlador.canciones.length,
          ),
        ),
      ]);
    }

    // Caso 2: Sin búsqueda activa — muestra canciones populares.
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
            child: Text(
              'Popular',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: 25,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(height: 20),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, indice) =>
                CardTrack(cancion: controlador.cancionesPopulares[indice]),
            childCount: controlador.cancionesPopulares.length,
          ),
        ),
      ],
    );
  }
}

