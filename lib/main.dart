/// Punto de entrada principal de la aplicación MusicPlayer.
///
/// Este archivo inicializa los servicios necesarios y lanza la aplicación Flutter.
/// Es el primer archivo que se ejecuta cuando arranca la app.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musica/controllers/home_controller.dart';
import 'package:musica/core/theme/app_theme.dart';
import 'package:musica/services/itunes_service.dart';
import 'package:musica/views/home_view.dart';

/// Función principal de Dart que Flutter llama al iniciar la app.
///
/// Antes de lanzar la interfaz gráfica, registra [ItunesService] en el
/// contenedor de dependencias de GetX con [Get.put], de modo que cualquier
/// parte de la app pueda obtener la instancia con [Get.find].
///
/// Luego llama a [runApp] con el widget raíz [MusicPlayer].
void main() {
  // Registra ItunesService globalmente para que esté disponible desde cualquier
  // controlador o vista a través de Get.find<ItunesService>().
  Get.put(ItunesService());
  runApp(const MusicPlayer());
}

/// Widget raíz de la aplicación.
///
/// Extiende [StatelessWidget] porque la configuración de la app no cambia.
/// Utiliza [GetMaterialApp] (del paquete get) en lugar del [MaterialApp]
/// estándar para habilitar la navegación reactiva y la gestión de estado
/// de GetX sin necesidad de [BuildContext].
///
/// **Llamado desde:** [main]
class MusicPlayer extends StatelessWidget {
  const MusicPlayer({super.key});

  /// Construye el árbol de widgets de la aplicación.
  ///
  /// Configura:
  /// - [title]: nombre visible en el administrador de tareas del sistema.
  /// - [theme]: tema visual claro definido en [AppTheme.light].
  /// - [home]: pantalla inicial, [HomeView].
  /// - [initialBinding]: registra [HomeController] de forma diferida (lazyPut)
  ///   para que se cree solo cuando se necesite por primera vez.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'MusicPlayer',
      theme: AppTheme.light,
      home: HomeView(),
      // initialBinding registra HomeController de forma perezosa (lazy):
      // se instancia solo cuando la vista lo solicita con Get.find<HomeController>().
      initialBinding: BindingsBuilder(
        () => Get.lazyPut<HomeController>(HomeController.new),
      ),
    );
  }
}




